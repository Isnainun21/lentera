import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
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

enum _Step { consent, pin, verifyPin, profile, mic }

class _SetupScreenState extends ConsumerState<SetupScreen> {
  late _Step _step = _Step.consent;
  bool _agreed = false;
  final _pin = TextEditingController();
  final _pinAgain = TextEditingController();
  late final _name = TextEditingController(text: widget.name);
  int _avatar = 0;
  int _level = 1;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _pin.dispose();
    _pinAgain.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _savePin() async {
    final pin = _pin.text.trim();
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      setState(() => _error = 'PIN harus 4 angka.');
      return;
    }
    if (pin != _pinAgain.text.trim()) {
      setState(() => _error = 'Kedua PIN belum sama.');
      return;
    }
    await ref.read(repositoryProvider).setPin(pin);
    setState(() {
      _error = null;
      _step = _Step.profile;
    });
  }

  Future<void> _checkPin() async {
    if (await ref.read(repositoryProvider).checkPin(_pin.text.trim())) {
      setState(() {
        _error = null;
        _step = _Step.profile;
      });
    } else {
      setState(() => _error = 'PIN belum tepat.');
    }
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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpace.gutter),
                  children: switch (_step) {
                    _Step.consent => _consent(),
                    _Step.pin => _pinStep(),
                    _Step.verifyPin => _verifyStep(),
                    _Step.profile => _profile(),
                    _Step.mic => _mic(),
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.gutter, 8, AppSpace.gutter, AppSpace.gutter),
                child: switch (_step) {
                  _Step.consent => PrimaryAction(label: 'Setuju dan lanjut', onPressed: _agreed ? _afterConsent : null),
                  _Step.pin => PrimaryAction(label: 'Simpan PIN', onPressed: _savePin),
                  _Step.verifyPin => PrimaryAction(label: 'Lanjut', onPressed: _checkPin),
                  _Step.profile => PrimaryAction(label: 'Buat profil', onPressed: _busy ? null : _saveProfile),
                  _Step.mic => PrimaryAction(label: 'Izinkan mikrofon', icon: Icons.mic_rounded, onPressed: _busy ? null : _askMic),
                },
              ),
            ],
          ),
        ),
      );

  List<Widget> _consent() => [
        Text('Untuk orang tua atau wali', style: AppText.title),
        const SizedBox(height: 8),
        Text('Mohon baca sebelum anak mulai memakai Lentera.', style: AppText.body),
        const SizedBox(height: 20),
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Yang disimpan', style: AppText.bodyStrong),
              const SizedBox(height: 4),
              Text('Nama panggilan, avatar, level, dan hasil latihan per kata. Data ada di perangkat ini.', style: AppText.bodyGuardian),
              const SizedBox(height: 16),
              Text('Tentang suara anak', style: AppText.bodyStrong),
              const SizedBox(height: 4),
              Text(
                'Lentera tidak merekam atau menyimpan suara. Pengenalan ucapan memakai layanan bawaan perangkat, yang bisa saja mengirim suara ke penyedianya, seperti Google atau Apple.',
                style: AppText.bodyGuardian,
              ),
              const SizedBox(height: 16),
              Text('Sinkronisasi', style: AppText.bodyStrong),
              const SizedBox(height: 4),
              Text('Data dikirim ke server hanya jika Anda masuk ke akun pendamping. Guru hanya bisa melihat data bila Anda memberi kode kelas.', style: AppText.bodyGuardian),
              const SizedBox(height: 16),
              Text('Hak Anda', style: AppText.bodyStrong),
              const SizedBox(height: 4),
              Text('Anda bisa menghapus data anak kapan saja di Area Pendamping.', style: AppText.bodyGuardian),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: _agreed,
          onChanged: (v) => setState(() => _agreed = v ?? false),
          activeColor: AppColors.ink,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text('Saya orang tua atau wali anak ini dan menyetujui hal di atas.', style: AppText.bodyGuardian),
        ),
      ];

  List<Widget> _pinStep() => [
        Text('Buat PIN pendamping', style: AppText.title),
        const SizedBox(height: 8),
        Text('PIN menjaga Area Pendamping dari ketukan anak.', style: AppText.body),
        const SizedBox(height: 20),
        _pinField(_pin, 'PIN 4 angka'),
        const SizedBox(height: 12),
        _pinField(_pinAgain, 'Ulangi PIN'),
        if (_error != null) _errorText(),
      ];

  List<Widget> _verifyStep() => [
        Text('PIN pendamping', style: AppText.title),
        const SizedBox(height: 8),
        Text('Profil baru dibuat bersama pendamping.', style: AppText.body),
        const SizedBox(height: 20),
        _pinField(_pin, 'PIN 4 angka'),
        if (_error != null) _errorText(),
      ];

  Widget _pinField(TextEditingController c, String label) => TextField(
        controller: c,
        keyboardType: TextInputType.number,
        obscureText: true,
        maxLength: 4,
        style: AppText.heading,
        decoration: InputDecoration(labelText: label, counterText: ''),
      );

  Widget _errorText() => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(_error!, style: AppText.bodyGuardian.copyWith(color: AppColors.retry)),
      );

  List<Widget> _profile() => [
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
        Text('Warna avatar', style: AppText.bodyStrong),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var i = 0; i < AppColors.avatars.length; i++)
              Semantics(
                button: true,
                selected: i == _avatar,
                label: 'Avatar ${i + 1}',
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: () => setState(() => _avatar = i),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: i == _avatar ? AppColors.ink : Colors.transparent, width: 3),
                    ),
                    child: AvatarCircle(avatarId: i, name: _name.text, size: 56),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Mulai dari mana?', style: AppText.bodyStrong),
        const SizedBox(height: 4),
        Text('Level akan menyesuaikan sendiri saat latihan.', style: AppText.bodyGuardian),
        const SizedBox(height: 12),
        for (final (level, title) in const [
          (1, 'Suku kata, seperti BA dan MA'),
          (2, 'Kata pendek, seperti BUKU'),
          (3, 'Kata dengan akhiran konsonan, seperti LAMPU'),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: _level == level ? AppColors.lantern : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpace.tileRadius),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpace.tileRadius),
                onTap: () => setState(() => _level = level),
                child: Container(
                  constraints: const BoxConstraints(minHeight: AppSpace.tapChild),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(_level == level ? Icons.check_circle_rounded : Icons.circle_outlined),
                      const SizedBox(width: 10),
                      Expanded(child: Text(title, style: AppText.bodyGuardian)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (_error != null) _errorText(),
      ];

  List<Widget> _mic() => [
        Text('Satu langkah lagi', style: AppText.title),
        const SizedBox(height: 8),
        Text(
          'Lentera perlu mikrofon untuk mendengar anak membaca. Jika ditolak, latihan tetap bisa dipakai dengan cara dengar lalu pilih.',
          style: AppText.body,
        ),
      ];
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
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 240, child: SceneArt(scene: Scene.hills)),
          Padding(
            padding: const EdgeInsets.all(AppSpace.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Siapa namamu?', style: AppText.title),
                const SizedBox(height: 14),
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
                if (children.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('Atau sentuh namamu', style: AppText.bodyStrong),
                  const SizedBox(height: 10),
                  for (final c in children)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpace.tileRadius),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppSpace.tileRadius),
                          onTap: () => _signIn(c.nickname),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                AvatarCircle(avatarId: c.avatarId, name: c.nickname, size: 52),
                                const SizedBox(width: 14),
                                Expanded(child: Text(c.nickname, style: AppText.heading)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
