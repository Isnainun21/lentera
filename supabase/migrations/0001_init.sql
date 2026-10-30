-- Skema server Lentera. Lihat DOCSS/04-ARSITEKTUR-DAN-BACKEND.md.
-- Audio dan teks hasil pengenalan ucapan sengaja tidak punya kolom di sini.

create table guardians (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text not null default '',
  role text not null default 'parent' check (role in ('parent', 'teacher')),
  created_at timestamptz not null default now()
);

create function handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into guardians (id, display_name, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'display_name', ''),
    case when new.raw_user_meta_data ->> 'role' = 'teacher' then 'teacher' else 'parent' end
  );
  return new;
end $$;

create trigger on_auth_user_created after insert on auth.users
for each row execute function handle_new_user();

create table children (
  id uuid primary key,
  owner_guardian_id uuid not null default auth.uid() references guardians (id) on delete cascade,
  nickname text not null,
  avatar_id int not null,
  settings text not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  server_updated_at timestamptz not null default now()
);

create table classes (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid not null references guardians (id) on delete cascade,
  name text not null,
  join_code text not null unique default upper(substr(md5(gen_random_uuid()::text), 1, 6)),
  created_at timestamptz not null default now()
);

create table guardian_children (
  guardian_id uuid not null references guardians (id) on delete cascade,
  child_id uuid not null references children (id) on delete cascade,
  class_id uuid references classes (id) on delete cascade,
  role text not null check (role in ('owner', 'teacher')),
  granted_by uuid not null references guardians (id),
  revoked_at timestamptz,
  primary key (guardian_id, child_id)
);

create table consents (
  id uuid primary key,
  child_id uuid not null references children (id) on delete cascade,
  guardian_id uuid not null default auth.uid() references guardians (id),
  version text not null,
  granted_at timestamptz not null,
  revoked_at timestamptz,
  server_updated_at timestamptz not null default now()
);

create table practice_sessions (
  id uuid primary key,
  child_id uuid not null references children (id) on delete cascade,
  kind text not null,
  start_level int not null,
  end_level int,
  planned_words int not null,
  started_at timestamptz not null,
  ended_at timestamptz,
  server_updated_at timestamptz not null default now()
);

create table attempts (
  id uuid primary key,
  session_id uuid not null references practice_sessions (id) on delete cascade,
  child_id uuid not null references children (id) on delete cascade,
  word_id text not null,
  content_version int not null,
  try_number int not null,
  status text not null check (status in ('correct', 'partial', 'wrong', 'unclear')),
  matched_syllables jsonb not null,
  confidence real,
  engine text not null,
  finished boolean not null,
  assisted boolean not null,
  guardian_override boolean not null,
  occurred_at timestamptz not null,
  server_updated_at timestamptz not null default now()
);

create table level_events (
  id uuid primary key,
  child_id uuid not null references children (id) on delete cascade,
  from_level int,
  to_level int not null check (to_level between 1 and 5),
  reason text not null,
  actor text not null,
  occurred_at timestamptz not null,
  server_updated_at timestamptz not null default now()
);

create table story_progress (
  child_id uuid not null references children (id) on delete cascade,
  story_id text not null,
  page int not null,
  completed_at timestamptz,
  updated_at timestamptz not null,
  server_updated_at timestamptz not null default now(),
  primary key (child_id, story_id)
);

create table reward_events (
  id uuid primary key,
  child_id uuid not null references children (id) on delete cascade,
  kind text not null,
  source_id text not null,
  occurred_at timestamptz not null,
  server_updated_at timestamptz not null default now(),
  unique (child_id, kind, source_id)
);

create index on attempts (child_id, server_updated_at);
create index on practice_sessions (child_id, server_updated_at);
create index on level_events (child_id, server_updated_at);
create index on reward_events (child_id, server_updated_at);
create index on story_progress (child_id, server_updated_at);
create index on consents (child_id, server_updated_at);
create index on children (server_updated_at);

-- Waktu server untuk cursor sinkron, agar tidak bergantung pada jam perangkat.
create function touch_server_time() returns trigger language plpgsql as $$
begin
  new.server_updated_at = now();
  return new;
end $$;

create trigger touch before insert or update on children for each row execute function touch_server_time();
create trigger touch before insert or update on consents for each row execute function touch_server_time();
create trigger touch before insert or update on practice_sessions for each row execute function touch_server_time();
create trigger touch before insert or update on attempts for each row execute function touch_server_time();
create trigger touch before insert or update on level_events for each row execute function touch_server_time();
create trigger touch before insert or update on story_progress for each row execute function touch_server_time();
create trigger touch before insert or update on reward_events for each row execute function touch_server_time();

-- Aturan konflik di server: pengaturan terbaru menang, penghapusan selalu menang.
create function resolve_child_conflict() returns trigger language plpgsql as $$
begin
  if old.deleted_at is not null then
    new.deleted_at = old.deleted_at;
  end if;
  if new.deleted_at is null and new.updated_at < old.updated_at then
    new.settings = old.settings;
    new.nickname = old.nickname;
    new.avatar_id = old.avatar_id;
    new.updated_at = old.updated_at;
  end if;
  new.owner_guardian_id = old.owner_guardian_id;
  return new;
end $$;

create trigger resolve_conflict before update on children
for each row execute function resolve_child_conflict();

-- Halaman terjauh menang.
create function resolve_story_conflict() returns trigger language plpgsql as $$
begin
  new.page = greatest(new.page, old.page);
  new.completed_at = coalesce(old.completed_at, new.completed_at);
  return new;
end $$;

create trigger resolve_conflict before update on story_progress
for each row execute function resolve_story_conflict();

-- Sesi yang sudah ditutup tidak bisa dibuka kembali.
create function resolve_session_conflict() returns trigger language plpgsql as $$
begin
  if old.ended_at is not null then
    new.ended_at = old.ended_at;
    new.end_level = old.end_level;
  end if;
  return new;
end $$;

create trigger resolve_conflict before update on practice_sessions
for each row execute function resolve_session_conflict();

-- Pemilik anak otomatis terdaftar sebagai pendamping.
create function link_child_owner() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into guardian_children (guardian_id, child_id, role, granted_by)
  values (new.owner_guardian_id, new.id, 'owner', new.owner_guardian_id)
  on conflict do nothing;
  return new;
end $$;

create trigger link_owner after insert on children
for each row execute function link_child_owner();

-- Pemeriksaan akses. security definer agar kebijakan tidak saling memanggil tanpa henti.
create function can_read_child(p_child uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from guardian_children
    where child_id = p_child and guardian_id = auth.uid() and revoked_at is null
  );
$$;

create function owns_child(p_child uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from children where id = p_child and owner_guardian_id = auth.uid()
  );
$$;

alter table guardians enable row level security;
alter table children enable row level security;
alter table classes enable row level security;
alter table guardian_children enable row level security;
alter table consents enable row level security;
alter table practice_sessions enable row level security;
alter table attempts enable row level security;
alter table level_events enable row level security;
alter table story_progress enable row level security;
alter table reward_events enable row level security;

create policy self_read on guardians for select using (id = auth.uid());
create policy self_update on guardians for update using (id = auth.uid())
  with check (id = auth.uid() and role = (select role from guardians where id = auth.uid()));

create policy read_child on children for select using (owner_guardian_id = auth.uid() or can_read_child(id));
create policy insert_child on children for insert with check (owner_guardian_id = auth.uid());
create policy update_child on children for update using (owner_guardian_id = auth.uid());

create policy teacher_classes on classes for all using (teacher_id = auth.uid()) with check (
  teacher_id = auth.uid() and exists (select 1 from guardians where id = auth.uid() and role = 'teacher')
);

create policy read_links on guardian_children for select using (guardian_id = auth.uid() or owns_child(child_id));

-- Tabel data: pendamping berizin boleh membaca, hanya pemilik yang boleh menulis.
create policy read_data on consents for select using (can_read_child(child_id));
create policy write_data on consents for insert with check (owns_child(child_id));
create policy read_data on practice_sessions for select using (can_read_child(child_id));
create policy write_data on practice_sessions for insert with check (owns_child(child_id));
create policy update_data on practice_sessions for update using (owns_child(child_id));
create policy read_data on attempts for select using (can_read_child(child_id));
create policy write_data on attempts for insert with check (owns_child(child_id));
create policy read_data on level_events for select using (can_read_child(child_id));
create policy write_data on level_events for insert with check (owns_child(child_id));
create policy read_data on story_progress for select using (can_read_child(child_id));
create policy write_data on story_progress for insert with check (owns_child(child_id));
create policy update_data on story_progress for update using (owns_child(child_id));
create policy read_data on reward_events for select using (can_read_child(child_id));
create policy write_data on reward_events for insert with check (owns_child(child_id));

-- Orang tua memberi izin lewat kode kelas. Hanya pemilik anak yang bisa memanggil.
create function join_class(p_child_id uuid, p_code text) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_class classes;
begin
  if not owns_child(p_child_id) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  select * into v_class from classes where join_code = upper(p_code);
  if not found then
    raise exception 'unknown class' using errcode = 'P0002';
  end if;
  insert into guardian_children (guardian_id, child_id, class_id, role, granted_by)
  values (v_class.teacher_id, p_child_id, v_class.id, 'teacher', auth.uid())
  on conflict (guardian_id, child_id)
  do update set revoked_at = null, class_id = excluded.class_id, granted_by = excluded.granted_by;
  return v_class.id;
end $$;

create function leave_class(p_child_id uuid, p_class_id uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not owns_child(p_child_id) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  update guardian_children set revoked_at = now()
  where child_id = p_child_id and class_id = p_class_id;
end $$;

-- Penghapusan permanen dijalankan berkala dengan service role (mis. pg_cron) setelah masa tunggu.
create function purge_deleted_children() returns void
language sql security definer set search_path = public as $$
  delete from children where deleted_at < now() - interval '30 days';
$$;
revoke execute on function purge_deleted_children() from public, anon, authenticated;
