
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';
import 'package:uni_sphere/core/widgets/loading.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_event.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_state.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_event.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final textPrimary = AppColors.primaryText;
  final textSecondary = AppColors.secondaryText;
  final surface = AppColors.surface;

  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  void dispose() {
    displayNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMsg)),
                  );
                }

                if (state is Authenticated) {
                  context.read<ProfileBloc>().add(
                    CreateProfile(
                      displayName: displayNameController.text.trim(),
                      profileImageUrl: state.user.profileImageUrl,
                    ),
                  );
                }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileLoaded) {
                  context.pop();
                }

                if (state is ProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMsg)),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
                  final isLoading =
                      authState is AuthLoading ||
                          profileState is ProfileLoading;

                  if (isLoading) {
                    return Loading();
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 14,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.school_outlined,
                                  color: surface,
                                  size: 40,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Center(
                              child: Text(
                                "Unisphere",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: colors.primary.withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Create your account",
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Join your campus community on UniSphere.",
                              style: TextStyle(color: textSecondary),
                            ),
                            const SizedBox(height: 18),

                            // Display name field
                            Text(
                              "Display name",
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: displayNameController,
                              textCapitalization: TextCapitalization.words,
                              maxLength: 100,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your display name';
                                }
                                if (value.trim().length > 100) {
                                  return 'Display name must not exceed 100 characters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter your name",
                                hintStyle: TextStyle(
                                  color: textSecondary.withValues(alpha: 0.8),
                                ),
                                counterText: '',
                                fillColor: colors.surface,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: colors.primary.withValues(alpha: .6),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: colors.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: textPrimary.withValues(alpha: .3),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: textPrimary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            Text(
                              "Email address",
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: emailController,
                              onChanged: (_) => setState(() {}),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email address';
                                }

                                final emailRegex = RegExp(
                                  r'^[\w.-]+@([\w-]+\.)+[\w-]{2,}$',
                                );

                                if (!emailRegex.hasMatch(value.trim())) {
                                  return 'Please enter a valid email address';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "you@example.com",
                                hintStyle: TextStyle(
                                  color: textSecondary.withValues(alpha: 0.8),
                                ),
                                fillColor: colors.surface,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.mail_outlined,
                                  color: colors.primary.withValues(alpha: .6),
                                ),
                                suffixIcon: emailController.text.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: colors.primary.withValues(
                                      alpha: .6,
                                    ),
                                  ),
                                  onPressed: () {
                                    emailController.clear();
                                    setState(() {});
                                  },
                                )
                                    : null,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: colors.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: textPrimary.withValues(alpha: .3),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: textPrimary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Password",
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: passwordController,
                              onChanged: (_) => setState(() {}),
                              obscureText: obscureText,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a password';
                                }

                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                hintStyle: TextStyle(
                                  color: textSecondary.withValues(alpha: 0.8),
                                ),
                                fillColor: colors.surface,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: colors.primary.withValues(alpha: .6),
                                ),
                                suffixIcon: passwordController.text.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(
                                    obscureText
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: colors.primary.withValues(
                                      alpha: .6,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                )
                                    : null,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: colors.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: textPrimary.withValues(alpha: .3),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: textPrimary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Confirm password",
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: obscureText,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }

                                if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Confirm your password",
                                hintStyle: TextStyle(
                                  color: textSecondary.withValues(alpha: 0.8),
                                ),
                                fillColor: colors.surface,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: colors.primary.withValues(alpha: .6),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: colors.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: textPrimary.withValues(alpha: .3),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: textPrimary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () {
                                  if (_formKey.currentState!.validate()) {
                                    final displayName =
                                    displayNameController.text.trim();
                                    final email =
                                    emailController.text.trim();
                                    final password =
                                        passwordController.text;

                                    context.read<AuthBloc>().add(
                                      RegisterRequested(
                                        displayName: displayName,
                                        email: email,
                                        password: password,
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Create account',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    height: 1,
                                    color: textSecondary.withValues(alpha: 0.3),
                                  ),
                                ),
                                const SizedBox(width: 7),
                                const Text("OR"),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Divider(
                                    height: 1,
                                    color: textSecondary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: surface,
                                  foregroundColor: textPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: textPrimary.withValues(alpha: .3),
                                    ),
                                  ),
                                ),
                                onPressed: isLoading ? null : () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/google_logo.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(width: 3),
                                    const Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(color: textSecondary),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        context.pushReplacement("/sign-in"),
                                    child: Text(
                                      "Sign in",
                                      style: TextStyle(
                                        color: colors.secondary.withValues(
                                          alpha: 0.85,
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => context.pop(),
                                icon: const Icon(Icons.explore_outlined),
                                label: const Text('Continue as guest'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
