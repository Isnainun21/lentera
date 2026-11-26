import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/responsive.dart';
import '../../core/design/scenes.dart';
import '../../core/design/tokens.dart';

/// Pengaturan awal oleh pendamping: persetujuan, PIN, profil anak, lalu mikrofon.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key, this.addingChild = false, this.name = ''});

  final bool addingChild;
  final String name;

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

enum _Step { consent, pin, pinAgain, verifyPin, profile, mic }

class _SetupScreenState extends ConsumerState<SetupScreen> {
  late _Step _step = _Step.consent;
  bool _agreed = false;
  String _firstPin = '';
  late final _name = TextEditingController(text: widget.name);
  int _avatar = 0;
  int _level = 1;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<bool> _pinEntered(String pin) async {
    setState(() {
      _firstPin = pin;
      _error = null;
      _step = _Step.pinAgain;
    });
    return true;
  }

  Future<bool> _pinConfirmed(String pin) async {
    if (pin != _firstPin) {
      setState(() {
        _error = 'Kedua PIN belum sama. Buat lagi dari awal.';
        _step = _Step.pin;
      });
      return false;
    }
    await ref.read(repositoryProvider).setPin(pin);
    setState(() {
      _error = null;
      _step = _Step.profile;
    });
    return true;
  }

  Future<bool> _checkPin(String pin) async {
    if (await ref.read(repositoryProvider).checkPin(pin)) {
      setState(() {
        _error = null;
        _step = _Step.profile;
      });
      return true;
    }
    setState(() => _error = 'PIN belum tepat.');
    return false;
  }

  Future<void> _afterConsent() async {
    final hasPin = await ref.read(repositoryProvider).hasPin();
    setState(() => _step = hasPin ? _Step.verifyPin : _Step.pin);
  }

  Future<void> _saveProfile() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Tulis nama panggilan anak.');
      return;
    }
    if (await ref.read(repositoryProvider).nameTaken(name)) {
      setState(() => _error = 'Nama ini sudah dipakai. Tambahkan inisial, misalnya Bima R.');
      return;
    }
    setState(() => _busy = true);
    await ref.read(repositoryProvider).createChild(nickname: name, avatarId: _avatar, startLevel: _level);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = null;
    });
    if (widget.addingChild) {
      context.go('/home');
    } else {
      setState(() => _step = _Step.mic);
    }
  }

  Future<void> _askMic() async {
    setState(() => _busy = true);
    await ref.read(recognizerProvider).prepare();
    if (mounted) context.go('/home');
  }

  int get _stepIndex => switch (_step) {
        _Step.consent => 0,
        _Step.pin || _Step.pinAgain || _Step.verifyPin => 1,
        _Step.profile => 2,
        _Step.mic => 3,
      };

  @override
  Widget build(BuildContext context) {
    final wide = WindowSize.of(context) == WindowSize.expanded;
    final g = gutterFor(context);
    final action = switch (_step) {
      _Step.consent => PrimaryAction(label: 'Setuju dan lanjut', onPressed: _agreed ? _afterConsent : null),
      _Step.profile => PrimaryAction(label: 'Buat profil', onPressed: _busy ? null : _saveProfile),
      _Step.mic => PrimaryAction(label: 'Izinkan mikrofon', icon: Icons.mic_rounded, onPressed: _busy ? null : _askMic),
      _ => null,
    };
    final content = Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(g, g, g, 12),
            children: [
              if (!wide) ...[ThreadSlots(total: 4, filled: _stepIndex + 1, active: _stepIndex, height: 8), const SizedBox(height: 24)],
              ...switch (_step) {
                _Step.consent => _consent(),
                _Step.pin => _pinStep('Buat PIN pendamping', 'PIN menjaga Area Pendamping dari ketukan anak. Pilih 4 angka.', _pinEntered),
                _Step.pinAgain => _pinStep('Ulangi PIN', 'Masukkan 4 angka yang sama sekali lagi.', _pinConfirmed),
                _Step.verifyPin => _pinStep('PIN pendamping', 'Profil baru dibuat bersama pendamping.', _checkPin),
                _Step.profile => _profile(),
                _Step.mic => _mic(),
              },
            ],
          ),
        ),
        if (action != null) Padding(padding: EdgeInsets.fromLTRB(g, 8, g, g), child: action),
      ],
    );
    return Scaffold(
      body: SafeArea(
        child: wide
            ? Row(
                children: [
                  Expanded(flex: 4, child: Padding(padding: EdgeInsets.all(g), child: _BrandPanel(step: _stepIndex))),
                  Expanded(flex: 5, child: Pane(maxWidth: 620, child: content)),
                ],
              )
            : Pane(maxWidth: 620, child: content),
      ),
    );
  }

  List<Widget> _consent() => [
        Text('Untuk orang tua atau wali', style: AppText.title),
        const SizedBox(height: 8),
        Text('Mohon baca sebelum anak mulai memakai Lentera.', style: AppText.body),
        const SizedBox(height: 20),
        Panel(
          selvedge: Thread.kunyit,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (title, body) in const [
                ('Yang disimpan', 'Nama panggilan, avatar, level, dan hasil latihan per kata. Data ada di perangkat ini.'),
                (
                  'Tentang suara anak',
                  'Lentera tidak merekam atau menyimpan suara. Pengenalan ucapan memakai layanan bawaan perangkat, yang bisa saja mengirim suara ke penyedianya, seperti Google atau Apple.'
                ),
                ('Sinkronisasi', 'Data dikirim ke server hanya jika Anda masuk ke akun pendamping. Guru hanya bisa melihat data bila Anda memberi kode kelas.'),
                ('Hak Anda', 'Anda bisa menghapus data anak kapan saja di Area Pendamping.'),
              ]) ...[
                Text(title, style: AppText.bodyStrong),
                const SizedBox(height: 4),
                Text(body, style: AppText.bodyGuardian),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: _agreed,
          onChanged: (v) => setState(() => _agreed = v ?? false),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text('Saya orang tua atau wali anak ini dan menyetujui hal di atas.', style: AppText.bodyGuardian),
        ),
      ];

  List<Widget> _pinStep(String title, String body, Future<bool> Function(String) onComplete) => [
        Text(title, style: AppText.title),
        const SizedBox(height: 8),
        Text(body, style: AppText.body),
        const SizedBox(height: 28),
        Center(child: PinPad(key: ValueKey(_step), onComplete: onComplete, error: _error)),
      ];

  List<Widget> _profile() {
    final p = Pal.of(context);
    return [
      Text('Profil anak', style: AppText.title),
      const SizedBox(height: 20),
      TextField(
        controller: _name,
        textCapitalization: TextCapitalization.words,
        maxLength: 20,
        style: AppText.heading,
        decoration: const InputDecoration(labelText: 'Nama panggilan', counterText: ''),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 24),
      Text('Pilih motif', style: AppText.bodyStrong),
      const SizedBox(height: 4),
      Text('Motif membantu anak mengenali profilnya sendiri.', style: AppText.caption.copyWith(color: p.subInk)),
      const SizedBox(height: 12),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (var i = 0; i < Motif.values.length; i++)
            Semantics(
              button: true,
              selected: i == _avatar,
              label: 'Motif ${Motif.values[i].name}',
              excludeSemantics: true,
              child: GestureDetector(
                onTap: () => setState(() => _avatar = i),
                child: AnimatedContainer(
                  duration: AppMotion.quick,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: i == _avatar ? p.ink : Colors.transparent, width: 3),
                  ),
                  child: AvatarMotif(avatarId: i, size: 60),
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 24),
      Text('Mulai dari mana?', style: AppText.bodyStrong),
      const SizedBox(height: 4),
      Text('Level akan menyesuaikan sendiri saat latihan.', style: AppText.caption.copyWith(color: p.subInk)),
      const SizedBox(height: 12),
      for (final (level, title) in const [
        (1, 'Suku kata, seperti BA dan MA'),
        (2, 'Kata pendek, seperti BUKU'),
        (3, 'Kata dengan akhiran konsonan, seperti LAMPU'),
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Semantics(
            selected: _level == level,
            child: Material(
              color: _level == level ? Thread.kesumba : p.surface,
              borderRadius: BorderRadius.circular(AppSpace.tileRadius),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpace.tileRadius),
                onTap: () => setState(() => _level = level),
                child: Container(
                  constraints: const BoxConstraints(minHeight: AppSpace.tapChild),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpace.tileRadius),
                    border: Border.all(color: _level == level ? Colors.transparent : p.line),
                  ),
                  child: Row(
                    children: [
                      Icon(_level == level ? Icons.check_circle_rounded : Icons.circle_outlined, color: _level == level ? Thread.onThread : p.ink),
                      const SizedBox(width: 10),
                      Expanded(child: Text(title, style: AppText.bodyGuardian.copyWith(color: _level == level ? Thread.onThread : p.ink))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      if (_error != null)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(_error!, style: AppText.bodyGuardian.copyWith(color: p.retry)),
        ),
    ];
  }

  List<Widget> _mic() => [
        Text('Satu langkah lagi', style: AppText.title),
        const SizedBox(height: 8),
        Text(
          'Lentera perlu mikrofon untuk mendengar anak membaca. Jika ditolak, latihan tetap bisa dipakai dengan cara dengar lalu pilih.',
          style: AppText.body,
        ),
        const SizedBox(height: 24),
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: Thread.kunyit, borderRadius: BorderRadius.circular(32)),
            child: const Icon(Icons.mic_rounded, size: 56, color: Thread.onThread),
          ),
        ),
      ];
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(AppSpace.panelRadius),
        child: ColoredBox(
          color: Thread.tarum,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Selvedge(height: 12),
              const Expanded(child: SceneArt(scene: Scene.hills)),
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LogoMark(size: 64),
                    const SizedBox(height: 16),
                    Text('Lentera', style: AppText.display.copyWith(color: Colors.white)),
                    const SizedBox(height: 6),
                    Text('Satu kata, satu benang.', style: AppText.body.copyWith(color: const Color(0xFFDDE3F5))),
                    const SizedBox(height: 24),
                    ThreadSlots(total: 4, filled: step + 1, active: step, height: 10, onDark: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

/// Anak masuk dengan namanya. Nama yang sudah ada juga bisa disentuh, karena mengetik sulit bagi sebagian anak.
class ProfilePickerScreen extends ConsumerStatefulWidget {
  const ProfilePickerScreen({super.key});

  @override
  ConsumerState<ProfilePickerScreen> createState() => _ProfilePickerScreenState();
}

class _ProfilePickerScreenState extends ConsumerState<ProfilePickerScreen> {
  final _name = TextEditingController();
  bool _unknown = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _signIn(String name) async {
    if (name.trim().isEmpty) return;
    final id = await ref.read(repositoryProvider).signInByName(name);
    if (!mounted) return;
    if (id != null) {
      context.go('/home');
    } else {
      setState(() => _unknown = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(childrenProvider).value ?? const [];
    final p = Pal.of(context);
    final wide = WindowSize.of(context) == WindowSize.expanded;
    final form = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Siapa namamu?', style: AppText.title),
        const SizedBox(height: 16),
        if (children.isNotEmpty) ...[
          Text('Sentuh namamu', style: AppText.bodyStrong),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final c in children)
                Semantics(
                  button: true,
                  label: c.nickname,
                  excludeSemantics: true,
                  child: Material(
                    color: p.surface,
                    borderRadius: BorderRadius.circular(AppSpace.panelRadius),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSpace.panelRadius),
                      onTap: () => _signIn(c.nickname),
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSpace.panelRadius), border: Border.all(color: p.line)),
                        child: Column(
                          children: [
                            AvatarMotif(avatarId: c.avatarId, size: 72),
                            const SizedBox(height: 10),
                            Text(c.nickname, style: AppText.heading, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Atau tulis namamu', style: AppText.bodyStrong),
          const SizedBox(height: 10),
        ],
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          style: AppText.heading,
          decoration: const InputDecoration(labelText: 'Nama panggilan'),
          onChanged: (_) => setState(() => _unknown = false),
          onSubmitted: _signIn,
        ),
        const SizedBox(height: 12),
        PrimaryAction(label: 'Masuk', onPressed: _name.text.trim().isEmpty ? null : () => _signIn(_name.text)),
        if (_unknown) ...[
          const SizedBox(height: 14),
          Semantics(liveRegion: true, child: Text('Nama ini belum terdaftar. Minta pendamping membuatkan profil.', style: AppText.bodyStrong)),
          const SizedBox(height: 8),
          QuietAction(
            label: 'Buat profil baru',
            icon: Icons.person_add_alt_rounded,
            onPressed: () => context.push('/setup?add=1&name=${Uri.encodeQueryComponent(_name.text.trim())}'),
          ),
        ],
      ],
    );
    final g = gutterFor(context);
    if (wide) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              const Expanded(flex: 4, child: Padding(padding: EdgeInsets.all(28), child: _BrandPanel(step: 3))),
              Expanded(flex: 5, child: Pane(maxWidth: 620, child: ListView(padding: EdgeInsets.all(g), children: [form]))),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: (MediaQuery.sizeOf(context).height * 0.26).clamp(150.0, 240.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Expanded(child: SceneArt(scene: Scene.hills)), Selvedge(height: 12)],
            ),
          ),
          Pane(maxWidth: 620, child: Padding(padding: EdgeInsets.all(g), child: form)),
        ],
      ),
    );
  }
}
