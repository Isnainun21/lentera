import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/design/tokens.dart';
import '../features/guardian/guardian_screens.dart';
import '../features/guardian/guardian_settings_screens.dart';
import '../features/guardian/speech_test_screen.dart';
import '../features/home/home_screen.dart';
import '../features/letters/letters_screen.dart';
import '../features/onboarding/setup_screen.dart';
import '../features/onboarding/splash_screen.dart';
import '../features/practice/practice_hub_screen.dart';
import '../features/practice/session_screen.dart';
import '../features/rewards/collection_screen.dart';
import '../features/stories/stories_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
        GoRoute(path: '/setup', builder: (_, s) => SetupScreen(addingChild: s.uri.queryParameters['add'] == '1', name: s.uri.queryParameters['name'] ?? '')),
        GoRoute(path: '/profiles', builder: (_, _) => const ProfilePickerScreen()),
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => _ChildShell(shell: shell),
          branches: [
            StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/practice', builder: (_, _) => const PracticeHubScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/stories', builder: (_, _) => const StoriesScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/collection', builder: (_, _) => const CollectionScreen())]),
          ],
        ),
        GoRoute(path: '/session', builder: (_, _) => const SessionScreen()),
        GoRoute(path: '/letters', builder: (_, _) => const LettersScreen()),
        GoRoute(path: '/story/:id', builder: (_, s) => StoryReaderScreen(storyId: s.pathParameters['id']!)),
        GoRoute(path: '/guardian-pin', builder: (_, _) => const GuardianPinScreen()),
        GoRoute(path: '/guardian', builder: (_, _) => const GuardianSummaryScreen(), routes: [
          GoRoute(path: 'history', builder: (_, _) => const SessionHistoryScreen()),
          GoRoute(path: 'learning', builder: (_, _) => const LearningSettingsScreen()),
          GoRoute(path: 'access', builder: (_, _) => const AccessibilitySettingsScreen()),
          GoRoute(path: 'account', builder: (_, _) => const AccountSyncScreen()),
          GoRoute(path: 'data', builder: (_, _) => const DataScreen()),
          GoRoute(path: 'speech-test', builder: (_, _) => const SpeechTestScreen()),
        ]),
      ],
    ));

class _ChildShell extends StatelessWidget {
  const _ChildShell({required this.shell});

  final StatefulNavigationShell shell;

  static const _items = [
    (Icons.home_rounded, 'Beranda'),
    (Icons.record_voice_over_rounded, 'Latihan'),
    (Icons.menu_book_rounded, 'Cerita'),
    (Icons.workspace_premium_rounded, 'Koleksi'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: shell,
        bottomNavigationBar: ColoredBox(
          color: AppColors.surface,
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                for (var i = 0; i < _items.length; i++)
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: i == shell.currentIndex,
                      label: _items[i].$2,
                      excludeSemantics: true,
                      child: InkWell(
                        onTap: () => shell.goBranch(i, initialLocation: i == shell.currentIndex),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_items[i].$1, size: 28, color: i == shell.currentIndex ? AppColors.ink : AppColors.subInk),
                              const SizedBox(height: 2),
                              Text(
                                _items[i].$2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.caption.copyWith(
                                  color: i == shell.currentIndex ? AppColors.ink : AppColors.subInk,
                                  fontWeight: i == shell.currentIndex ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: i == shell.currentIndex ? 20 : 0,
                                height: 4,
                                decoration: BoxDecoration(color: AppColors.lantern, borderRadius: BorderRadius.circular(2)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
