import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/practice/models.dart';
import 'tokens.dart';
import 'weave.dart';

export 'weave.dart' show motionReduced, AvatarMotif, LogoMark, Selvedge, ThreadSlots, WeekCloth, MotifTile, Motif, ThreadBar;

/// Satu aksi utama per layar. Tombol lain memakai [QuietAction].
class PrimaryAction extends StatelessWidget {
  const PrimaryAction({super.key, required this.label, required this.onPressed, this.icon, this.onThread = false});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Di atas bidang benang (kunyit, daun) tombol selalu tarum, di kedua tema.
  final bool onThread;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onPressed!();
                },
          style: onThread ? FilledButton.styleFrom(backgroundColor: Thread.tarum, foregroundColor: Colors.white) : null,
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
  const QuietAction({super.key, required this.label, required this.onPressed, this.icon, this.destructive = false});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: p.surface,
          foregroundColor: destructive ? p.retry : p.ink,
          minimumSize: const Size.fromHeight(AppSpace.tapChild),
          side: BorderSide(color: p.line),
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
}

/// Panel kain. Pinggir bergaris hanya muncul bila [selvedge] diberi warna.
class Panel extends StatelessWidget {
  const Panel({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.color, this.selvedge, this.onTap, this.semanticLabel});

  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final Color? selvedge;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    Widget body = Padding(padding: padding, child: child);
    if (selvedge != null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [Selvedge(lead: selvedge!), Flexible(child: body)],
      );
    }
    final material = Material(
      color: color ?? p.surface,
      borderRadius: BorderRadius.circular(AppSpace.panelRadius),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? body : InkWell(onTap: onTap, child: body),
    );
    if (onTap == null && semanticLabel == null) return material;
    return Semantics(button: onTap != null, label: semanticLabel, excludeSemantics: semanticLabel != null, child: material);
  }
}

/// Judul bagian dengan aksi kecil di kanan.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.action, this.onAction});

  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 10),
        child: Row(
          children: [
            Expanded(child: Semantics(header: true, child: Text(text, style: AppText.heading))),
            if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
          ],
        ),
      );
}

/// Tombol ikon persegi kecil, untuk header dan di atas gambar.
class RoundButton extends StatelessWidget {
  const RoundButton({super.key, required this.icon, required this.label, required this.onPressed, this.color, this.foreground, this.size = AppSpace.tapGuardian});

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? foreground;

  /// 56 untuk tombol yang disentuh anak, 48 untuk pendamping.
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: Icon(icon, color: foreground ?? p.ink),
      style: IconButton.styleFrom(
        backgroundColor: color ?? p.surface,
        minimumSize: Size(size, size),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpace.tileRadius)),
      ),
    );
  }
}

enum TileState { idle, correct, retry, active }

class SyllableTile extends StatelessWidget {
  const SyllableTile({super.key, required this.text, this.state = TileState.idle, this.onTap, this.letterColors = false, this.minSize = 84});

  final String text;
  final TileState state;
  final VoidCallback? onTap;
  final bool letterColors;
  final double minSize;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final (bg, fg, icon, stateLabel) = switch (state) {
      TileState.idle => (p.surface, p.ink, null, ''),
      TileState.active => (Thread.kesumba, Thread.onThread, Icons.volume_up_rounded, ', sedang didengar'),
      TileState.correct => (p.okSoft, p.ok, Icons.check_rounded, ', tepat'),
      TileState.retry => (p.retrySoft, p.retry, Icons.hearing_rounded, ', coba lagi'),
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
          child: AnimatedContainer(
            duration: motionReduced(context) ? Duration.zero : AppMotion.quick,
            constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpace.tileRadius),
              border: Border.all(color: state == TileState.idle ? p.line : Colors.transparent, width: 1.5),
            ),
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
  const LetterMarkedText(this.text, {super.key, required this.style, this.markLetters = false, this.textAlign, this.onThread = false});

  final String text;
  final TextStyle style;
  final bool markLetters;
  final TextAlign? textAlign;

  /// Di atas bidang kunyit dipakai warna penanda yang lebih gelap.
  final bool onThread;

  @override
  Widget build(BuildContext context) {
    if (!markLetters) return Text(text, style: style, textAlign: textAlign);
    final p = Pal.of(context);
    final b = onThread ? const Color(0xFF1D3F8F) : p.letterB;
    final d = onThread ? const Color(0xFF8A3A08) : p.letterD;
    return Text.rich(
      TextSpan(children: [
        for (final c in text.split(''))
          TextSpan(
            text: c,
            style: switch (c.toLowerCase()) {
              'b' => style.copyWith(color: b),
              'd' => style.copyWith(color: d),
              _ => style,
            },
          ),
      ]),
      textAlign: textAlign,
    );
  }
}

/// Pesan status satu baris dengan ikon. Warna selalu ditemani ikon.
class StatusLine extends StatelessWidget {
  const StatusLine({super.key, required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: AppText.bodyStrong)),
          ],
        ),
      );
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
      HapticFeedback.mediumImpact();
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
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Semantics(
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
                  child: CircularProgressIndicator(value: _progress.value, strokeWidth: 3, color: p.ink, backgroundColor: Colors.transparent),
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}

class MessageState extends StatelessWidget {
  const MessageState({super.key, required this.title, this.body, this.action, this.motif});

  final String title;
  final String? body;
  final Widget? action;
  final Motif? motif;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(AppSpace.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (motif != null) ...[
              MotifTile(motif: motif!, ground: Pal.of(context).surfaceAlt, ink: Pal.of(context).subInk, size: 72),
              const SizedBox(height: 16),
            ],
            Text(title, style: AppText.heading, textAlign: TextAlign.center),
            if (body != null) ...[
              const SizedBox(height: 8),
              Text(body!, style: AppText.bodyGuardian.copyWith(color: Pal.of(context).subInk), textAlign: TextAlign.center),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      );
}

/// Keypad PIN 4 angka. Tanpa keyboard sistem, tombol besar, dan PIN tidak pernah tampil.
class PinPad extends StatefulWidget {
  const PinPad({super.key, required this.onComplete, this.error, this.length = 4});

  /// Mengembalikan true bila PIN diterima. Bila false, titik dikosongkan.
  final Future<bool> Function(String pin) onComplete;
  final String? error;
  final int length;

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  String _pin = '';
  bool _busy = false;

  Future<void> _press(String digit) async {
    if (_busy || _pin.length >= widget.length) return;
    HapticFeedback.selectionClick();
    setState(() => _pin += digit);
    if (_pin.length == widget.length) {
      _busy = true;
      final ok = await widget.onComplete(_pin);
      if (!mounted) return;
      setState(() {
        _busy = false;
        if (!ok) _pin = '';
      });
    }
  }

  void _back() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    Widget key(String d) => _Key(
          key: ValueKey('pin-$d'),
          label: 'Angka $d',
          onTap: () => _press(d),
          child: Text(d, style: AppText.title),
        );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: '${_pin.length} dari ${widget.length} angka terisi',
            liveRegion: true,
            excludeSemantics: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.length; i++)
                  AnimatedContainer(
                    duration: AppMotion.quick,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: i < _pin.length ? p.ink : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: p.ink, width: 2),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: widget.error == null
                ? null
                : Center(
                    child: Semantics(
                      liveRegion: true,
                      child: Text(widget.error!, style: AppText.bodyGuardian.copyWith(color: p.retry), textAlign: TextAlign.center),
                    ),
                  ),
          ),
          for (final row in const [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [for (final d in row) Expanded(child: key(d))]),
            ),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(child: key('0')),
              Expanded(
                child: _Key(
                  key: const ValueKey('pin-back'),
                  label: 'Hapus satu angka',
                  onTap: _back,
                  plain: true,
                  child: Icon(Icons.backspace_outlined, color: p.ink),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({super.key, required this.label, required this.onTap, required this.child, this.plain = false});

  final String label;
  final VoidCallback onTap;
  final Widget child;
  final bool plain;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: plain ? Colors.transparent : p.surface,
          borderRadius: BorderRadius.circular(AppSpace.tileRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpace.tileRadius),
            child: SizedBox(height: 64, child: Center(child: child)),
          ),
        ),
      ),
    );
  }
}

TileState tileStateFor(int index, AttemptStatus? status, List<int> matched) {
  if (status == null || status == AttemptStatus.unclear) return TileState.idle;
  return matched.contains(index) ? TileState.correct : TileState.retry;
}
