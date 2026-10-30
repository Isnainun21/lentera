import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../adaptive.dart';
import '../data.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';

/// RA-PRD-201/202/301/401: Enhanced practice with letter discrimination,
/// color coding, actual timer, and richer feedback.
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({
    super.key,
    required this.pengguna,
    required this.akses,
    this.mulaiDariDiscriminasi = false,
    required this.onRefresh,
  });

  final Pengguna pengguna;
  final Aksesibilitas akses;
  final bool mulaiDariDiscriminasi;
  final VoidCallback onRefresh;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _mesin = MesinAdaptif();
  final _stt = stt.SpeechToText();
  bool _sttSiap = false;

  late int _level;
  late List<KataLatihan> _antrian;
  int _index = 0;
  int _benar = 0;
  int _salah = 0;
  String _teksTerdeteksi = '';
  HasilUcapan? _hasil;
  bool _merekam = false;
  bool _sesiSelesai = false;

  // Timer tracking
  late DateTime _mulaiSesi;
  int _durasiDetik = 0;

  // Tab mode
  int _tabIndex = 0; // 0 = Suku Kata, 1 = Discriminasi

  // Discriminasi state
  int _soalIndex = 0;
  List<int> _jawabanUser = [];
  bool? _discriminasiBenar;

  @override
  void initState() {
    super.initState();
    _level = widget.pengguna.levelSaatIni;
    _antrian = _ambilAntrian(_level);
    _mulaiSesi = DateTime.now();
    _tabIndex = widget.mulaiDariDiscriminasi ? 1 : 0;
    _stt.initialize().then((ok) {
      if (mounted) setState(() => _sttSiap = ok);
    });
  }

  List<KataLatihan> _ambilAntrian(int level) {
    final list = List<KataLatihan>.of(BankKata.untukLevel(level))..shuffle();
    return list.take(10).toList();
  }

  KataLatihan get _kata => _antrian[_index];

  Future<void> _rekam() async {
    if (!_sttSiap) {
      setState(() => _teksTerdeteksi = '(speech-to-text tidak tersedia)');
      return;
    }
    if (_merekam) {
      await _stt.stop();
      return;
    }
    setState(() {
      _merekam = true;
      _hasil = null;
      _teksTerdeteksi = '';
    });
    await _stt.listen(
      onResult: (r) => setState(() => _teksTerdeteksi = r.recognizedWords),
      listenOptions: stt.SpeechListenOptions(cancelOnError: true),
    );
    if (mounted) setState(() => _merekam = false);
  }

  void _evaluasi() {
    final teks = _teksTerdeteksi.trim();
    if (teks.isEmpty) return;
    final cocok = PencocokanUcapan.cocokkan(_kata, teks);
    final status = PencocokanUcapan.status(_kata, teks);
    final levelBaru = _mesin.evaluasi(_level, status);
    setState(() {
      _hasil = HasilUcapan(
        kataId: _kata.id,
        teksTerdeteksi: teks,
        status: status,
        sukuKataBenar: cocok.cocok,
      );
      if (status == StatusKecocokan.benar) {
        _benar++;
      } else {
        _salah++;
      }
      _level = levelBaru;
    });
  }

  void _lanjut() {
    if (_index + 1 >= _antrian.length) {
      _hitungDurasi();
      _simpanSesi();
      setState(() => _sesiSelesai = true);
      return;
    }
    setState(() {
      _index++;
      _hasil = null;
      _teksTerdeteksi = '';
    });
  }

  void _hitungDurasi() {
    _durasiDetik = DateTime.now().difference(_mulaiSesi).inSeconds;
  }

  Future<void> _simpanSesi() async {
    await Store.instance.simpanSesi(
      SesiLatihan(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        idPengguna: widget.pengguna.id,
        tanggal: DateTime.now(),
        level: _level,
        jumlahBenar: _benar,
        jumlahSalah: _salah,
        durasiDetik: _durasiDetik,
        jenisLatihan: _tabIndex == 0 ? 'suku_kata' : 'discriminasi',
      ),
    );
    await Store.instance.tambahWaktuLatihan(_durasiDetik);
    if (_level != widget.pengguna.levelSaatIni) {
      await Store.instance.simpanProfil(widget.pengguna.copyWith(levelSaatIni: _level));
    }
    await Store.instance.periksaLencanaBaru(widget.pengguna.id);
  }

  @override
  Widget build(BuildContext context) {
    final skala = widget.akses.ukuranHuruf;
    return Scaffold(
      appBar: AppBar(
        title: Text('Latihan', style: AppText.scale(AppText.headlineMd, skala)),
        actions: [
          if (widget.akses.warnaHurufAktif)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Pill(
                label: 'Fonik Aktif',
                background: AppColors.primaryTint,
                foreground: AppColors.primary,
                icon: Icons.graphic_eq,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _sesiSelesai
            ? _RingkasanSesi(
                skala: skala,
                benar: _benar,
                salah: _salah,
                level: _level,
                durasi: _durasiDetik,
                onKembali: () {
                  widget.onRefresh();
                  Navigator.of(context).pop();
                },
              )
            : Column(
                children: [
                  // Tab selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _TabButton(
                          label: 'Tahap Bacaan',
                          active: _tabIndex == 0,
                          onTap: () => setState(() => _tabIndex = 0),
                        ),
                        const SizedBox(width: 8),
                        _TabButton(
                          label: 'Beda Huruf',
                          active: _tabIndex == 1,
                          onTap: () => setState(() => _tabIndex = 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _tabIndex == 0
                        ? _buildLatihan(skala)
                        : _buildDiscriminasi(skala),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLatihan(double skala) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // Progress pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Pill(
                label: 'Langkah ${_index + 1} dari ${_antrian.length}',
                background: AppColors.primaryFixed,
                foreground: AppColors.onPrimaryContainer,
              ),
              Pill(
                label: 'Level $_level',
                background: AppColors.tertiaryFixed,
                foreground: AppColors.tertiary,
                icon: Icons.verified,
              ),
              if (_benar + _salah > 0)
                Pill(
                  label: '${((_benar / (_benar + _salah)) * 100).round()}% Lancar',
                  background: AppColors.primaryTint,
                  foreground: AppColors.primary,
                  icon: Icons.check_circle_outline,
                ),
            ],
          ),
          const SizedBox(height: 12),
          SteppedProgress(value: (_index + 1) / _antrian.length),

          // Penanda warna huruf
          if (widget.akses.warnaHurufAktif && _kata.jenisBunyi != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.palette_outlined, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Penanda Warna Huruf: ON', style: AppText.labelMd),
                  const Spacer(),
                  if (_kata.jenisBunyi!.contains('b')) ...[
                    const LetterColorDot(huruf: 'b'),
                    const SizedBox(width: 4),
                    Text('=Biru', style: AppText.labelSm.copyWith(color: AppColors.hurufB)),
                    const SizedBox(width: 8),
                  ],
                  if (_kata.jenisBunyi!.contains('d')) ...[
                    const LetterColorDot(huruf: 'd'),
                    const SizedBox(width: 4),
                    Text('=Merah', style: AppText.labelSm.copyWith(color: AppColors.hurufD)),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),

          // Main card
          SoftCard(
            child: Column(
              children: [
                Text('Dengarkan lalu satukan!', style: AppText.scale(AppText.headlineSm, skala)),
                const SizedBox(height: 4),
                Text(
                  'Sentuh setiap kotak untuk mendengarkan ketukan ritme suku kata.',
                  textAlign: TextAlign.center,
                  style: AppText.scale(AppText.bodyMd, skala),
                ),
                const SizedBox(height: 20),
                _MicButton(merekam: _merekam, onTap: _rekam),
                const SizedBox(height: 12),
                Text(
                  'Klik untuk mendengar "${_kata.sukuKata.join('-')}"',
                  style: AppText.labelMd.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 20),
                _SyllableRow(
                  kata: _kata,
                  hasil: _hasil,
                  skala: skala,
                  warnaAktif: widget.akses.warnaHurufAktif,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Combined word display
          SoftCard(
            color: AppColors.primaryTint,
            child: Column(
              children: [
                _buildKataGabungan(skala),
                const SizedBox(height: 4),
                Text(
                  '/${_kata.sukuKata.join(' \u00b7 ').toLowerCase()}/ \u00b7 kata benda',
                  style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Detection result
          if (_teksTerdeteksi.isNotEmpty)
            SoftCard(
              color: AppColors.surfaceLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Terdeteksi', style: AppText.labelMd),
                  const SizedBox(height: 4),
                  Text('"$_teksTerdeteksi"', style: AppText.scale(AppText.bodyReadingMd, skala)),
                  const SizedBox(height: 12),
                  if (_hasil == null)
                    ChunkyButton(label: 'Periksa', icon: Icons.check, onPressed: _evaluasi)
                  else
                    _UmpanBalik(
                      hasil: _hasil!,
                      skala: skala,
                      onLanjut: _lanjut,
                      onUlangi: () => setState(() {
                        _hasil = null;
                        _teksTerdeteksi = '';
                      }),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 16),
          // Bottom action buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Ulangi Suara',
                  icon: Icons.replay,
                  onPressed: () => setState(() {
                    _hasil = null;
                    _teksTerdeteksi = '';
                  }),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildKataGabungan(double skala) {
    if (!widget.akses.warnaHurufAktif || _kata.jenisBunyi == null) {
      return Text(
        _kata.sukuKata.join('\u00b7'),
        style: AppText.scale(AppText.headlineLgMobile, skala),
      );
    }

    // Color code specific letters
    return RichText(
      text: TextSpan(
        children: _kata.teks.split('').map((c) {
          Color? color;
          if (c.toLowerCase() == 'b') color = AppColors.hurufB;
          if (c.toLowerCase() == 'd') color = AppColors.hurufD;
          return TextSpan(
            text: c,
            style: AppText.scale(AppText.headlineLgMobile, skala).copyWith(
              color: color,
              fontWeight: color != null ? FontWeight.w800 : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  // ──── Discriminasi Huruf ────

  Widget _buildDiscriminasi(double skala) {
    final soalList = BankDiscriminasi.soalBD;
    if (_soalIndex >= soalList.length) {
      return _DiscriminasiSelesai(
        skala: skala,
        onKembali: () => setState(() {
          _soalIndex = 0;
          _jawabanUser.clear();
          _discriminasiBenar = null;
        }),
      );
    }
    final soal = soalList[_soalIndex];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        SteppedProgress(value: (_soalIndex + 1) / soalList.length),
        const SizedBox(height: 20),
        SoftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Beda Huruf: Cari Huruf "${soal.hurufTarget}"',
                    style: AppText.scale(AppText.headlineSm, skala),
                  ),
                  const Pill(
                    label: 'Diskriminasi Bentuk',
                    background: AppColors.softLavender,
                    foreground: AppColors.onSurface,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih semua huruf "${soal.hurufTarget}" bertangkai tegak di sisi ${soal.hurufTarget == 'b' ? 'kiri' : 'kanan'}.',
                style: AppText.scale(AppText.bodyMd, skala),
              ),
              const SizedBox(height: 20),
              // Letter options grid
              Row(
                children: List.generate(soal.pilihan.length, (i) {
                  final isSelected = _jawabanUser.contains(i);
                  final isJawaban = soal.jawaban.contains(i);
                  final Color bg;
                  final Color fg;

                  if (_discriminasiBenar != null) {
                    if (isJawaban) {
                      bg = AppColors.primaryTint;
                      fg = AppColors.primary;
                    } else if (isSelected && !isJawaban) {
                      bg = AppColors.errorContainer;
                      fg = AppColors.error;
                    } else {
                      bg = AppColors.surfaceLow;
                      fg = AppColors.onSurfaceVariant;
                    }
                  } else {
                    bg = isSelected ? AppColors.primaryContainer : AppColors.surfaceLow;
                    fg = isSelected ? AppColors.onPrimaryContainer : AppColors.onSurface;
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: _discriminasiBenar != null
                          ? null
                          : () {
                              setState(() {
                                if (_jawabanUser.contains(i)) {
                                  _jawabanUser.remove(i);
                                } else {
                                  _jawabanUser.add(i);
                                }
                              });
                            },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 80,
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(AppRadius.tile),
                          border: isSelected
                              ? Border.all(color: AppColors.primaryContainer, width: 2)
                              : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              soal.pilihan[i],
                              style: TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: fg,
                              ),
                            ),
                            // Color dot under letter
                            Positioned(
                              bottom: 8,
                              child: LetterColorDot(huruf: soal.pilihan[i]),
                            ),
                            if (isSelected && _discriminasiBenar == null)
                              const Positioned(
                                top: 6,
                                right: 6,
                                child: Icon(Icons.check_circle, size: 18, color: AppColors.primaryContainer),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_discriminasiBenar != null)
          SoftCard(
            color: _discriminasiBenar! ? AppColors.primaryTint : AppColors.errorContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _discriminasiBenar! ? Icons.emoji_events : Icons.info_outline,
                      color: _discriminasiBenar! ? AppColors.primary : AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _discriminasiBenar! ? 'Hebat! Kamu benar' : 'Coba lagi ya!',
                      style: AppText.headlineSm.copyWith(
                        color: _discriminasiBenar! ? AppColors.primary : AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(soal.penjelasan, style: AppText.bodyMd),
                const SizedBox(height: 12),
                ChunkyButton(
                  label: 'Lanjut',
                  icon: Icons.arrow_forward,
                  onPressed: () => setState(() {
                    _soalIndex++;
                    _jawabanUser.clear();
                    _discriminasiBenar = null;
                  }),
                ),
              ],
            ),
          )
        else if (_jawabanUser.isNotEmpty)
          ChunkyButton(
            label: 'Periksa Jawaban',
            icon: Icons.check,
            onPressed: () {
              final soal = BankDiscriminasi.soalBD[_soalIndex];
              final benar = _jawabanUser.length == soal.jawaban.length &&
                  _jawabanUser.every((j) => soal.jawaban.contains(j));
              setState(() => _discriminasiBenar = benar);
              if (benar) _benar++;
              else _salah++;
            },
          ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.onSurface : AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            label,
            style: AppText.labelLg.copyWith(
              color: active ? Colors.white : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      );
}

class _RingkasanSesi extends StatelessWidget {
  const _RingkasanSesi({
    required this.skala,
    required this.benar,
    required this.salah,
    required this.level,
    required this.durasi,
    required this.onKembali,
  });

  final double skala;
  final int benar;
  final int salah;
  final int level;
  final int durasi;
  final VoidCallback onKembali;

  @override
  Widget build(BuildContext context) {
    final total = benar + salah;
    final akurasi = total == 0 ? 0.0 : benar / total;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: AppColors.tertiaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, size: 48, color: AppColors.tertiary),
          ),
          const SizedBox(height: 20),
          Text('Sesi Selesai! 🎉', style: AppText.scale(AppText.headlineLgMobile, skala)),
          const SizedBox(height: 8),
          const Text('Progres sudah tersimpan untuk guru/orang tua.', style: AppText.bodyLg),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              Pill(
                label: '${(akurasi * 100).round()}% Lancar',
                background: AppColors.primaryTint,
                foreground: AppColors.primary,
                icon: Icons.check_circle,
              ),
              Pill(
                label: 'Level $level',
                background: AppColors.tertiaryFixed,
                foreground: AppColors.tertiary,
                icon: Icons.military_tech,
              ),
              Pill(
                label: '${(durasi / 60).ceil()} menit',
                background: AppColors.softLavender,
                foreground: AppColors.onSurface,
                icon: Icons.timer,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SoftCard(
            color: AppColors.surfaceLow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Benar', nilai: '$benar', warna: AppColors.primary),
                _StatItem(label: 'Salah', nilai: '$salah', warna: AppColors.error),
                _StatItem(label: 'Akurasi', nilai: '${(akurasi * 100).round()}%', warna: AppColors.tertiary),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ChunkyButton(
            label: 'Kembali ke Beranda',
            icon: Icons.home,
            onPressed: onKembali,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.nilai, required this.warna});

  final String label;
  final String nilai;
  final Color warna;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(nilai, style: AppText.headlineMd.copyWith(color: warna)),
          Text(label, style: AppText.labelMd),
        ],
      );
}

class _MicButton extends StatelessWidget {
  const _MicButton({required this.merekam, required this.onTap});

  final bool merekam;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: merekam ? AppColors.errorContainer : AppColors.tertiaryFixed,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: merekam ? AppColors.error : AppColors.shadowGold,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(merekam ? Icons.stop : Icons.mic, size: 44, color: AppColors.tertiary),
        ),
      );
}

class _SyllableRow extends StatelessWidget {
  const _SyllableRow({
    required this.kata,
    required this.hasil,
    required this.skala,
    this.warnaAktif = true,
  });

  final KataLatihan kata;
  final HasilUcapan? hasil;
  final double skala;
  final bool warnaAktif;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          for (var i = 0; i < kata.sukuKata.length; i++) ...[
            _SyllableTile(
              teks: kata.sukuKata[i],
              skala: skala,
              benar: hasil?.sukuKataBenar.contains(i),
              jenisBunyi: kata.jenisBunyi,
              warnaAktif: warnaAktif,
            ),
            if (i < kata.sukuKata.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text('+', style: TextStyle(fontSize: 20, color: AppColors.onSurfaceVariant)),
              ),
          ],
        ],
      );
}

class _SyllableTile extends StatelessWidget {
  const _SyllableTile({
    required this.teks,
    required this.skala,
    required this.benar,
    this.jenisBunyi,
    this.warnaAktif = true,
  });

  final String teks;
  final double skala;
  final bool? benar;
  final String? jenisBunyi;
  final bool warnaAktif;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (benar) {
      true => (AppColors.primaryContainer, AppColors.onPrimaryContainer),
      false => (AppColors.errorContainer, AppColors.error),
      null => (AppColors.tertiaryFixed, AppColors.tertiary),
    };
    return Container(
      constraints: const BoxConstraints(minWidth: 88, minHeight: 88),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        boxShadow: benar == null
            ? const [BoxShadow(color: AppColors.shadowGold, offset: Offset(0, 3))]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: _buildColoredText(fg),
          ),
          const SizedBox(height: 4),
          Text(
            '/${teks.toLowerCase()}/',
            style: AppText.labelSm.copyWith(color: fg.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildColoredText(Color defaultColor) {
    if (!warnaAktif || jenisBunyi == null) {
      return Text(teks, style: AppText.scale(AppText.syllableDisplay, skala).copyWith(color: defaultColor));
    }

    return RichText(
      text: TextSpan(
        children: teks.split('').map((c) {
          Color color = defaultColor;
          if (c.toLowerCase() == 'b') color = AppColors.hurufB;
          if (c.toLowerCase() == 'd') color = AppColors.hurufD;
          return TextSpan(
            text: c,
            style: AppText.scale(AppText.syllableDisplay, skala).copyWith(
              color: color,
              fontWeight: (c.toLowerCase() == 'b' || c.toLowerCase() == 'd') ? FontWeight.w800 : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _UmpanBalik extends StatelessWidget {
  const _UmpanBalik({
    required this.hasil,
    required this.skala,
    required this.onLanjut,
    required this.onUlangi,
  });

  final HasilUcapan hasil;
  final double skala;
  final VoidCallback onLanjut;
  final VoidCallback onUlangi;

  @override
  Widget build(BuildContext context) {
    final pesan = switch (hasil.status) {
      StatusKecocokan.benar => 'Bagus! Kamu berhasil membacanya. 🌟',
      StatusKecocokan.sebagian => 'Hampir! Coba lagi suku kata yang bertanda merah.',
      StatusKecocokan.salah => 'Belum cocok. Dengarkan dulu, lalu ulangi.',
    };
    final ikon = switch (hasil.status) {
      StatusKecocokan.benar => Icons.emoji_events,
      StatusKecocokan.sebagian => Icons.lightbulb_outline,
      StatusKecocokan.salah => Icons.refresh,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(ikon,
                color: hasil.status == StatusKecocokan.benar
                    ? AppColors.primary
                    : AppColors.tertiary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(pesan, style: AppText.scale(AppText.bodyReadingMd, skala)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (hasil.status == StatusKecocokan.benar)
          ChunkyButton(label: 'Lanjut Suku Kata →', icon: Icons.arrow_forward, onPressed: onLanjut)
        else
          SecondaryButton(
            label: 'Ulangi',
            icon: Icons.replay,
            onPressed: onUlangi,
          ),
      ],
    );
  }
}

class _DiscriminasiSelesai extends StatelessWidget {
  const _DiscriminasiSelesai({required this.skala, required this.onKembali});

  final double skala;
  final VoidCallback onKembali;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 64, color: AppColors.tertiaryContainer),
            const SizedBox(height: 16),
            Text('Semua Soal Selesai! 🎉', style: AppText.scale(AppText.headlineLgMobile, skala)),
            const SizedBox(height: 8),
            const Text(
              'Kamu sudah berlatih membedakan huruf b dan d. Terus berlatih ya!',
              textAlign: TextAlign.center,
              style: AppText.bodyLg,
            ),
            const SizedBox(height: 24),
            ChunkyButton(label: 'Ulangi Latihan', icon: Icons.replay, onPressed: onKembali),
          ],
        ),
      );
}