import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/core/widgets/loading.dart';
import 'package:uni_sphere/core/widgets/unable_to_connect.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_state.dart';
import 'package:uni_sphere/features/profile/domain/entities/profile_user.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_event.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final textSecondary = AppColors.secondaryText;
  final textPrimary = AppColors.primaryText;
  Future<void> _showSignOutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Text(
            'Sign out?',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Sign out'),
            ),
          ],
        ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(
        const SignOutRequested(),
      );
    }
  }
  Widget _getPersonalInformationListTile({
    required IconData icon,
    required String title,
    required String subTitle
}){
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(vertical: -3),// Controls the compactness of the
      // tile by adjusting its minimum layout dimensions.
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12)
        ),
        child: Icon(
          icon,
          size: 15,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            color: textSecondary,
            fontSize: 12
        ),),
      subtitle: Text(
        subTitle,
        style: TextStyle(
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }
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
          if (state is Authenticated) {
            context.read<ProfileBloc>().add(
              GetProfileByUid(uid: state.user.uid),
            );
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
              body: BlocBuilder<ProfileBloc,ProfileState>(
                builder: (context,profileState){
                  if(profileState is ProfileLoading){
                    return Loading();
                  }
                  if(profileState is ProfileDeleted){
                    return Center(
                      child: Text('Profile doesn\'t exist')
                    );
                  }
                  if(profileState is ProfileError){
                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: unableToConnectWidget(
                        profileState.errorMsg,
                          ()=>context.read<ProfileBloc>().add(GetProfileByUid(uid: state.user.uid))
                      ),
                    );
                  }
                  if(profileState is ProfileLoaded){
                    final profileUser = profileState.profileUser;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 35),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                  Center(
                                    child: CircleAvatar(
                                      radius: 42,
                                      backgroundColor: colors.primary.withValues(alpha: 0.12),
                                      backgroundImage: profileUser.profileImageUrl != null
                                          ? NetworkImage(profileUser.profileImageUrl!)
                                          : null,
                                      child: profileUser.profileImageUrl == null
                                          ? Icon(
                                        Icons.person_outline,
                                        size: 44,
                                        color: colors.primary,
                                      )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Center(
                                    child: Text(
                                      profileUser.displayName,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Center(
                                    child: Text(
                                      '@${profileUser.username}',
                                      style: TextStyle(
                                        color: textSecondary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Center(
                                      child: FilledButton.icon(
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12)
                                          )
                                        ),
                                        onPressed: () {
                                          context.push<ProfileUser>(
                                              'edit-profile',
                                              extra: profileUser);
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text('Edit Profile'),
                                      ),
                                    ),
                                  const SizedBox(height: 25),
                                  const Text(
                                    'Personal information',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Divider(height: 1,color: textSecondary.withValues(alpha: 0.3)),
                                  _getPersonalInformationListTile(
                                      icon: Icons.person_outline,
                                      title: 'Display Name',
                                      subTitle: profileUser.displayName
                                  ),
                                  _getPersonalInformationListTile(
                                      icon: Icons.alternate_email_outlined,
                                      title: 'Username',
                                      subTitle: '@${profileUser.username}'
                                  ),
                                  _getPersonalInformationListTile(
                                      icon: Icons.mail_outlined,
                                      title: 'Email address',
                                      subTitle: state.user.email ?? 'No email available'
                                  ),
                            const SizedBox(height: 25),
                            const Text(
                              'Account',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Divider(height: 1,color: textSecondary.withValues(alpha: 0.3)),
                            const SizedBox(height: 5),
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap:() {
                                _showSignOutDialog(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout_outlined,
                                      color: colors.error,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                          'Sign Out',
                                          style: TextStyle(
                                            color: colors.error,
                                            fontWeight: FontWeight.w600
                                          ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
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
