import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'dhukuti',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, fontFamily: 'DM Sans'),
                textAlign: TextAlign.center,
              ),
              const Text(
                'धुकुटि · know your money',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? PhosphorIcons.eye() : PhosphorIcons.eyeClosed()),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                ),
                onPressed: () {},
                child: const Text('Log in'),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or continue with'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                ),
                icon: Icon(PhosphorIcons.appleLogo()),
                label: const Text('Sign in with Apple'),
                onPressed: () => ref.read(authProvider.notifier).signInWithApple(),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(56),
                ),
                icon: Icon(PhosphorIcons.googleLogo()),
                label: const Text('Sign in with Google'),
                onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
