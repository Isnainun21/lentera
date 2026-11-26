import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/responsive.dart';
import '../../core/design/tokens.dart';
import '../../domain/child.dart';
import 'guardian_screens.dart';
import 'report.dart';

class _Stepper extends StatelessWidget {
  const _Stepper({required this.label, required this.value, required this.min, required this.max, required this.onChanged, this.help});

  final String label;
  final String? help;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Panel(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppText.bodyStrong),
                  if (help != null) Text(help!, style: AppText.caption),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Kurangi $label',
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_rounded),
              style: IconButton.styleFrom(backgroundColor: Pal.of(context).surfaceAlt, minimumSize: const Size(48, 48)),
            ),
            SizedBox(width: 44, child: Text('$value', style: AppText.heading, textAlign: TextAlign.center)),
            IconButton(
              tooltip: 'Tambah $label',
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(backgroundColor: Pal.of(context).surfaceAlt, minimumSize: const Size(48, 48)),
            ),
          ],
        ),
      );
}

class LearningSettingsScreen extends ConsumerWidget {
  const LearningSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(activeChildProvider);
    if (child == null) return const Scaffold(body: SizedBox.shrink());
    final repo = ref.read(repositoryProvider);
    void update(ChildSettings s) => repo.updateSettings(child.id, s);
    final s = child.settings;
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan belajar')),
      body: PaneList(
        maxWidth: 760,
        children: [
          _Stepper(label: 'Level', value: child.level, min: 1, max: 5, onChanged: (v) => repo.setLevelByGuardian(child.id, v)),
          const SizedBox(height: 8),
          _Stepper(label: 'Kata per sesi', value: s.wordsPerSession, min: 3, max: 10, onChanged: (v) => update(s.copyWith(wordsPerSession: v))),
          const SizedBox(height: 8),
          _Stepper(label: 'Naik level', help: 'setelah sekian kata benar berturut-turut', value: s.raiseAfter, min: 2, max: 6, onChanged: (v) => update(s.copyWith(raiseAfter: v))),
          const SizedBox(height: 8),
          _Stepper(label: 'Turun level', help: 'setelah sekian kata belum tepat berturut-turut', value: s.lowerAfter, min: 1, max: 5, onChanged: (v) => update(s.copyWith(lowerAfter: v))),
          const SizedBox(height: 8),
          Panel(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SwitchListTile(
              value: s.guided,
              onChanged: (v) => update(s.copyWith(guided: v)),
              title: Text('Mode pendampingan', style: AppText.bodyStrong),
              subtitle: Text('Menampilkan tombol "Pendamping: sudah benar" saat pengenalan ucapan keliru.', style: AppText.caption),
            ),
          ),
        ],
      ),
    );
  }
}

class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(activeChildProvider);
    if (child == null) return const Scaffold(body: SizedBox.shrink());
    final p = Pal.of(context);
    final s = child.settings;
    void update(ChildSettings next) => ref.read(repositoryProvider).updateSettings(child.id, next);
    Widget toggle(String title, String detail, bool value, ValueChanged<bool> onChanged) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Panel(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SwitchListTile(
              value: value,
              onChanged: onChanged,
              title: Text(title, style: AppText.bodyStrong),
              subtitle: Text(detail, style: AppText.caption.copyWith(color: p.subInk)),
            ),
          ),
        );
    final tint = ReadingTint.values.where((t) => t.name == s.tint).firstOrNull ?? ReadingTint.none;
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(title: const Text('Tampilan dan aksesibilitas')),
      body: PaneList(
        maxWidth: 760,
        children: [
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tema', style: AppText.bodyStrong),
                const SizedBox(height: 4),
                Text('Tema gelap nyaman untuk membaca di malam hari.', style: AppText.caption.copyWith(color: p.subInk)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'light', label: Text('Terang', softWrap: false)),
                      ButtonSegment(value: 'dark', label: Text('Gelap', softWrap: false)),
                      ButtonSegment(value: 'system', label: Text('Sistem', softWrap: false)),
                    ],
                    selected: {s.theme},
                    showSelectedIcon: false,
                    onSelectionChanged: (v) => update(s.copyWith(theme: v.first)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bacaan cerita', style: AppText.bodyStrong),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: tint.of(brightness) ?? p.ground, borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
                  child: Text(
                    'Bi-ma pu-nya ku-cing.',
                    style: AppText.reading.copyWith(letterSpacing: AppText.reading.letterSpacing! + s.letterSpacing, wordSpacing: s.letterSpacing * 2),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Ukuran huruf', style: AppText.label),
                Slider(
                  value: s.fontScale,
                  min: 1,
                  max: 1.6,
                  divisions: 6,
                  label: '${(s.fontScale * 100).round()}%',
                  onChanged: (v) => update(s.copyWith(fontScale: v)),
                ),
                Text('Jarak huruf', style: AppText.label),
                Slider(
                  value: s.letterSpacing,
                  min: 0,
                  max: 4,
                  divisions: 4,
                  label: s.letterSpacing == 0 ? 'Normal' : '+${s.letterSpacing.round()}',
                  onChanged: (v) => update(s.copyWith(letterSpacing: v)),
                ),
                Text('Warna latar bacaan', style: AppText.label),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in ReadingTint.values)
                      ChoiceChip(
                        label: Text(t.label),
                        selected: t == tint,
                        showCheckmark: false,
                        avatar: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(color: t.of(brightness) ?? p.surface, borderRadius: BorderRadius.circular(4), border: Border.all(color: p.line)),
                        ),
                        selectedColor: Thread.kesumba,
                        labelStyle: AppText.label.copyWith(color: t == tint ? Thread.onThread : p.ink),
                        onSelected: (_) => update(s.copyWith(tint: t.name)),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kecepatan suara', style: AppText.bodyStrong),
                Slider(value: s.speechRate, min: 0.2, max: 0.6, divisions: 4, onChanged: (v) => update(s.copyWith(speechRate: v))),
                QuietAction(
                  label: 'Dengarkan contoh',
                  icon: Icons.volume_up_rounded,
                  onPressed: () => ref.read(speakerProvider).speak('buku', rate: s.speechRate),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          toggle('Penggaris baca', 'Menyalakan satu baris saat membaca cerita.', s.ruler, (v) => update(s.copyWith(ruler: v))),
          toggle('Warna huruf b dan d', 'Membantu membedakan dua huruf yang mirip.', s.letterColors, (v) => update(s.copyWith(letterColors: v))),
          toggle('Kurangi gerakan', 'Mematikan animasi yang tidak penting.', s.reduceMotion, (v) => update(s.copyWith(reduceMotion: v))),
        ],
      ),
    );
  }
}

class AccountSyncScreen extends ConsumerStatefulWidget {
  const AccountSyncScreen({super.key});

  @override
  ConsumerState<AccountSyncScreen> createState() => _AccountSyncScreenState();
}

class _AccountSyncScreenState extends ConsumerState<AccountSyncScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  final _className = TextEditingController();
  bool _teacher = false;
  bool _busy = false;
  String? _message;
  List<Map<String, dynamic>> _classes = const [];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _code.dispose();
    _className.dispose();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    final g = ref.read(supabaseGatewayProvider);
    if (g == null || !g.signedIn) return;
    try {
      final c = await g.myClasses();
      if (mounted) setState(() => _classes = c);
    } catch (_) {}
  }

  Future<void> _run(Future<void> Function() work, String success) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await work();
      _message = success;
    } on AuthException catch (e) {
      _message = e.message;
    } on PostgrestException catch (e) {
      _message = e.code == 'P0002' ? 'Kode kelas tidak ditemukan.' : e.message;
    } catch (_) {
      _message = 'Belum berhasil. Periksa internet, lalu coba lagi.';
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _signIn() => _run(() async {
        await Supabase.instance.client.auth.signInWithPassword(email: _email.text.trim(), password: _password.text);
        await ref.read(syncEngineProvider)?.syncNow(force: true);
        await _loadClasses();
      }, 'Berhasil masuk dan menyinkronkan data.');

  Future<void> _signUp() => _run(() async {
        await Supabase.instance.client.auth.signUp(
          email: _email.text.trim(),
          password: _password.text,
          data: {'role': _teacher ? 'teacher' : 'parent'},
        );
      }, 'Akun dibuat. Periksa email jika diminta konfirmasi, lalu masuk.');

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(_pendingProvider).value ?? 0;
    final gateway = ref.watch(supabaseGatewayProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Akun dan sinkron')),
      body: PaneList(
        maxWidth: 760,
        children: [
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$pending perubahan menunggu sinkron', style: AppText.bodyStrong),
                const SizedBox(height: 4),
                Text('Semua data tetap aman di perangkat ini.', style: AppText.bodyGuardian),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (gateway == null)
            const Panel(child: MessageState(title: 'Sinkron belum diatur', body: 'Versi aplikasi ini belum terhubung ke server. Lentera tetap berfungsi penuh di perangkat ini.'))
          else if (!gateway.signedIn)
            ..._signedOut()
          else
            ..._signedIn(),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Semantics(liveRegion: true, child: Text(_message!, style: AppText.bodyGuardian)),
          ],
        ],
      ),
    );
  }

  List<Widget> _signedOut() => [
        TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
        const SizedBox(height: 8),
        TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Kata sandi')),
        const SizedBox(height: 8),
        SwitchListTile(
          value: _teacher,
          onChanged: (v) => setState(() => _teacher = v),
          title: Text('Daftar sebagai guru', style: AppText.bodyGuardian),
        ),
        const SizedBox(height: 8),
        PrimaryAction(label: 'Masuk', onPressed: _busy ? null : _signIn),
        const SizedBox(height: 8),
        QuietAction(label: 'Buat akun', onPressed: _busy ? null : _signUp),
      ];

  List<Widget> _signedIn() {
    final child = ref.read(activeChildProvider);
    final gateway = ref.read(supabaseGatewayProvider)!;
    return [
      PrimaryAction(
        label: 'Sinkronkan sekarang',
        icon: Icons.sync_rounded,
        onPressed: _busy ? null : () => _run(() async => ref.read(syncEngineProvider)!.syncNow(force: true), 'Data sudah sinkron.'),
      ),
      const SizedBox(height: 16),
      if (child != null) ...[
        Text('Izinkan guru melihat data ${child.nickname}', style: AppText.bodyStrong),
        const SizedBox(height: 8),
        TextField(controller: _code, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(labelText: 'Kode kelas dari guru')),
        const SizedBox(height: 8),
        QuietAction(
          label: 'Gabung kelas',
          onPressed: _busy ? null : () => _run(() => gateway.joinClass(child.id, _code.text.trim()), 'Guru sekarang bisa melihat data anak ini.'),
        ),
        const SizedBox(height: 16),
      ],
      Text('Untuk guru: kelas saya', style: AppText.bodyStrong),
      const SizedBox(height: 8),
      for (final c in _classes)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(c['name'] as String, style: AppText.bodyGuardian),
          trailing: SelectableText('Kode ${c['join_code']}', style: AppText.bodyStrong),
        ),
      TextField(controller: _className, decoration: const InputDecoration(labelText: 'Nama kelas baru')),
      const SizedBox(height: 8),
      QuietAction(
        label: 'Buat kelas',
        onPressed: _busy
            ? null
            : () => _run(() async {
                  await gateway.createClass(_className.text.trim());
                  await _loadClasses();
                }, 'Kelas dibuat.'),
      ),
      const SizedBox(height: 16),
      QuietAction(
        label: 'Keluar dari akun',
        onPressed: () => _run(() => Supabase.instance.client.auth.signOut(), 'Sudah keluar.'),
      ),
    ];
  }
}

final _pendingProvider = StreamProvider<int>((ref) => ref.watch(repositoryProvider).watchPendingSync());

class DataScreen extends ConsumerWidget {
  const DataScreen({super.key});

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final child = ref.read(activeChildProvider);
    if (child == null) return;
    final now = DateTime.now();
    final summary = ChildSummary(
      await ref.read(repositoryProvider).attemptRecords(child.id),
      ref.read(sessionsProvider).value ?? const [],
      ref.read(contentProvider),
      now,
    );
    final bytes = await buildReport(child, summary, now);
    await Printing.sharePdf(bytes: bytes, filename: 'laporan-${child.nickname.toLowerCase()}.pdf');
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, ChildProfile child) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus data ${child.nickname}?'),
        content: const Text('Profil dan seluruh hasil latihan dihapus dari perangkat ini. Jika sudah tersinkron, data di server ikut ditandai terhapus. Tindakan ini tidak bisa dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(repositoryProvider).deleteChild(child.id);
    if (context.mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(activeChildProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Data, laporan, dan profil')),
      body: PaneList(
        maxWidth: 760,
        children: [
          QuietAction(label: 'Bagikan laporan PDF', icon: Icons.picture_as_pdf_outlined, onPressed: () => _export(context, ref)),
          const SizedBox(height: 8),
          QuietAction(label: 'Tambah profil anak', icon: Icons.person_add_alt_rounded, onPressed: () => context.push('/setup?add=1')),
          const SizedBox(height: 8),
          QuietAction(label: 'Keluarkan anak dari akun', icon: Icons.logout_rounded, onPressed: () async {
            await ref.read(repositoryProvider).signOutChild();
            if (context.mounted) context.go('/profiles');
          }),
          const SizedBox(height: 8),
          QuietAction(label: 'Uji pengenalan ucapan', icon: Icons.science_outlined, onPressed: () => context.push('/guardian/speech-test')),
          const SizedBox(height: 24),
          if (child != null)
            QuietAction(label: 'Hapus data ${child.nickname}', icon: Icons.delete_outline_rounded, onPressed: () => _delete(context, ref, child)),
        ],
      ),
    );
  }
}
