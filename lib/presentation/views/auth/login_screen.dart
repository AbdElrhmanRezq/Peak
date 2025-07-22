import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/models/user_model.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/presentation/widgets/custom_circular_button.dart';
import 'package:repx/presentation/widgets/custom_text_field.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class LoginScreen extends ConsumerStatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final auth = ref.read(authRepositoryProvider);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final user = await auth.login(email, password);
      Navigator.of(context).pushReplacementNamed('nav_menu');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e is AuthException ? e.message : e}'),
        ),
      );
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginLoadingProvider);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Repx", style: Theme.of(context).textTheme.headlineLarge),
                CustomTextField(
                  labelText: 'Email',
                  controller: emailController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your email'
                      : null,
                ),
                CustomTextField(
                  labelText: 'Password',
                  controller: passwordController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your password'
                      : null,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.03,
                    horizontal: 16.0,
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        )
                      : CustomWideButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          text: "Login",
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              login();
                            }
                          },
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      child: Text("Sign Up"),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed('signup_screen');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
