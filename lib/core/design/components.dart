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

/// Bidang warna utama tempat kata tampil. Warnanya berpindah saat kata terbaca.
class WordField extends StatelessWidget {
  const WordField({super.key, required this.child, required this.color, this.height = 360});

  final Widget child;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: motionReduced(context) ? Duration.zero : const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppSpace.cardRadius)),
        child: child,
      );
}

/// Tombol bulat kecil di atas gambar atau di header.
class RoundButton extends StatelessWidget {
  const RoundButton({super.key, required this.icon, required this.label, required this.onPressed, this.color = AppColors.surface, this.foreground = AppColors.ink});

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: label,
        onPressed: onPressed,
        icon: Icon(icon, color: foreground),
        style: IconButton.styleFrom(backgroundColor: color, minimumSize: const Size(AppSpace.tapGuardian, AppSpace.tapGuardian)),
      );
}

/// Cincin satu hari. Hari kosong tetap netral.
class DayRing extends StatelessWidget {
  const DayRing({super.key, required this.done, this.size = 36, this.today = false});

  final bool done;
  final bool today;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: done ? AppColors.leaf : Colors.transparent,
          border: Border.all(color: done ? AppColors.leaf : (today ? AppColors.ink : AppColors.idle), width: 3.5),
        ),
        child: done ? Icon(Icons.check_rounded, size: size * 0.6, color: AppColors.ink) : null,
      );
}

/// Baris aktivitas: lingkaran ikon besar dengan label.
class ActivityCircle extends StatelessWidget {
  const ActivityCircle({super.key, required this.icon, required this.label, required this.color, required this.onTap});

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpace.tileRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  child: Icon(icon, size: 32, color: AppColors.ink),
                ),
                const SizedBox(height: 8),
                Text(label, style: AppText.caption.copyWith(color: AppColors.ink), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
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
      TileState.idle => (AppColors.surface, AppColors.ink, null, ''),
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

/// Tujuh cincin mingguan.
class WeekLanterns extends StatelessWidget {
  const WeekLanterns({super.key, required this.lit});

  final List<bool> lit;
  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final count = lit.where((x) => x).length;
    final today = DateTime.now().weekday - 1;
    return Semantics(
      label: 'Minggu ini: berlatih $count hari',
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Column(
                children: [
                  DayRing(done: lit[i], today: i == today),
                  const SizedBox(height: 6),
                  Text(_days[i], style: AppText.caption.copyWith(fontSize: 13), softWrap: false, overflow: TextOverflow.visible),
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
