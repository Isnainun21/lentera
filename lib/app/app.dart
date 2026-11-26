import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design/tokens.dart';
import 'providers.dart';
import 'router.dart';

class LenteraApp extends ConsumerStatefulWidget {
  const LenteraApp({super.key});

  @override
  ConsumerState<LenteraApp> createState() => _LenteraAppState();
}

class _LenteraAppState extends ConsumerState<LenteraApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _sync();
  }

  // Kegagalan jaringan dicatat di Area Pendamping dan tidak boleh mengganggu anak.
  void _sync() => ref.read(syncEngineProvider)?.syncNow().catchError((_) {});

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(activeChildProvider)?.settings;
    return MaterialApp.router(
      title: 'Lentera',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: switch (settings?.theme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final scale = settings?.fontScale ?? 1.0;
        return MediaQuery(
          data: media.copyWith(
            textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.6),
            disableAnimations: media.disableAnimations || (settings?.reduceMotion ?? false),
          ),
          child: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: _ScaledBy(MediaQuery.textScalerOf(context), scale),
              ),
              child: child!,
            ),
          ),
        );
      },
    );
  }
}

class _ScaledBy extends TextScaler {
  const _ScaledBy(this.base, this.factor);

  final TextScaler base;
  final double factor;

  @override
  double scale(double fontSize) => base.scale(fontSize) * factor;

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => base.scale(1) * factor;

  @override
  bool operator ==(Object other) => other is _ScaledBy && other.base == base && other.factor == factor;

  @override
  int get hashCode => Object.hash(base, factor);
}
