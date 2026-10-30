import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';
import 'package:uni_sphere/core/widgets/loading.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_event.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_state.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final textPrimary = AppColors.primaryText;
  final textSecondary = AppColors.secondaryText;
  final surface = AppColors.surface;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMsg)),
              );
            }
            if(state is Authenticated){
              context.pop();
            }

          },

            builder: (context,state){
              final isLoading = state is AuthLoading;
              if(isLoading){
                return Loading();
              }
              return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
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
                      SizedBox(height: 5),
                      Center(
                        child: Text(
                          "Unisphere",
                          style: TextStyle(
                              fontSize: 20,
                              color: colors.primary.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Welcome back",
                        style: TextStyle(
                            color: textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        "Sign in to connect with your campus community.",
                        style: TextStyle(
                            color: textSecondary
                        ),
                      ),
                      SizedBox(height: 18),
                      Text(
                        "Email address",
                        style: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value
                              .trim()
                              .isEmpty) {
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
                        controller: emailController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: "you@example.com",
                          hintStyle: TextStyle(
                              color: textSecondary.withValues(alpha: 0.8)
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
                                color: colors.primary.withValues(alpha: .6),
                            ),
                            onPressed: () {
                              emailController.clear();
                              setState(() {});
                            },
                          )
                              : null,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: colors.primary
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: textPrimary.withValues(alpha: .3)
                              )
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: textPrimary.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Password",
                        style: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value
                              .trim()
                              .isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        onChanged: (_) =>
                            setState(() {}),
                        controller: passwordController,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: TextStyle(
                              color: textSecondary.withValues(alpha: 0.8)
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
                                color: colors.primary.withValues(alpha: .6),
                                obscureText ?
                                Icons.visibility_outlined : Icons
                                    .visibility_off_outlined),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          )
                              : null,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: colors.primary
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: textPrimary.withValues(alpha: .3)
                              )
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: textPrimary.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                  color: colors.secondary.withValues(
                                      alpha: 0.85),
                                  fontWeight: FontWeight.w600
                              ),
                            )),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                              )
                          ),
                          onPressed: isLoading ? null :  () {
                            if (_formKey.currentState!.validate()) {
                              final email = emailController.text.trim();
                              final password = passwordController.text;
                              context.read<AuthBloc>().add(SignInRequested(email: email, password: password));
                            }
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Divider(height: 1,
                              color: textSecondary.withValues(alpha: 0.3))),
                          SizedBox(width: 7,),
                          Text("OR"),
                          SizedBox(width: 7,),
                          Expanded(child: Divider(height: 1,
                              color: textSecondary.withValues(alpha: 0.3))),
                        ],
                      ),
                      SizedBox(height: 15),
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
                                      color: textPrimary.withValues(alpha: .3)
                                  )
                              )
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/google_logo.png',
                                width: 25,
                                height: 25,
                              ),
                              SizedBox(width: 3,),
                              const Text(
                                'Continue with Google',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New to Unisphere?",
                              style: TextStyle(
                                  color: textSecondary
                              ),
                            ),
                            TextButton(
                                onPressed: () => context.pushReplacement(
                                  "/register"
                                ),
                                child: Text(
                                  "Create an account",
                                  style: TextStyle(
                                      color: colors.secondary.withValues(
                                          alpha: 0.85),
                                      fontWeight: FontWeight.w600
                                  ),
                                )),
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
            );}
        ),
      ),
    );
  }
}
