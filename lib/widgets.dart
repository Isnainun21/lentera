import 'package:flutter/material.dart';

import 'theme.dart';

/// Tombol "chunky" khas UI Stitch: pill, min-height 56, bayangan offset solid,
/// menekan ke bawah saat ditekan.
class ChunkyButton extends StatefulWidget {
  const ChunkyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.background = AppColors.primaryContainer,
    this.foreground = AppColors.onPrimaryContainer,
    this.shadow = AppColors.shadowTeal,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final Color shadow;
  final bool expand;

  @override
  State<ChunkyButton> createState() => _ChunkyButtonState();
}

class _ChunkyButtonState extends State<ChunkyButton> {
  bool _pressed = false;

  void _set(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 90),
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: disabled ? widget.background.withValues(alpha: 0.5) : widget.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: (_pressed || disabled)
            ? const []
            : [BoxShadow(color: widget.shadow, offset: const Offset(0, 4))],
      ),
      transform: _pressed ? Matrix4.translationValues(0, 4, 0) : null,
      child: Row(
        mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: widget.foreground, size: 22),
            const SizedBox(width: 8),
          ],
          Text(
            widget.label,
            style: AppText.headlineSm.copyWith(color: widget.foreground),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTapDown: disabled ? null : (_) => _set(true),
      onTapUp: disabled ? null : (_) => _set(false),
      onTapCancel: disabled ? null : () => _set(false),
      onTap: widget.onPressed,
      child: child,
    );
  }
}

/// Kartu putih dengan radius 24 dan bayangan ambient yang sangat lembut.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = AppColors.surfaceLowest,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: borderColor ?? AppColors.outlineVariant.withValues(alpha: 0.5)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D1F2124),
              offset: Offset(0, 8),
              blurRadius: 24,
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Color(0x081F2124),
              offset: Offset(0, 2),
              blurRadius: 6,
              spreadRadius: -1,
            ),
          ],
        ),
        child: child,
      );
}

/// Bilah progres bertahap (rounded penuh, isi primary-container).
class SteppedProgress extends StatelessWidget {
  const SteppedProgress({super.key, required this.value, this.height = 14, this.color});

  final double value;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          minHeight: height,
          backgroundColor: AppColors.surfaceHighest,
          valueColor: AlwaysStoppedAnimation(color ?? AppColors.primaryContainer),
        ),
      );
}

/// Pil label kecil (level, status, dsb).
class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.background = AppColors.surfaceHigh,
    this.foreground = AppColors.onSurfaceVariant,
    this.icon,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: foreground),
              const SizedBox(width: 4),
            ],
            Text(label, style: AppText.labelMd.copyWith(color: foreground)),
          ],
        ),
      );
}

/// Widget avatar bundar dengan emoji.
class AvatarBubble extends StatelessWidget {
  const AvatarBubble({
    super.key,
    required this.emoji,
    this.radius = 24,
    this.background = AppColors.primaryFixed,
    this.selected = false,
    this.onTap,
  });

  final String emoji;
  final double radius;
  final Color background;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
            border: selected
                ? Border.all(color: AppColors.primaryContainer, width: 3)
                : Border.all(color: Colors.transparent, width: 3),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x3338C6B6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(fontSize: radius * 0.7),
            ),
          ),
        ),
      );
}

/// Kartu modul untuk halaman beranda.
class ModulCard extends StatelessWidget {
  const ModulCard({
    super.key,
    required this.judul,
    required this.deskripsi,
    required this.icon,
    this.label,
    this.labelColor = AppColors.primary,
    this.onTap,
  });

  final String judul;
  final String deskripsi;
  final IconData icon;
  final String? label;
  final Color labelColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: SoftCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label != null) ...[
                      Text(
                        label!,
                        style: AppText.labelSm.copyWith(color: labelColor),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(judul, style: AppText.headlineSm),
                    const SizedBox(height: 2),
                    Text(
                      deskripsi,
                      style: AppText.bodyMd,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 28),
            ],
          ),
        ),
      );
}

/// Penanda warna untuk huruf b/d/p/q.
class LetterColorDot extends StatelessWidget {
  const LetterColorDot({super.key, required this.huruf});

  final String huruf;

  Color get _color => switch (huruf.toLowerCase()) {
        'b' => AppColors.hurufB,
        'd' => AppColors.hurufD,
        'p' => AppColors.hurufP,
        'q' => AppColors.hurufQ,
        _ => AppColors.onSurfaceVariant,
      };

  @override
  Widget build(BuildContext context) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
        ),
      );
}

/// Tombol sekunder dengan gaya lavender.
class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: AppColors.softLavender,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: _pressed
              ? const []
              : const [BoxShadow(color: AppColors.lavenderShadow, offset: Offset(0, 4))],
        ),
        transform: _pressed ? Matrix4.translationValues(0, 4, 0) : null,
        child: Row(
          mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: AppColors.onSurface, size: 22),
              const SizedBox(width: 8),
            ],
            Text(
              widget.label,
              style: AppText.headlineSm.copyWith(color: AppColors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section header with optional trailing.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.headlineSm),
                if (subtitle != null) Text(subtitle!, style: AppText.bodyMd),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      );
}