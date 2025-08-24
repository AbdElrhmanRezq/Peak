import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/auth_providers.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/presentation/widgets/custom_text_form_field.dart';
import 'package:repx/presentation/widgets/custom_wide_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static const String id = 'signup_screen';
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    final auth = ref.read(authRepositoryProvider);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final user = await auth.signup(email, password, confirmPassword);
      ref.read(currentUserProvider.notifier).state = user;
      ref.invalidate(userDataProvider);
      Navigator.of(context).pushReplacementNamed('on_board_screen');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup failed: ${e is AuthException ? e.message : e}'),
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
                CustomTextFormField(
                  labelText: 'Email',
                  controller: emailController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your email'
                      : null,
                ),
                CustomTextFormField(
                  labelText: 'Password',
                  controller: passwordController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your password'
                      : null,
                ),
                CustomTextFormField(
                  labelText: 'Confirm Password',
                  controller: confirmPasswordController,
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
                          text: "Sign Up",
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              signup();
                            }
                          },
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      child: Text("Log In"),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed('login_screen');
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
