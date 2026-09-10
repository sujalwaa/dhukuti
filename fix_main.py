import re

with open('lib/main.dart', 'r') as f:
    content = f.read()

repl = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/database_provider.dart';
import 'core/theme/app_theme.dart';
import 'data/local/database_helper.dart';
import 'data/seed/sample_data.dart';
import 'ui/navigation/app_shell.dart';
import 'ui/screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database;
  
  runApp(
    ProviderScope(
      overrides: [
        databaseHelperProvider.overrideWithValue(dbHelper),
      ],
      child: const DhukutiApp(),
    ),
  );
}

class DhukutiApp extends ConsumerWidget {
  const DhukutiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    // Seed sample data if logged in (for demo purposes)
    if (authState is AuthAuthenticated) {
      _checkAndSeedData(context, ref, authState.userId);
    }

    return MaterialApp(
      title: 'Dhukuti',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      home: authState is AuthAuthenticated ? const AppShell() : const LoginScreen(),
    );
  }
  
  Future<void> _checkAndSeedData(BuildContext context, WidgetRef ref, String userId) async {
    final dbHelper = ref.read(databaseHelperProvider);
    final db = await dbHelper.database;
    final accounts = await db.query('accounts', limit: 1);
    
    if (accounts.isEmpty) {
      final accountRepo = ref.read(accountRepositoryProvider);
      final categoryRepo = ref.read(categoryRepositoryProvider);
      final txRepo = ref.read(transactionRepositoryProvider);
      final incomeRepo = ref.read(incomeRepositoryProvider);
      final goalRepo = ref.read(goalRepositoryProvider);

      await SampleData.seedAll(
        userId: userId,
        insertAccount: (a) => accountRepo.create(a),
        insertCategory: (c) => categoryRepo.create(c),
        insertTransaction: (t) => txRepo.create(t),
        insertIncome: (i) => incomeRepo.create(i),
        insertGoal: (g) => goalRepo.create(g),
        insertContribution: (c) async {}, 
      );
    }
  }
}
"""

with open('lib/main.dart', 'w') as f:
    f.write(repl)
