import 'package:flutter/material.dart';

import 'tokens.dart';

/// Kelas lebar jendela Material: compact di ponsel, medium di lipat dan tablet tegak, expanded di tablet mendatar.
/// Struktur layar ditentukan dari lebar jendela, bukan dari jenis perangkat, jadi split screen ikut tertangani.
enum WindowSize {
  compact,
  medium,
  expanded;

  static WindowSize of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 840) return expanded;
    if (w >= 600) return medium;
    return compact;
  }

  bool get isCompact => this == compact;
  bool get isWide => this != compact;
}

/// Layar pendek dan lebar, misalnya ponsel mendatar.
bool isShortLandscape(BuildContext context) {
  final s = MediaQuery.sizeOf(context);
  return s.width > s.height && s.height < 560;
}

double gutterFor(BuildContext context) => switch (WindowSize.of(context)) {
      WindowSize.compact => AppSpace.gutter,
      WindowSize.medium => 28,
      WindowSize.expanded => 36,
    };

/// Membatasi lebar isi di layar lebar, supaya baris tidak melar.
class Pane extends StatelessWidget {
  const Pane({super.key, required this.child, this.maxWidth = AppSpace.contentWidth});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(constraints: BoxConstraints(maxWidth: maxWidth), child: child),
      );
}

/// Daftar bergulir dengan padding gutter dan lebar terbatas.
class PaneList extends StatelessWidget {
  const PaneList({super.key, required this.children, this.maxWidth = AppSpace.contentWidth, this.bottom = 32});

  final List<Widget> children;
  final double maxWidth;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final g = gutterFor(context);
    return LayoutBuilder(builder: (context, c) {
      final side = c.maxWidth > maxWidth + g * 2 ? (c.maxWidth - maxWidth) / 2 : g;
      return ListView(padding: EdgeInsets.fromLTRB(side, g, side, bottom), children: children);
    });
  }
}

/// Grid sederhana: anak disusun ke beberapa kolom sesuai lebar, tinggi baris mengikuti isi.
class FlowColumns extends StatelessWidget {
  const FlowColumns({super.key, required this.children, this.minItemWidth = 300, this.gap = 12, this.maxColumns = 3});

  final List<Widget> children;
  final double minItemWidth;
  final double gap;
  final int maxColumns;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final cols = ((c.maxWidth + gap) / (minItemWidth + gap)).floor().clamp(1, maxColumns);
        if (cols == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[if (i > 0) SizedBox(height: gap), children[i]],
            ],
          );
        }
        final rows = <Widget>[];
        for (var i = 0; i < children.length; i += cols) {
          if (i > 0) rows.add(SizedBox(height: gap));
          rows.add(IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var j = 0; j < cols; j++) ...[
                  if (j > 0) SizedBox(width: gap),
                  Expanded(child: i + j < children.length ? children[i + j] : const SizedBox.shrink()),
                ],
              ],
            ),
          ));
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
      });
}
