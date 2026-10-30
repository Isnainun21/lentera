import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/tokens.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    final repo = ref.read(repositoryProvider);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final hasPin = await repo.hasPin();
    final children = await repo.watchChildren().first;
    final active = await repo.readKey('activeChild');
    if (!mounted) return;
    if (!hasPin || children.isEmpty) {
      context.go('/setup');
    } else if (children.any((c) => c.id == active)) {
      context.go('/home');
    } else {
      context.go('/profiles');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.deep,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LogoMark(size: 112),
              const SizedBox(height: 20),
              Text('Lentera', style: AppText.wordHero.copyWith(color: Colors.white, fontSize: 52)),
              const SizedBox(height: 10),
              Text('Belajar membaca, pelan-pelan', style: AppText.body.copyWith(color: const Color(0xFFE6EEF0))),
            ],
          ),
        ),
      );
}
