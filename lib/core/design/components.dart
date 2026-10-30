import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/practice/models.dart';
import 'tokens.dart';

bool motionReduced(BuildContext context) => MediaQuery.disableAnimationsOf(context);

/// Satu aksi utama per layar. Tombol lain memakai [QuietAction].
class PrimaryAction extends StatelessWidget {
  const PrimaryAction({super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.ink,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.idle,
            disabledForegroundColor: AppColors.subInk,
            minimumSize: const Size.fromHeight(64),
            shape: const StadiumBorder(),
            textStyle: AppText.bodyStrong,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 24), const SizedBox(width: 10)],
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          ),
        ),
      );
}

class QuietAction extends StatelessWidget {
  const QuietAction({super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.ink,
            minimumSize: const Size.fromHeight(AppSpace.tapChild),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
            textStyle: AppText.bodyStrong,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 22), const SizedBox(width: 8)],
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          ),
        ),
      );
}

class CardBox extends StatelessWidget {
  const CardBox({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.color = AppColors.surface});

  final Widget child;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppSpace.cardRadius)),
        child: child,
      );
}

/// Bentuk lengkung lentera: puncak setengah lingkaran, bawah membulat.
class LanternShape extends ShapeBorder {
  const LanternShape({this.bottomRadius = 24});

  final double bottomRadius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final top = Radius.circular(rect.width / 2 > rect.height * 0.6 ? rect.height * 0.6 : rect.width / 2);
    return Path()
      ..addRRect(RRect.fromRectAndCorners(
        rect,
        topLeft: top,
        topRight: top,
        bottomLeft: Radius.circular(bottomRadius),
        bottomRight: Radius.circular(bottomRadius),
      ));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => LanternShape(bottomRadius: bottomRadius * t);
}

/// Bingkai kata. [light] 0 sampai 1 adalah cahaya yang mengisi dari bawah.
class LanternFrame extends StatelessWidget {
  const LanternFrame({super.key, required this.child, this.light = 0, this.color = AppColors.surface, this.height});

  final Widget child;
  final double light;
  final Color color;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final duration = motionReduced(context) ? Duration.zero : const Duration(milliseconds: 400);
    return ClipPath(
      clipper: ShapeBorderClipper(shape: const LanternShape()),
      child: Container(
        height: height,
        width: double.infinity,
        color: color,
        child: Stack(
          fit: height == null ? StackFit.passthrough : StackFit.expand,
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: light.clamp(0.0, 1.0)),
                  duration: duration,
                  curve: Curves.easeOut,
                  builder: (_, v, _) => FractionallySizedBox(
                    heightFactor: v,
                    widthFactor: 1,
                    child: const ColoredBox(color: AppColors.lantern),
                  ),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

enum TileState { idle, correct, retry }

class SyllableTile extends StatelessWidget {
  const SyllableTile({super.key, required this.text, this.state = TileState.idle, this.onTap, this.letterColors = false});

  final String text;
  final TileState state;
  final VoidCallback? onTap;
  final bool letterColors;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon, stateLabel) = switch (state) {
      TileState.idle => (AppColors.idle, AppColors.ink, null, ''),
      TileState.correct => (AppColors.okSoft, AppColors.ok, Icons.check_rounded, ', tepat'),
      TileState.retry => (AppColors.retrySoft, AppColors.retry, Icons.hearing_rounded, ', coba lagi'),
    };
    return Semantics(
      button: onTap != null,
      label: '${text.toLowerCase()}$stateLabel',
      excludeSemantics: true,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpace.tileRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpace.tileRadius),
          child: Container(
            constraints: const BoxConstraints(minWidth: 84, minHeight: 84),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LetterMarkedText(text, style: AppText.syllable.copyWith(color: fg), markLetters: letterColors && state == TileState.idle),
                if (icon != null) Icon(icon, size: 22, color: fg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Menandai huruf b dan d dengan warna. Warna hanya tambahan dan bisa dimatikan pendamping.
class LetterMarkedText extends StatelessWidget {
  const LetterMarkedText(this.text, {super.key, required this.style, this.markLetters = false, this.textAlign});

  final String text;
  final TextStyle style;
  final bool markLetters;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    if (!markLetters) return Text(text, style: style, textAlign: textAlign);
    return Text.rich(
      TextSpan(children: [
        for (final c in text.split(''))
          TextSpan(
            text: c,
            style: switch (c.toLowerCase()) {
              'b' => style.copyWith(color: AppColors.letterB),
              'd' => style.copyWith(color: AppColors.letterD),
              _ => style,
            },
          ),
      ]),
      textAlign: textAlign,
    );
  }
}

class AvatarCircle extends StatelessWidget {
  const AvatarCircle({super.key, required this.avatarId, required this.name, this.size = 48});

  final int avatarId;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.avatars[avatarId % AppColors.avatars.length], shape: BoxShape.circle),
          child: Text(
            name.isEmpty ? '?' : name.characters.first.toUpperCase(),
            style: AppText.heading.copyWith(fontSize: size * 0.42),
          ),
        ),
      );
}

/// Tujuh lentera kecil. Hari kosong tetap netral, tidak ada streak yang putus.
class WeekLanterns extends StatelessWidget {
  const WeekLanterns({super.key, required this.lit});

  final List<bool> lit;
  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final count = lit.where((x) => x).length;
    return Semantics(
      label: 'Lentera minggu ini: $count hari menyala',
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SizedBox(
                      height: 40,
                      child: LanternFrame(
                        color: AppColors.idle,
                        light: lit[i] ? 1 : 0,
                        height: 40,
                        child: const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(_days[i], style: AppText.caption, overflow: TextOverflow.visible, softWrap: false),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Tahan untuk membuka. Menjaga Area Pendamping dari ketukan tidak sengaja.
class HoldToOpen extends StatefulWidget {
  const HoldToOpen({super.key, required this.onOpen, required this.child, required this.label, this.hold = const Duration(seconds: 3)});

  final VoidCallback onOpen;
  final Widget child;
  final String label;
  final Duration hold;

  @override
  State<HoldToOpen> createState() => _HoldToOpenState();
}

class _HoldToOpenState extends State<HoldToOpen> with SingleTickerProviderStateMixin {
  late final _progress = AnimationController(vsync: this, duration: widget.hold);
  Timer? _timer;

  void _start() {
    _progress.forward(from: 0);
    _timer = Timer(widget.hold, () {
      _reset();
      widget.onOpen();
    });
  }

  void _reset() {
    _timer?.cancel();
    _progress.value = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: widget.label,
        onLongPress: widget.onOpen,
        excludeSemantics: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _start(),
          onTapUp: (_) => _reset(),
          onTapCancel: _reset,
          child: SizedBox(
            width: AppSpace.tapGuardian,
            height: AppSpace.tapGuardian,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _progress,
                  builder: (_, _) => SizedBox(
                    width: 42,
                    height: 42,
                    child: CircularProgressIndicator(
                      value: _progress.value,
                      strokeWidth: 3,
                      color: AppColors.ink,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                widget.child,
              ],
            ),
          ),
        ),
      );
}

class MessageState extends StatelessWidget {
  const MessageState({super.key, required this.title, this.body, this.action});

  final String title;
  final String? body;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(AppSpace.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppText.heading, textAlign: TextAlign.center),
            if (body != null) ...[
              const SizedBox(height: 8),
              Text(body!, style: AppText.bodyGuardian, textAlign: TextAlign.center),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      );
}

TileState tileStateFor(int index, AttemptStatus? status, List<int> matched) {
  if (status == null || status == AttemptStatus.unclear) return TileState.idle;
  return matched.contains(index) ? TileState.correct : TileState.retry;
}
