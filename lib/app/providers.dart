import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../content/content.dart';
import '../core/db/database.dart';
import '../core/db/repository.dart';
import '../core/design/tokens.dart';
import '../core/speech/speech_ports.dart';
import '../core/sync/supabase_gateway.dart';
import '../core/sync/sync_engine.dart';
import '../domain/child.dart';
import '../domain/practice/models.dart';
import '../domain/progress/stats.dart';

// Diisi di main dan di tes lewat override.
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError());
final contentProvider = Provider<Content>((ref) => throw UnimplementedError());
final recognizerProvider = Provider<SpeechRecognizer>((ref) => DeviceSpeechRecognizer());
final speakerProvider = Provider<Speaker>((ref) => DeviceSpeaker());

final repositoryProvider = Provider<Repository>((ref) => Repository(ref.watch(databaseProvider)));

/// Null saat Supabase belum dikonfigurasi. Aplikasi tetap penuh secara lokal.
final supabaseGatewayProvider = Provider<SupabaseGateway?>((ref) {
  if (!SupabaseConfig.configured) return null;
  return SupabaseGateway(Supabase.instance.client);
});

final syncEngineProvider = Provider<SyncEngine?>((ref) {
  final gateway = ref.watch(supabaseGatewayProvider);
  if (gateway == null) return null;
  return SyncEngine(repo: ref.watch(repositoryProvider), gateway: gateway);
});

final childrenProvider = StreamProvider<List<ChildProfile>>((ref) => ref.watch(repositoryProvider).watchChildren());

final activeChildIdProvider = StreamProvider<String?>((ref) => ref.watch(repositoryProvider).watchKey('activeChild'));

final activeChildProvider = Provider<ChildProfile?>((ref) {
  final id = ref.watch(activeChildIdProvider).value;
  final children = ref.watch(childrenProvider).value ?? const [];
  for (final c in children) {
    if (c.id == id) return c;
  }
  return null;
});

final attemptsProvider = StreamProvider<List<AttemptRecord>>((ref) {
  final child = ref.watch(activeChildProvider);
  if (child == null) return Stream.value(const []);
  return ref.watch(repositoryProvider).watchAttempts(child.id);
});

final sessionsProvider = StreamProvider<List<PracticeSession>>((ref) {
  final child = ref.watch(activeChildProvider);
  if (child == null) return Stream.value(const []);
  return ref.watch(repositoryProvider).watchSessions(child.id);
});

final rewardsProvider = StreamProvider<List<RewardEvent>>((ref) {
  final child = ref.watch(activeChildProvider);
  if (child == null) return Stream.value(const []);
  return ref.watch(repositoryProvider).watchRewards(child.id);
});

final storyProgressProvider = StreamProvider<List<StoryProgressData>>((ref) {
  final child = ref.watch(activeChildProvider);
  if (child == null) return Stream.value(const []);
  return ref.watch(repositoryProvider).watchStoryProgress(child.id);
});

final hasOpenSessionProvider = StreamProvider<bool>((ref) {
  final child = ref.watch(activeChildProvider);
  if (child == null) return Stream.value(false);
  return ref.watch(repositoryProvider).watchHasOpenSession(child.id);
});

final weekLanternsProvider = Provider<List<bool>>((ref) {
  final sessions = ref.watch(sessionsProvider).value ?? const <PracticeSession>[];
  return ProgressStats.weekLanterns(
    sessions.where((s) => s.endedAt != null).map((s) => s.endedAt!),
    DateTime.now(),
  );
});

/// Kata yang dipilih pendamping untuk sesi berikutnya.
final priorityWordsProvider = NotifierProvider<PriorityWords, List<String>>(PriorityWords.new);

class PriorityWords extends Notifier<List<String>> {
  @override
  List<String> build() => const [];

  void add(String id) => state = {...state, id}.toList();
  void clear() => state = const [];
}

/// Jenis sesi per id, untuk mewarnai benang dan memisahkan statistik.
final sessionKindsProvider = Provider<Map<String, String>>((ref) {
  final sessions = ref.watch(sessionsProvider).value ?? const <PracticeSession>[];
  return {for (final s in sessions) s.id: s.kind};
});

/// Kain minggu ini: per hari (Senin = 0), satu warna benang untuk setiap kata atau soal yang selesai.
final weekClothProvider = Provider<List<List<Color>>>((ref) {
  final attempts = ref.watch(attemptsProvider).value ?? const <AttemptRecord>[];
  final kinds = ref.watch(sessionKindsProvider);
  final start = ProgressStats.startOfWeek(DateTime.now());
  final days = List.generate(7, (_) => <Color>[]);
  final seen = <String>{};
  final finished = attempts.where((a) => a.finished).toList()..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
  for (final a in finished) {
    if (!seen.add('${a.sessionId}|${a.wordId}')) continue;
    final local = a.occurredAt.toLocal();
    final index = DateTime(local.year, local.month, local.day).difference(start).inDays;
    if (index >= 0 && index < 7) days[index].add(Thread.forKind(kinds[a.sessionId] ?? 'reading'));
  }
  return days;
});

/// Kata yang pernah diselesaikan anak di latihan apa pun. Untuk Kamus Kataku, tanpa penilaian benar atau salah.
final learnedWordsProvider = Provider<List<Word>>((ref) {
  final attempts = ref.watch(attemptsProvider).value ?? const <AttemptRecord>[];
  final content = ref.watch(contentProvider);
  final ids = <String>{for (final a in attempts) if (a.finished) a.wordId};
  return [for (final w in content.words) if (ids.contains(w.id)) w];
});

/// Sesi baca yang belum selesai, untuk tombol Lanjut Baca dan slot benang di Beranda.
final resumableProvider = FutureProvider<ResumableSession?>((ref) async {
  final child = ref.watch(activeChildProvider);
  final open = ref.watch(hasOpenSessionProvider).value ?? false;
  if (child == null || !open) return null;
  return ref.watch(repositoryProvider).openSession(child.id, 'reading');
});
