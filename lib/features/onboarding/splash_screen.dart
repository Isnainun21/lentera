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
  double _light = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _light = 1));
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
        backgroundColor: AppColors.ink,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 96,
                height: 128,
                child: LanternFrame(color: AppColors.subInk, light: _light, height: 128, child: const SizedBox.shrink()),
              ),
              const SizedBox(height: 24),
              Text('Lentera', style: AppText.title.copyWith(color: Colors.white)),
            ],
          ),
        ),
      );
}
