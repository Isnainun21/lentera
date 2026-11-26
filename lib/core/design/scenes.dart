import 'package:flutter/material.dart';

import 'tokens.dart';

/// Warna ilustrasi, diambil dari benang Tenun Kata.
class _C {
  static const surface = Color(0xFFFFFFFF);
  static const lantern = Thread.kunyit;
  static const lanternSoft = Color(0xFFFFE3A0);
  static const ink = Thread.onThread;
  static const leaf = Thread.daun;
  static const sky = Thread.tarumMuda;
  static const deep = Thread.tarum;
}

enum Scene { hills, forest, cat, zoo, kite, market, rain }

Scene sceneForStory(String id) => switch (id) {
      'c1' => Scene.forest,
      'c2' => Scene.cat,
      'c3' => Scene.zoo,
      'c4' => Scene.kite,
      'c5' => Scene.market,
      'c6' => Scene.rain,
      _ => Scene.hills,
    };

/// Ilustrasi datar yang digambar dengan kode. Tidak ada aset gambar yang perlu dimuat.
class SceneArt extends StatelessWidget {
  const SceneArt({super.key, required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: CustomPaint(painter: _ScenePainter(scene), size: Size.infinite),
      );
}

class _ScenePainter extends CustomPainter {
  const _ScenePainter(this.scene);

  final Scene scene;

  @override
  void paint(Canvas c, Size real) {
    // Digambar di kanvas persegi lalu dipotong seperti gambar cover, agar bentuk tidak ikut melar.
    c.clipRect(Offset.zero & real);
    final side = real.width > real.height ? real.width : real.height;
    c.translate((real.width - side) / 2, real.height - side);
    final s = Size(side, side);
    switch (scene) {
      case Scene.hills:
        _hills(c, s);
      case Scene.forest:
        _forestKancil(c, s);
      case Scene.kite:
        _kite(c, s);
      case Scene.market:
        _market(c, s);
      case Scene.rain:
        _rain(c, s);
      case Scene.cat:
        _catScene(c, s);
      case Scene.zoo:
        _zoo(c, s);
    }
  }

  Paint _p(Color color) => Paint()
    ..color = color
    ..isAntiAlias = true;

  void _fill(Canvas c, Size s, Color color) => c.drawRect(Offset.zero & s, _p(color));

  /// Bukit: titik (x, y) dalam pecahan ukuran, ditutup ke dasar gambar.
  void _hill(Canvas c, Size s, Color color, List<Offset> pts) {
    final path = Path()..moveTo(0, s.height);
    path.lineTo(0, pts.first.dy * s.height);
    for (var i = 0; i < pts.length - 1; i++) {
      final a = Offset(pts[i].dx * s.width, pts[i].dy * s.height);
      final b = Offset(pts[i + 1].dx * s.width, pts[i + 1].dy * s.height);
      final mid = (a + b) / 2;
      path.cubicTo(mid.dx, a.dy, mid.dx, b.dy, b.dx, b.dy);
    }
    path
      ..lineTo(s.width, s.height)
      ..close();
    c.drawPath(path, _p(color));
  }

  void _sun(Canvas c, Size s, double x, double y, double r, Color color) =>
      c.drawCircle(Offset(x * s.width, y * s.height), r * s.shortestSide, _p(color));

  void _pine(Canvas c, Size s, double x, double base, double h, Color color) {
    final w = h * s.height * 0.42;
    final bx = x * s.width;
    final by = base * s.height;
    final th = h * s.height;
    c.drawRect(Rect.fromLTWH(bx - w * .08, by - th * .15, w * .16, th * .15), _p(const Color(0xFF5A3B22)));
    for (var i = 0; i < 3; i++) {
      final top = by - th + th * .24 * i;
      final bottom = by - th * .12 - th * .24 * (2 - i);
      final half = w * (.32 + .18 * i);
      c.drawPath(
        Path()
          ..moveTo(bx, top)
          ..lineTo(bx + half, bottom)
          ..lineTo(bx - half, bottom)
          ..close(),
        _p(color),
      );
    }
  }

  void _hills(Canvas c, Size s) {
    _fill(c, s, const Color(0xFF49A9EE));
    _sun(c, s, .74, .3, .15, _C.lantern);
    _hill(c, s, const Color(0xFF1E7FA8), const [Offset(0, .55), Offset(.3, .4), Offset(.65, .6), Offset(1, .42)]);
    _hill(c, s, _C.leaf, const [Offset(0, .68), Offset(.4, .56), Offset(.75, .74), Offset(1, .62)]);
    _pine(c, s, .18, .72, .36, _C.deep);
    _pine(c, s, .3, .7, .28, const Color(0xFF12705A));
    _hill(c, s, const Color(0xFF0F6B45), const [Offset(0, .86), Offset(.5, .78), Offset(1, .9)]);
  }

  void _catScene(Canvas c, Size s) {
    _fill(c, s, const Color(0xFFFF9F68));
    c.drawRect(Rect.fromLTWH(s.width * .62, s.height * .12, s.width * .27, s.height * .36), _p(const Color(0xFFBDE4FA)));
    c.drawRect(Rect.fromLTWH(s.width * .745, s.height * .12, s.width * .02, s.height * .36), _p(_C.surface));
    c.drawRect(Rect.fromLTWH(s.width * .62, s.height * .29, s.width * .27, s.height * .02), _p(_C.surface));
    c.drawRect(Rect.fromLTWH(0, s.height * .72, s.width, s.height * .28), _p(const Color(0xFFB65A2B)));
    final u = s.shortestSide * .17;
    final o = Offset(s.width * .38, s.height * .62);
    Offset at(double x, double y) => o + Offset(x * u, y * u);
    final white = _p(_C.surface);
    c.drawPath(
      Path()
        ..moveTo(at(.75, .6).dx, at(.75, .6).dy)
        ..quadraticBezierTo(at(1.9, .7).dx, at(1.9, .7).dy, at(1.55, -.6).dx, at(1.55, -.6).dy),
      Paint()
        ..color = _C.surface
        ..style = PaintingStyle.stroke
        ..strokeWidth = .24 * u
        ..strokeCap = StrokeCap.round,
    );
    c.drawOval(Rect.fromCenter(center: at(0, .25), width: 1.7 * u, height: 1.5 * u), white);
    c.drawCircle(at(0, -.72), .72 * u, white);
    for (final dir in [-1.0, 1.0]) {
      c.drawPath(
        Path()
          ..moveTo(at(dir * .62, -1.0).dx, at(dir * .62, -1.0).dy)
          ..lineTo(at(dir * .58, -1.68).dx, at(dir * .58, -1.68).dy)
          ..lineTo(at(dir * .12, -1.3).dx, at(dir * .12, -1.3).dy)
          ..close(),
        white,
      );
      c.drawCircle(at(dir * .27, -.8), .085 * u, _p(_C.ink));
    }
    c.drawCircle(at(0, -.6), .07 * u, _p(const Color(0xFFFF7A70)));
    c.drawCircle(at(-1.5, .75), .42 * u, _p(_C.sky));
    c.drawPath(
      Path()
        ..moveTo(at(-1.92, .75).dx, at(-1.92, .75).dy)
        ..quadraticBezierTo(at(-1.5, .45).dx, at(-1.5, .45).dy, at(-1.08, .75).dx, at(-1.08, .75).dy),
      Paint()
        ..color = _C.surface
        ..style = PaintingStyle.stroke
        ..strokeWidth = .06 * u,
    );
  }

  void _zoo(Canvas c, Size s) {
    _fill(c, s, const Color(0xFF7FD6C2));
    _sun(c, s, .82, .2, .11, _C.lantern);
    _hill(c, s, _C.leaf, const [Offset(0, .7), Offset(.5, .62), Offset(1, .72)]);
    final u = s.shortestSide * .15;
    final o = Offset(s.width * .46, s.height * .68);
    Offset at(double x, double y) => o + Offset(x * u, y * u);
    final body = _p(_C.lantern);
    final spot = _p(const Color(0xFFB9731E));
    for (final dx in [-.55, -.25, .25, .55]) {
      c.drawRect(Rect.fromCenter(center: at(dx, .7), width: .2 * u, height: 1.3 * u), body);
    }
    c.drawOval(Rect.fromCenter(center: at(0, 0), width: 1.7 * u, height: 1 * u), body);
    c.drawPath(
      Path()
        ..moveTo(at(.3, -.1).dx, at(.3, -.1).dy)
        ..lineTo(at(.75, -2.2).dx, at(.75, -2.2).dy)
        ..lineTo(at(1.1, -2.2).dx, at(1.1, -2.2).dy)
        ..lineTo(at(.85, .1).dx, at(.85, .1).dy)
        ..close(),
      body,
    );
    c.drawOval(Rect.fromCenter(center: at(1.12, -2.35), width: .85 * u, height: .48 * u), body);
    c.drawCircle(at(1.2, -2.42), .055 * u, _p(_C.ink));
    for (final dx in [.82, 1.02]) {
      c.drawRect(Rect.fromCenter(center: at(dx, -2.75), width: .07 * u, height: .36 * u), spot);
    }
    for (final (x, y, r) in const [(-.45, -.1, .17), (.05, .15, .15), (.3, -.25, .13), (.72, -1.1, .12), (.85, -1.7, .1), (.6, -.55, .12)]) {
      c.drawCircle(at(x, y), r * u, spot);
    }
    _hill(c, s, const Color(0xFF0F6B45), const [Offset(0, .94), Offset(.55, .88), Offset(1, .95)]);
    _pine(c, s, .12, .86, .4, const Color(0xFF12705A));
  }


  /// Kancil: kecil, kaki pendek, leher pendek, moncong runcing. Bukan rusa.
  void _kancil(Canvas c, Size s, double x, double y, double u) {
    final body = _p(const Color(0xFFB8642E));
    final dark = _p(const Color(0xFF7A3E17));
    final belly = _p(const Color(0xFFF2D2A8));
    final o = Offset(x * s.width, y * s.height);
    Offset at(double dx, double dy) => o + Offset(dx * u, dy * u);
    for (final dx in [-.5, -.3, .3, .5]) {
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: at(dx, .48), width: .1 * u, height: .55 * u), Radius.circular(.05 * u)), dx < 0 ? dark : body);
    }
    c.drawOval(Rect.fromCenter(center: at(0, 0), width: 1.4 * u, height: .7 * u), body);
    c.drawOval(Rect.fromCenter(center: at(0, .16), width: 1 * u, height: .26 * u), belly);
    c.drawOval(Rect.fromCenter(center: at(.66, -.32), width: .5 * u, height: .42 * u), body);
    c.drawPath(
      Path()
        ..moveTo(at(.82, -.46).dx, at(.82, -.46).dy)
        ..lineTo(at(1.16, -.28).dx, at(1.16, -.28).dy)
        ..lineTo(at(.84, -.18).dx, at(.84, -.18).dy)
        ..close(),
      body,
    );
    c.drawCircle(at(1.14, -.29), .04 * u, _p(_C.ink));
    c.drawOval(Rect.fromCenter(center: at(.56, -.58), width: .14 * u, height: .24 * u), dark);
    c.drawCircle(at(.76, -.36), .045 * u, _p(_C.ink));
    c.drawCircle(at(-.72, -.08), .1 * u, body);
  }

  void _rabbit(Canvas c, Size s, double x, double y, double u) {
    final white = _p(_C.surface);
    final o = Offset(x * s.width, y * s.height);
    Offset at(double dx, double dy) => o + Offset(dx * u, dy * u);
    c.drawOval(Rect.fromCenter(center: at(0, 0), width: .8 * u, height: .62 * u), white);
    c.drawCircle(at(-.3, -.38), .26 * u, white);
    for (final dx in [-.42, -.24]) {
      c.drawOval(Rect.fromCenter(center: at(dx, -.82), width: .12 * u, height: .5 * u), white);
    }
    c.drawCircle(at(-.38, -.42), .035 * u, _p(_C.ink));
  }

  void _forestKancil(Canvas c, Size s) {
    _fill(c, s, _C.lanternSoft);
    _sun(c, s, .22, .22, .13, _C.lantern);
    _hill(c, s, const Color(0xFF7FD6A8), const [Offset(0, .5), Offset(.45, .36), Offset(1, .52)]);
    for (final (x, h) in const [(.08, .46), (.28, .36), (.86, .5), (.7, .34)]) {
      _pine(c, s, x, .68, h, const Color(0xFF12705A));
    }
    _hill(c, s, _C.leaf, const [Offset(0, .66), Offset(.5, .6), Offset(1, .68)]);
    // Sungai di depan.
    _hill(c, s, const Color(0xFF5B8DEF), const [Offset(0, .82), Offset(.5, .78), Offset(1, .84)]);
    _kancil(c, s, .38, .72, s.shortestSide * .14);
    _rabbit(c, s, .72, .74, s.shortestSide * .12);
    _hill(c, s, const Color(0xFF0F6B45), const [Offset(0, .94), Offset(.6, .9), Offset(1, .95)]);
  }

  void _child(Canvas c, Offset feet, double u, Color shirt) {
    c.drawRect(Rect.fromCenter(center: feet + Offset(-.12 * u, -.25 * u), width: .14 * u, height: .5 * u), _p(_C.deep));
    c.drawRect(Rect.fromCenter(center: feet + Offset(.12 * u, -.25 * u), width: .14 * u, height: .5 * u), _p(_C.deep));
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: feet + Offset(0, -.8 * u), width: .6 * u, height: .7 * u), Radius.circular(.12 * u)), _p(shirt));
    c.drawCircle(feet + Offset(0, -1.38 * u), .27 * u, _p(const Color(0xFF8A5A3B)));
    c.drawCircle(feet + Offset(0, -1.5 * u), .27 * u, _p(_C.ink));
    c.drawCircle(feet + Offset(0, -1.33 * u), .22 * u, _p(const Color(0xFF8A5A3B)));
  }

  void _kite(Canvas c, Size s) {
    _fill(c, s, const Color(0xFF8CCBF5));
    _sun(c, s, .88, .44, .07, _C.lantern);
    final k = Offset(s.width * .62, s.height * .48);
    final r = s.shortestSide * .085;
    final diamond = Path()
      ..moveTo(k.dx, k.dy - r)
      ..lineTo(k.dx + r * .72, k.dy)
      ..lineTo(k.dx, k.dy + r * 1.1)
      ..lineTo(k.dx - r * .72, k.dy)
      ..close();
    c.drawPath(diamond, _p(const Color(0xFF2F5FD0)));
    c.drawPath(
      Path()
        ..moveTo(k.dx, k.dy - r)
        ..lineTo(k.dx + r * .72, k.dy)
        ..lineTo(k.dx, k.dy)
        ..close(),
      _p(const Color(0xFF5B8DEF)),
    );
    final line = Paint()
      ..color = _C.ink
      ..strokeWidth = s.shortestSide * .006
      ..style = PaintingStyle.stroke;
    // Ekor dengan pita.
    var p = Offset(k.dx, k.dy + r * 1.1);
    for (var i = 0; i < 3; i++) {
      final n = p + Offset(-r * .25, r * .45);
      c.drawLine(p, n, line);
      c.drawPath(
        Path()
          ..moveTo(n.dx - r * .12, n.dy - r * .08)
          ..lineTo(n.dx + r * .12, n.dy + r * .08)
          ..lineTo(n.dx + r * .12, n.dy - r * .08)
          ..lineTo(n.dx - r * .12, n.dy + r * .08)
          ..close(),
        _p(i.isEven ? Thread.kunyit : Thread.jingga),
      );
      p = n;
    }
    _hill(c, s, _C.leaf, const [Offset(0, .7), Offset(.45, .62), Offset(1, .72)]);
    _hill(c, s, const Color(0xFF0F6B45), const [Offset(0, .9), Offset(.5, .84), Offset(1, .92)]);
    final feet = Offset(s.width * .3, s.height * .84);
    final u = s.shortestSide * .12;
    c.drawLine(feet + Offset(.3 * u, -.95 * u), Offset(k.dx, k.dy + r * .2), line);
    _child(c, feet, u, Thread.jingga);
  }

  void _market(Canvas c, Size s) {
    _fill(c, s, const Color(0xFFFFE3A0));
    c.drawRect(Rect.fromLTWH(0, s.height * .78, s.width, s.height * .22), _p(const Color(0xFFC98A4B)));
    final stalls = [(.04, Thread.daun), (.36, Thread.jingga), (.68, Thread.tarumMuda)];
    for (final (x, color) in stalls) {
      final left = s.width * x;
      final w = s.width * .28;
      final top = s.height * .42;
      // Atap bergaris.
      for (var i = 0; i < 6; i++) {
        c.drawRect(Rect.fromLTWH(left + w / 6 * i, top, w / 6 + .5, s.height * .08), _p(i.isEven ? color : _C.surface));
      }
      c.drawRect(Rect.fromLTWH(left + w * .06, top + s.height * .08, w * .04, s.height * .28), _p(const Color(0xFF7A4A22)));
      c.drawRect(Rect.fromLTWH(left + w * .9, top + s.height * .08, w * .04, s.height * .28), _p(const Color(0xFF7A4A22)));
      c.drawRect(Rect.fromLTWH(left, s.height * .66, w, s.height * .04), _p(const Color(0xFF9A5B2A)));
    }
    final r = s.shortestSide * .03;
    // Sayur, ikan, dan buah di meja.
    for (var i = 0; i < 4; i++) {
      c.drawCircle(Offset(s.width * (.09 + i * .055), s.height * .64), r, _p(const Color(0xFF2E8B57)));
    }
    for (var i = 0; i < 2; i++) {
      c.drawOval(Rect.fromCenter(center: Offset(s.width * (.44 + i * .12), s.height * .64), width: r * 3.4, height: r * 1.5), _p(const Color(0xFF7D96B8)));
    }
    for (var i = 0; i < 4; i++) {
      c.drawCircle(Offset(s.width * (.73 + i * .055), s.height * .64), r, _p(i.isEven ? const Color(0xFFE8572B) : _C.lantern));
    }
    final u = s.shortestSide * .11;
    _child(c, Offset(s.width * .42, s.height * .95), u, Thread.daun);
    // Keranjang kecil.
    c.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(s.width * .5, s.height * .84), width: u * .6, height: u * .4), Radius.circular(u * .08)),
      _p(const Color(0xFF8A5A2B)),
    );
  }

  void _rain(Canvas c, Size s) {
    _fill(c, s, const Color(0xFF8DA2C4));
    for (final (x, y, rr) in const [(.12, .4, .08), (.26, .38, .1), (.4, .41, .08), (.62, .38, .09), (.78, .41, .09), (.93, .39, .08)]) {
      c.drawCircle(Offset(s.width * x, s.height * y), s.shortestSide * rr, _p(const Color(0xFF5E6F8F)));
    }
    final drop = Paint()
      ..color = const Color(0xFFDDE7F7)
      ..strokeWidth = s.shortestSide * .008
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 26; i++) {
      final x = (i * 37 % 100) / 100 * s.width;
      final y = s.height * (.48 + (i * 53 % 30) / 100);
      c.drawLine(Offset(x, y), Offset(x - s.width * .02, y + s.height * .05), drop);
    }
    _hill(c, s, const Color(0xFF3E8E6A), const [Offset(0, .74), Offset(.5, .7), Offset(1, .76)]);
    c.drawOval(Rect.fromCenter(center: Offset(s.width * .7, s.height * .86), width: s.width * .3, height: s.height * .04), _p(const Color(0xFF6E8DBF)));
    final u = s.shortestSide * .13;
    final feet = Offset(s.width * .42, s.height * .9);
    _child(c, feet, u, Thread.tarumMuda);
    // Payung kuning.
    final top = feet + Offset(0, -2.1 * u);
    c.drawLine(top, feet + Offset(.3 * u, -1.1 * u), Paint()
      ..color = _C.ink
      ..strokeWidth = .06 * u);
    c.drawPath(
      Path()
        ..moveTo(top.dx - u, top.dy + .1 * u)
        ..quadraticBezierTo(top.dx, top.dy - 1.1 * u, top.dx + u, top.dy + .1 * u)
        ..close(),
      _p(Thread.kunyit),
    );
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.scene != scene;
}
