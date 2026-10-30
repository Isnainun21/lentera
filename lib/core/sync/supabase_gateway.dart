import 'package:supabase_flutter/supabase_flutter.dart';

import 'sync_engine.dart';

/// Diisi saat build: --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static bool get configured => url.isNotEmpty && anonKey.isNotEmpty;
}

class SupabaseGateway implements SyncGateway {
  SupabaseGateway(this.client);

  final SupabaseClient client;

  static const _conflictKeys = {'story_progress': 'child_id,story_id'};
  static const _appendOnly = {'attempts', 'level_events', 'reward_events', 'consents'};

  @override
  bool get signedIn => client.auth.currentSession != null;

  @override
  Future<void> push(String table, List<Map<String, dynamic>> rows) async {
    try {
      await client.from(table).upsert(
            rows,
            onConflict: _conflictKeys[table] ?? 'id',
            ignoreDuplicates: _appendOnly.contains(table),
          );
    } on PostgrestException catch (e) {
      // Kode 42501 berarti ditolak RLS, jadi percuma dicoba ulang.
      if (e.code == '42501') throw SyncRejected(e.message);
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> pull(String table, String? cursor) async {
    var query = client.from(table).select();
    if (cursor != null) query = query.gte('server_updated_at', cursor);
    final rows = await query.order('server_updated_at').limit(1000);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> joinClass(String childId, String code) =>
      client.rpc('join_class', params: {'p_child_id': childId, 'p_code': code});

  Future<List<Map<String, dynamic>>> myClasses() async =>
      List<Map<String, dynamic>>.from(await client.from('classes').select());

  Future<void> createClass(String name) =>
      client.from('classes').insert({'name': name, 'teacher_id': client.auth.currentUser!.id});

  Future<void> revokeClass(String childId, String classId) =>
      client.rpc('leave_class', params: {'p_child_id': childId, 'p_class_id': classId});
}
