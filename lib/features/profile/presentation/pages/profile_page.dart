import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/core/widgets/loading.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocConsumer<AuthBloc, AuthState>(
        listener: (context,state){
          if(state is AuthError){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMsg)
            ));
          }
        },
        builder: (context, state) {
          if(state is AuthLoading){
            return const Loading();
          }
          if (state is Authenticated) {
            if (state.user.displayName == null ||
                state.user.displayName!.isEmpty) {
              return const Loading();
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: colors.primary.withValues(alpha: 0.12),
                        backgroundImage: state.user.profileImageUrl != null
                            ? NetworkImage(state.user.profileImageUrl!)
                            : null,
                        child: state.user.profileImageUrl == null
                            ? Icon(
                          Icons.person_outline,
                          size: 44,
                          color: colors.primary,
                        )
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        state.user.displayName ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.user.email ?? 'No email available',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              const SignOutRequested(),
                            );
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Sign out'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (state is Unauthenticated) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: colors.primary.withValues(alpha: 0.12),
                        child: Icon(
                          Icons.person_outline,
                          size: 44,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Your campus profile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to manage your profile, track event RSVPs, '
                            'and connect with campus clubs.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: () => context.push('/sign-in'),
                          child: const Text('Sign in'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => context.push('/register'),
                          child: const Text('Create an account'),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        }
    );

  }
}
