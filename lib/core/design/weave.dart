import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'tokens.dart';

bool motionReduced(BuildContext context) => MediaQuery.disableAnimationsOf(context);

/// Pinggir kain: pita garis lurik di tepi panel. Tidak pernah dipakai di balik teks.
class Selvedge extends StatelessWidget {
  const Selvedge({super.key, this.height = 10, this.lead = Thread.kunyit, this.radius = 0});

  final double height;
  final Color lead;
  final double radius;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
          child: CustomPaint(size: Size(double.infinity, height), painter: _SelvedgePainter(lead, Pal.of(context).ink)),
        ),
      );
}

class _SelvedgePainter extends CustomPainter {
  _SelvedgePainter(this.lead, this.ink);

  final Color lead;
  final Color ink;

  // Lebar garis dalam satuan, diulang seperti lungsin lurik.
  static const _pattern = [7, 2, 3, 2, 12, 2, 4, 2, 3, 6];

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [lead, ink, Thread.daun, ink, lead, Thread.tarumMuda, Thread.jingga, ink, lead, Thread.laut];
    final unit = size.height / 4;
    var x = 0.0;
    var i = 0;
    final paint = Paint();
    while (x < size.width) {
      final w = _pattern[i % _pattern.length] * unit;
      paint.color = colors[i % colors.length];
      canvas.drawRect(Rect.fromLTWH(x, 0, w + 0.5, size.height), paint);
      x += w;
      i++;
    }
  }

  @override
  bool shouldRepaint(_SelvedgePainter old) => old.lead != lead || old.ink != ink;
}

/// Pita sesi: satu slot per kata yang direncanakan. Slot terisi ditenun masuk dari kiri.
class ThreadSlots extends StatelessWidget {
  const ThreadSlots({super.key, required this.total, required this.filled, this.color = Thread.kunyit, this.active, this.height = 14, this.onDark = false});

  final int total;
  final int filled;
  final Color color;
  final int? active;
  final double height;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final emptyColor = onDark ? Thread.onThread.withValues(alpha: 0.18) : p.empty;
    return Semantics(
      label: '$filled dari $total benang',
      excludeSemantics: true,
      child: Row(
        children: [
          for (var i = 0; i < total; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: emptyColor,
                  borderRadius: BorderRadius.circular(3),
                  border: i == active ? Border.all(color: Thread.kesumba, width: 2.5) : null,
                ),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.centerLeft,
                child: i < filled ? _WovenIn(key: ValueKey('t$i'), color: color) : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WovenIn extends StatelessWidget {
  const _WovenIn({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final reduced = motionReduced(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduced ? 1 : 0, end: 1),
      duration: reduced ? Duration.zero : AppMotion.weave,
      curve: AppMotion.ease,
      builder: (_, t, _) => FractionallySizedBox(
        widthFactor: t,
        heightFactor: 1,
        child: CustomPaint(painter: _ThreadPainter(color)),
      ),
    );
  }
}

/// Satu benang dengan sedikit tekstur silang, supaya terbaca sebagai kain dan bukan batang grafik.
class _ThreadPainter extends CustomPainter {
  _ThreadPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = color);
    final shade = Paint()..color = Thread.onThread.withValues(alpha: 0.12);
    const step = 6.0;
    for (var x = 0.0; x < size.width; x += step * 2) {
      canvas.drawRect(Rect.fromLTWH(x, 0, step, size.height / 2), shade);
      canvas.drawRect(Rect.fromLTWH(x + step, size.height / 2, step, size.height / 2), shade);
    }
  }

  @override
  bool shouldRepaint(_ThreadPainter old) => old.color != color;
}

/// Satu benang statis untuk kain mingguan dan Koleksi.
class ThreadBar extends StatelessWidget {
  const ThreadBar({super.key, required this.color, this.height = 7});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height, child: CustomPaint(painter: _ThreadPainter(color), size: Size.infinite));
}

/// Kain minggu ini: tujuh kolom, satu benang per kata selesai. Skala tetap, supaya minggu-minggu jujur dibandingkan.
class WeekCloth extends StatelessWidget {
  const WeekCloth({super.key, required this.days, this.maxRows = 12});

  /// Indeks 0 adalah Senin. Isi: warna benang per kata selesai.
  final List<List<Color>> days;
  final int maxRows;
  static const names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final today = DateTime.now().weekday - 1;
    final active = days.where((d) => d.isNotEmpty).length;
    const thread = 7.0;
    const gap = 3.0;
    // Skala tetap: tinggi kolom sama setiap minggu.
    final columnHeight = maxRows * (thread + gap);
    return Semantics(
      label: 'Kain minggu ini: berlatih $active hari',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < 7; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 18,
                    child: days[i].length > maxRows
                        ? Text('+${days[i].length - maxRows}', style: AppText.caption.copyWith(color: p.subInk))
                        : null,
                  ),
                  Container(
                    width: double.infinity,
                    height: columnHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: p.surfaceAlt,
                      borderRadius: BorderRadius.circular(6),
                      border: i == today ? Border.all(color: p.ink, width: 2) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        for (final c in days[i].take(maxRows).toList().reversed) ...[
                          ThreadBar(color: c, height: thread),
                          const SizedBox(height: gap - 1),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    names[i],
                    style: AppText.caption.copyWith(
                      color: i == today ? p.ink : p.subInk,
                      fontWeight: i == today ? FontWeight.w700 : FontWeight.w500,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Motif tenun dan batik sederhana, digambar dengan kode. Dipakai untuk avatar dan stiker.
enum Motif { kawung, tumpal, ceplok, parang, lurik, ikat }

class MotifTile extends StatelessWidget {
  const MotifTile({super.key, required this.motif, required this.ground, this.size = 56, this.radius = 12, this.ink});

  final Motif motif;
  final Color ground;
  final double size;
  final double radius;
  final Color? ink;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CustomPaint(size: Size.square(size), painter: _MotifPainter(motif, ground, ink ?? Thread.onThread)),
        ),
      );
}

class _MotifPainter extends CustomPainter {
  _MotifPainter(this.motif, this.ground, this.ink);

  final Motif motif;
  final Color ground;
  final Color ink;

  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, Paint()..color = ground);
    final p = Paint()
      ..color = ink
      ..isAntiAlias = true;
    final u = s.width;
    switch (motif) {
      case Motif.kawung:
        // Empat daun lonjong di setiap sel, titik di tengah.
        for (final o in [Offset(u * .25, u * .25), Offset(u * .75, u * .75), Offset(u * .75, u * .25), Offset(u * .25, u * .75)]) {
          for (final a in [0.0, math.pi / 2]) {
            c.save();
            c.translate(o.dx, o.dy);
            c.rotate(a + math.pi / 4);
            c.drawOval(Rect.fromCenter(center: Offset.zero, width: u * .34, height: u * .14), p);
            c.restore();
          }
        }
        c.drawCircle(Offset(u / 2, u / 2), u * .06, p);
      case Motif.tumpal:
        // Deret segitiga tumpal, dua baris.
        for (var row = 0; row < 2; row++) {
          final top = row * u / 2;
          for (var i = 0; i < 3; i++) {
            final w = u / 3;
            c.drawPath(
              Path()
                ..moveTo(i * w, top + u / 2)
                ..lineTo(i * w + w / 2, top + u * .08)
                ..lineTo(i * w + w, top + u / 2)
                ..close(),
              p,
            );
          }
        }
      case Motif.ceplok:
        // Belah ketupat berulang.
        for (var y = 0; y < 3; y++) {
          for (var x = 0; x < 3; x++) {
            final cx = (x + .5) * u / 3;
            final cy = (y + .5) * u / 3;
            final r = u / 7.5;
            c.drawPath(
              Path()
                ..moveTo(cx, cy - r)
                ..lineTo(cx + r, cy)
                ..lineTo(cx, cy + r)
                ..lineTo(cx - r, cy)
                ..close(),
              p,
            );
          }
        }
      case Motif.parang:
        // Pita miring sejajar.
        c.save();
        c.clipRect(Offset.zero & s);
        for (var i = -3; i < 6; i++) {
          final x = i * u / 3.2;
          c.drawPath(
            Path()
              ..moveTo(x, u)
              ..lineTo(x + u * .14, u)
              ..lineTo(x + u * .14 + u, 0)
              ..lineTo(x + u, 0)
              ..close(),
            p,
          );
        }
        c.restore();
      case Motif.lurik:
        // Garis tegak dengan lebar berbeda.
        var x = u * .06;
        for (final w in [.06, .02, .14, .02, .06, .1, .02]) {
          c.drawRect(Rect.fromLTWH(x, 0, w * u, u), p);
          x += w * u + u * .07;
        }
      case Motif.ikat:
        // Belah ketupat bertangga di tengah, ciri ikat.
        final m = u / 2;
        for (final (r, hole) in [(.42, false), (.3, true), (.18, false)]) {
          final step = u * r;
          final path = Path()
            ..moveTo(m, m - step)
            ..lineTo(m + step * .5, m - step)
            ..lineTo(m + step * .5, m - step * .5)
            ..lineTo(m + step, m - step * .5)
            ..lineTo(m + step, m + step * .5)
            ..lineTo(m + step * .5, m + step * .5)
            ..lineTo(m + step * .5, m + step)
            ..lineTo(m - step * .5, m + step)
            ..lineTo(m - step * .5, m + step * .5)
            ..lineTo(m - step, m + step * .5)
            ..lineTo(m - step, m - step * .5)
            ..lineTo(m - step * .5, m - step * .5)
            ..lineTo(m - step * .5, m - step)
            ..close();
          c.drawPath(path, Paint()..color = hole ? ground : ink);
        }
    }
  }

  @override
  bool shouldRepaint(_MotifPainter old) => old.motif != motif || old.ground != ground || old.ink != ink;
}

/// Avatar: motif tenun di atas warna benang. Pilihannya enam, cukup untuk dibedakan anak dalam satu keluarga atau kelas.
class AvatarMotif extends StatelessWidget {
  const AvatarMotif({super.key, required this.avatarId, this.size = 48});

  final int avatarId;
  final double size;

  static const grounds = [Thread.kunyit, Thread.tarumMuda, Thread.daun, Thread.jingga, Thread.laut];

  @override
  Widget build(BuildContext context) => MotifTile(
        motif: Motif.values[avatarId % Motif.values.length],
        ground: grounds[avatarId % grounds.length],
        size: size,
        radius: size * 0.28,
      );
}

/// Logo Lentera: huruf L tarum di atas bidang kunyit, sama dengan ikon aplikasi.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Logo Lentera',
        excludeSemantics: true,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: Thread.kunyit, borderRadius: BorderRadius.circular(size * 0.22)),
          child: CustomPaint(painter: _LogoPainter()),
        ),
      );
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final u = s.width / 108;
    canvas.drawPath(
      Path()
        ..moveTo(38 * u, 28 * u)
        ..lineTo(51 * u, 28 * u)
        ..lineTo(51 * u, 67 * u)
        ..lineTo(70 * u, 67 * u)
        ..lineTo(70 * u, 80 * u)
        ..lineTo(38 * u, 80 * u)
        ..close(),
      Paint()..color = Thread.onThread,
    );
    // Dua benang di kaki huruf: pinggir kain kecil.
    canvas.drawRect(Rect.fromLTWH(38 * u, 86 * u, 32 * u, 4 * u), Paint()..color = Thread.tarum);
    canvas.drawRect(Rect.fromLTWH(38 * u, 92 * u, 14 * u, 4 * u), Paint()..color = Thread.jingga);
  }

  @override
  bool shouldRepaint(_LogoPainter oldDelegate) => false;
}
