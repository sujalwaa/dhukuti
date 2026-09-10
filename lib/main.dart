import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/navigation/app_shell.dart';
import 'ui/screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Mock initialization of Supabase and DatabaseHelper
  
  runApp(
    const ProviderScope(
      child: DhukutiApp(),
    ),
  );
}

class DhukutiApp extends ConsumerWidget {
  const DhukutiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auth gate mock
    final isAuthenticated = false; // replace with ref.watch(authProvider)

    return MaterialApp(
      title: 'Dhukuti',
      theme: ThemeData(
        fontFamily: 'DM Sans',
        primaryColor: const Color(0xFF111111),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      ),
      home: isAuthenticated ? const AppShell() : const LoginScreen(),
    );
  }
}
