import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/components.dart';
import '../../core/design/responsive.dart';
import '../../core/design/tokens.dart';

/// Kerangka permainan: tombol berhenti, pita benang, dan isi yang terbagi dua di layar lebar.
class GameFrame extends StatelessWidget {
  const GameFrame({
    super.key,
    required this.color,
    required this.total,
    required this.done,
    required this.position,
    required this.stage,
    required this.controls,
  });

  final Color color;
  final int total;
  final int done;
  final int position;
  final Widget stage;
  final Widget controls;

  @override
  Widget build(BuildContext context) {
    final g = gutterFor(context);
    final split = WindowSize.of(context).isWide || isShortLandscape(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(g, 12, g, g),
          child: Pane(
            maxWidth: split ? 1200 : 640,
            child: Column(
              children: [
                Row(
                  children: [
                    RoundButton(icon: Icons.close_rounded, label: 'Berhenti', size: AppSpace.tapChild, onPressed: () => context.pop()),
                    const SizedBox(width: 14),
                    Expanded(child: ThreadSlots(total: total, filled: done, color: color, active: done < total ? done : null)),
                    const SizedBox(width: 14),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 96),
                      child: FittedBox(fit: BoxFit.scaleDown, child: Text('$position dari $total', style: AppText.bodyStrong)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: split
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(flex: 6, child: SingleChildScrollView(child: stage)),
                            SizedBox(width: g),
                            Expanded(flex: 4, child: Center(child: SingleChildScrollView(child: controls))),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(child: SingleChildScrollView(child: stage)),
                            const SizedBox(height: 12),
                            controls,
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bidang warna aktivitas dengan pinggir kain, tempat soal tampil besar.
class GameField extends StatelessWidget {
  const GameField({super.key, required this.color, required this.child, this.minHeight = 220});

  final Color color;
  final Widget child;
  final double minHeight;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: motionReduced(context) ? Duration.zero : AppMotion.panel,
        constraints: BoxConstraints(minHeight: isShortLandscape(context) ? 160 : minHeight),
        width: double.infinity,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppSpace.panelRadius)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            const Positioned(top: 0, left: 0, right: 0, child: Selvedge(lead: Thread.tarum, height: 8)),
            Padding(padding: const EdgeInsets.fromLTRB(20, 32, 20, 24), child: Center(child: child)),
          ],
        ),
      );
}

/// Akhir permainan: pita penuh, satu kalimat usaha, tanpa skor.
class GameDone extends StatelessWidget {
  const GameDone({super.key, required this.color, required this.total, required this.title, required this.line, required this.onAgain});

  final Color color;
  final int total;
  final String title;
  final String line;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: PaneList(
            maxWidth: 640,
            children: [
              const SizedBox(height: 12),
              Panel(
                color: color,
                selvedge: Thread.tarum,
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.display.copyWith(color: Thread.onThread)),
                    const SizedBox(height: 6),
                    Text(line, style: AppText.body.copyWith(color: Thread.onThread)),
                    const SizedBox(height: 24),
                    ThreadSlots(total: total, filled: total, color: Thread.onThread.withValues(alpha: 0.85), onDark: true, height: 22),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              PrimaryAction(label: 'Selesai', onPressed: () => context.pop()),
              const SizedBox(height: 10),
              QuietAction(label: 'Main lagi', icon: Icons.replay_rounded, onPressed: onAgain),
            ],
          ),
        ),
      );
}
