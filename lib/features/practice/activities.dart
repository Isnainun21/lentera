import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/components.dart';
import '../../core/design/tokens.dart';

/// Aktivitas Mode Anak. Warna benang tiap aktivitas sama di semua layar.
enum Activity {
  read('Baca Kata', 'Dengar, lalu ucapkan', Thread.kunyit, '/session'),
  build('Susun Kata', 'Urutkan suku katanya', Thread.jingga, '/build'),
  listen('Dengar dan Pilih', 'Cari kata yang kamu dengar', Thread.laut, '/listen'),
  letters('Beda Huruf', 'b, d, p, q, m, n, u', Thread.tarumMuda, '/letters');

  const Activity(this.title, this.line, this.color, this.route);

  final String title;
  final String line;
  final Color color;
  final String route;

  void open(BuildContext context) => context.push(route);
}

/// Contoh kecil dari isi aktivitas, sebagai pengganti ikon. Anak melihat apa yang akan dikerjakan.
class ActivityDemo extends StatelessWidget {
  const ActivityDemo({super.key, required this.activity, this.size = 64});

  final Activity activity;
  final double size;

  @override
  Widget build(BuildContext context) {
    final style = AppText.heading.copyWith(color: Thread.onThread, fontSize: size * 0.3, height: 1);
    Widget chip(String t) => Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.08, vertical: size * 0.06),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(6)),
          child: Text(t, style: style.copyWith(fontSize: size * 0.22)),
        );
    final content = switch (activity) {
      Activity.read => Icon(Icons.mic_rounded, size: size * 0.5, color: Thread.onThread),
      Activity.build => Row(mainAxisSize: MainAxisSize.min, children: [chip('BU'), SizedBox(width: size * 0.05), chip('KU')]),
      Activity.listen => Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (final h in [.3, .55, .8, .45, .65, .35])
              Container(
                width: size * 0.07,
                height: size * h * 0.7,
                margin: EdgeInsets.symmetric(horizontal: size * 0.02),
                decoration: BoxDecoration(color: Thread.onThread, borderRadius: BorderRadius.circular(2)),
              ),
          ],
        ),
      Activity.letters => Text('b d', style: style.copyWith(fontSize: size * 0.36)),
    };
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: activity.color, borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
        alignment: Alignment.center,
        child: FittedBox(fit: BoxFit.scaleDown, child: Padding(padding: EdgeInsets.all(size * 0.08), child: content)),
      ),
    );
  }
}

/// Baris aktivitas: contoh isi di kiri, nama dan penjelasan di kanan.
class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Panel(
      padding: const EdgeInsets.all(12),
      onTap: () => activity.open(context),
      semanticLabel: '${activity.title}. ${activity.line}',
      child: Row(
        children: [
          ActivityDemo(activity: activity),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: AppText.bodyStrong),
                Text(activity.line, style: AppText.caption.copyWith(color: p.subInk)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: p.subInk),
        ],
      ),
    );
  }
}
