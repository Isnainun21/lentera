import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/tokens.dart';

class PracticeHubScreen extends StatelessWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.gutter),
          children: [
            Text('Mau latihan apa?', style: AppText.title),
            const SizedBox(height: 18),
            _PracticeCard(
              title: 'Baca Kata',
              detail: 'Dengar, lalu ucapkan',
              icon: Icons.record_voice_over_rounded,
              color: AppColors.lantern,
              onTap: () => context.push('/session'),
            ),
            const SizedBox(height: 14),
            _PracticeCard(
              title: 'Beda Huruf',
              detail: 'Cari huruf b, d, p, dan q',
              icon: Icons.abc_rounded,
              color: AppColors.sky,
              onTap: () => context.push('/letters'),
            ),
          ],
        ),
      );
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({required this.title, required this.detail, required this.icon, required this.color, required this.onTap});

  final String title;
  final String detail;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: '$title. $detail',
        excludeSemantics: true,
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(AppSpace.cardRadius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 56),
                  Text(title, style: AppText.title),
                  const SizedBox(height: 2),
                  Text(detail, style: AppText.body),
                ],
              ),
            ),
          ),
        ),
      );
}
