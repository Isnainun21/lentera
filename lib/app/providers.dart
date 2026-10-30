import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../content/content.dart';
import '../core/db/database.dart';
import '../core/db/repository.dart';
import '../core/speech/speech_ports.dart';
import '../core/sync/supabase_gateway.dart';
import '../core/sync/sync_engine.dart';
import '../domain/child.dart';
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
