import 'package:flutter/material.dart';

import 'tokens.dart';

enum Scene { hills, forest, cat, zoo }

Scene sceneForStory(String id) => switch (id) {
      'c1' => Scene.forest,
      'c2' => Scene.cat,
      'c3' => Scene.zoo,
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
        _forest(c, s);
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
    _sun(c, s, .74, .3, .15, AppColors.lantern);
    _hill(c, s, const Color(0xFF1E7FA8), const [Offset(0, .55), Offset(.3, .4), Offset(.65, .6), Offset(1, .42)]);
    _hill(c, s, AppColors.leaf, const [Offset(0, .68), Offset(.4, .56), Offset(.75, .74), Offset(1, .62)]);
    _pine(c, s, .18, .72, .36, AppColors.deep);
    _pine(c, s, .3, .7, .28, const Color(0xFF12705A));
    _hill(c, s, const Color(0xFF0F6B45), const [Offset(0, .86), Offset(.5, .78), Offset(1, .9)]);
  }

  void _deer(Canvas c, Size s, double x, double y, double u) {
    final body = _p(const Color(0xFFD9823B));
    final dark = _p(const Color(0xFF8E4F1E));
    final o = Offset(x * s.width, y * s.height);
    Offset at(double dx, double dy) => o + Offset(dx * u, dy * u);
    for (final dx in [-.62, -.32, .34, .6]) {
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: at(dx, .62), width: .14 * u, height: .8 * u), Radius.circular(.07 * u)), dx < 0 ? dark : body);
    }
    c.drawOval(Rect.fromCenter(center: at(0, 0), width: 1.7 * u, height: .85 * u), body);
    c.drawPath(
      Path()
        ..moveTo(at(.42, -.2).dx, at(.42, -.2).dy)
        ..lineTo(at(.72, -1).dx, at(.72, -1).dy)
        ..lineTo(at(1.02, -.9).dx, at(1.02, -.9).dy)
        ..lineTo(at(.86, .1).dx, at(.86, .1).dy)
        ..close(),
      body,
    );
    c.drawOval(Rect.fromCenter(center: at(1, -1.12), width: .72 * u, height: .46 * u), body);
    c.drawOval(Rect.fromCenter(center: at(.66, -1.36), width: .18 * u, height: .42 * u), dark);
    c.drawOval(Rect.fromCenter(center: at(.86, -1.44), width: .16 * u, height: .4 * u), dark);
    c.drawCircle(at(1.08, -1.16), .05 * u, _p(AppColors.ink));
    c.drawCircle(at(1.33, -1.1), .06 * u, _p(AppColors.ink));
    c.drawCircle(at(-.32, -.08), .07 * u, _p(const Color(0xFFF7DEC0)));
    c.drawCircle(at(.05, .08), .07 * u, _p(const Color(0xFFF7DEC0)));
  }

  void _forest(Canvas c, Size s) {
    _fill(c, s, AppColors.lanternSoft);
    _sun(c, s, .22, .22, .13, AppColors.lantern);
    _hill(c, s, const Color(0xFF7FD6A8), const [Offset(0, .5), Offset(.45, .36), Offset(1, .52)]);
    for (final (x, h) in const [(.08, .46), (.28, .36), (.86, .5), (.7, .34)]) {
      _pine(c, s, x, .68, h, const Color(0xFF12705A));
    }
    _hill(c, s, AppColors.leaf, const [Offset(0, .66), Offset(.5, .6), Offset(1, .68)]);
    _deer(c, s, .47, .69, s.shortestSide * .13);
    _hill(c, s, const Color(0xFF0F6B45), const [Offset(0, .9), Offset(.6, .84), Offset(1, .92)]);
  }

  void _catScene(Canvas c, Size s) {
    _fill(c, s, const Color(0xFFFF9F68));
    c.drawRect(Rect.fromLTWH(s.width * .62, s.height * .12, s.width * .27, s.height * .36), _p(const Color(0xFFBDE4FA)));
    c.drawRect(Rect.fromLTWH(s.width * .745, s.height * .12, s.width * .02, s.height * .36), _p(AppColors.surface));
    c.drawRect(Rect.fromLTWH(s.width * .62, s.height * .29, s.width * .27, s.height * .02), _p(AppColors.surface));
    c.drawRect(Rect.fromLTWH(0, s.height * .72, s.width, s.height * .28), _p(const Color(0xFFB65A2B)));
    final u = s.shortestSide * .17;
    final o = Offset(s.width * .38, s.height * .62);
    Offset at(double x, double y) => o + Offset(x * u, y * u);
    final white = _p(AppColors.surface);
    c.drawPath(
      Path()
        ..moveTo(at(.75, .6).dx, at(.75, .6).dy)
        ..quadraticBezierTo(at(1.9, .7).dx, at(1.9, .7).dy, at(1.55, -.6).dx, at(1.55, -.6).dy),
      Paint()
        ..color = AppColors.surface
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
      c.drawCircle(at(dir * .27, -.8), .085 * u, _p(AppColors.ink));
    }
    c.drawCircle(at(0, -.6), .07 * u, _p(const Color(0xFFFF7A70)));
    c.drawCircle(at(-1.5, .75), .42 * u, _p(AppColors.sky));
    c.drawPath(
      Path()
        ..moveTo(at(-1.92, .75).dx, at(-1.92, .75).dy)
        ..quadraticBezierTo(at(-1.5, .45).dx, at(-1.5, .45).dy, at(-1.08, .75).dx, at(-1.08, .75).dy),
      Paint()
        ..color = AppColors.surface
        ..style = PaintingStyle.stroke
        ..strokeWidth = .06 * u,
    );
  }

  void _zoo(Canvas c, Size s) {
    _fill(c, s, const Color(0xFF7FD6C2));
    _sun(c, s, .82, .2, .11, AppColors.lantern);
    _hill(c, s, AppColors.leaf, const [Offset(0, .7), Offset(.5, .62), Offset(1, .72)]);
    final u = s.shortestSide * .15;
    final o = Offset(s.width * .46, s.height * .68);
    Offset at(double x, double y) => o + Offset(x * u, y * u);
    final body = _p(AppColors.lantern);
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
    c.drawCircle(at(1.2, -2.42), .055 * u, _p(AppColors.ink));
    for (final dx in [.82, 1.02]) {
      c.drawRect(Rect.fromCenter(center: at(dx, -2.75), width: .07 * u, height: .36 * u), spot);
    }
    for (final (x, y, r) in const [(-.45, -.1, .17), (.05, .15, .15), (.3, -.25, .13), (.72, -1.1, .12), (.85, -1.7, .1), (.6, -.55, .12)]) {
      c.drawCircle(at(x, y), r * u, spot);
    }
    _hill(c, s, const Color(0xFF0F6B45), const [Offset(0, .94), Offset(.55, .88), Offset(1, .95)]);
    _pine(c, s, .12, .86, .4, const Color(0xFF12705A));
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.scene != scene;
}
