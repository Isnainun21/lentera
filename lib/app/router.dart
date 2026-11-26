import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/design/components.dart';
import '../core/design/responsive.dart';
import '../core/design/tokens.dart';
import '../features/games/build_word_screen.dart';
import '../features/games/listen_pick_screen.dart';
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
import '../features/rewards/word_book_screen.dart';
import '../features/stories/stories_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
        GoRoute(path: '/setup', builder: (_, s) => SetupScreen(addingChild: s.uri.queryParameters['add'] == '1', name: s.uri.queryParameters['name'] ?? '')),
        GoRoute(path: '/profiles', builder: (_, _) => const ProfilePickerScreen()),
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => ChildShell(shell: shell),
          branches: [
            StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/practice', builder: (_, _) => const PracticeHubScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/stories', builder: (_, _) => const StoriesScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/collection', builder: (_, _) => const CollectionScreen())]),
          ],
        ),
        GoRoute(path: '/session', builder: (_, _) => const SessionScreen()),
        GoRoute(path: '/letters', builder: (_, _) => const LettersScreen()),
        GoRoute(path: '/build', builder: (_, _) => const BuildWordScreen()),
        GoRoute(path: '/listen', builder: (_, _) => const ListenPickScreen()),
        GoRoute(path: '/words', builder: (_, _) => const WordBookScreen()),
        GoRoute(path: '/story/:id', builder: (_, s) => StoryReaderScreen(storyId: s.pathParameters['id']!)),
        GoRoute(path: '/guardian-pin', builder: (_, _) => const GuardianPinScreen()),
        GoRoute(path: '/guardian', builder: (_, _) => const GuardianSummaryScreen(), routes: [
          GoRoute(path: 'history', builder: (_, _) => const SessionHistoryScreen()),
          GoRoute(path: 'words', builder: (_, _) => const WordStatsScreen()),
          GoRoute(path: 'learning', builder: (_, _) => const LearningSettingsScreen()),
          GoRoute(path: 'access', builder: (_, _) => const AccessibilitySettingsScreen()),
          GoRoute(path: 'account', builder: (_, _) => const AccountSyncScreen()),
          GoRoute(path: 'data', builder: (_, _) => const DataScreen()),
          GoRoute(path: 'speech-test', builder: (_, _) => const SpeechTestScreen()),
        ]),
      ],
    ));

/// Navigasi Mode Anak: bar bawah di ponsel, rail di samping pada lipat dan tablet.
class ChildShell extends StatelessWidget {
  const ChildShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Beranda'),
    (Icons.record_voice_over_outlined, Icons.record_voice_over_rounded, 'Latihan'),
    (Icons.menu_book_outlined, Icons.menu_book_rounded, 'Cerita'),
    (Icons.auto_awesome_mosaic_outlined, Icons.auto_awesome_mosaic_rounded, 'Koleksi'),
  ];

  void _go(int i) => shell.goBranch(i, initialLocation: i == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    if (WindowSize.of(context).isCompact) {
      return Scaffold(
        body: shell,
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: p.line))),
          child: NavigationBar(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: _go,
            destinations: [
              for (final (icon, selected, label) in _items)
                NavigationDestination(icon: Icon(icon), selectedIcon: Icon(selected), label: label),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            right: false,
            child: NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _go,
              groupAlignment: -0.85,
              minWidth: 96,
              leading: MediaQuery.sizeOf(context).height < 480 ? null : const Padding(padding: EdgeInsets.only(top: 8, bottom: 20), child: LogoMark(size: 48)),
              destinations: [
                for (final (icon, selected, label) in _items)
                  NavigationRailDestination(
                    icon: Icon(icon),
                    selectedIcon: Icon(selected),
                    label: Text(label),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                  ),
              ],
            ),
          ),
          VerticalDivider(width: 1, color: p.line),
          Expanded(child: shell),
        ],
      ),
    );
  }
}
