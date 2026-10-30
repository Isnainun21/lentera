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
        GoRoute(path: '/setup', builder: (_, s) => SetupScreen(addingChild: s.uri.queryParameters['add'] == '1')),
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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: shell,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.lantern,
            labelTextStyle: WidgetStatePropertyAll(AppText.caption.copyWith(color: AppColors.ink)),
          ),
          child: NavigationBar(
            selectedIndex: shell.currentIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Beranda'),
              NavigationDestination(icon: Icon(Icons.record_voice_over_rounded), label: 'Latihan'),
              NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Cerita'),
              NavigationDestination(icon: Icon(Icons.emoji_objects_rounded), label: 'Koleksi'),
            ],
          ),
        ),
      );
}
