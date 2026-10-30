import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'content/content.dart';
import 'core/db/database.dart';
import 'core/sync/supabase_gateway.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (SupabaseConfig.configured) {
    await Supabase.initialize(url: SupabaseConfig.url, publishableKey: SupabaseConfig.anonKey);
  }
  final content = await Content.load(rootBundle);
  runApp(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(AppDatabase.open()),
      contentProvider.overrideWithValue(content),
    ],
    child: const LenteraApp(),
  ));
}
