import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/tokens.dart';
import '../home/home_screen.dart';

class PracticeHubScreen extends StatelessWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.gutter),
          children: [
            Text('Mau latihan apa?', style: AppText.title),
            const SizedBox(height: 20),
            ActivityPillar(
              label: 'Baca Kata',
              description: 'Dengar, lalu ucapkan',
              icon: Icons.record_voice_over_rounded,
              color: AppColors.lantern,
              height: 240,
              onTap: () => context.push('/session'),
            ),
            const SizedBox(height: 12),
            ActivityPillar(
              label: 'Beda Huruf',
              description: 'Cari huruf yang mirip',
              icon: Icons.abc_rounded,
              color: AppColors.sky,
              height: 240,
              onTap: () => context.push('/letters'),
            ),
          ],
        ),
      );
}
