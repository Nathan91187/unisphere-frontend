import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_sphere/core/widgets/loading.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_membership_bloc.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_membership_event.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_membership_state.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_event.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_state.dart';

import '../../../../core/theme/app_colors.dart';

class ClubMembersPage extends StatefulWidget {
  final int clubId;
  final String clubName;

  const ClubMembersPage({
    super.key,
    required this.clubId,
    required this.clubName,
  });

  @override
  State<ClubMembersPage> createState() => _ClubMembersPageState();
}

class _ClubMembersPageState extends State<ClubMembersPage> {
  @override
  void initState() {
    super.initState();
    context.read<ClubMembershipBloc>().add(
      GetClubMembers(clubId: widget.clubId),
    );
  }


  Future<void> _confirmRoleChange({
    required String targetUid,
    required String newRole,
    required String memberName,
  }) async {
    final isPromotion = newRole == 'ORGANIZER';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          title: Text(
            isPromotion ? 'Promote Member?' : 'Demote Organizer?',
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            isPromotion
                ? 'Are you sure you want to promote $memberName to organizer? '
                'They will gain organizer permissions.'
                : 'Are you sure you want to demote $memberName to member? '
                'They will lose organizer permissions.',
            style: const TextStyle(
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
              child: Text(isPromotion ? 'Promote' : 'Demote'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      context.read<ClubMembershipBloc>().add(
        UpdateMemberRole(
          clubId: widget.clubId,
          targetUid: targetUid,
          role: newRole,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Members',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            Text(
              widget.clubName,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<ClubMembershipBloc, ClubMembershipState>(
        listener: (context, state) {
          if (state is ClubMembersLoaded) {
            final memberships = state.members;
            final uids = memberships
                .map((membership) => membership.userId)
                .toList();

            context.read<ProfileBloc>().add(
              GetAllProfilesByUid(uids: uids),
            );
          }

          if (state is ClubMembershipOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );

            // Refresh the member list after a successful role update.
            context.read<ClubMembershipBloc>().add(
              GetClubMembers(clubId: widget.clubId),
            );
          }

          if (state is ClubMembershipError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMsg)),
            );
          }
        },
        builder: (context, state) {
          if (state is ClubMembershipLoading) {
            return Loading();
          }

          if (state is ClubMembersLoaded && state.members.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ClubMembershipBloc>().add(
                  GetClubMembers(clubId: widget.clubId),
                );
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 300,
                    child: Center(
                      child: Text('No members yet'),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ClubMembersLoaded) {
            final memberships = state.members;

            // Find the current user's membership and determine their role.
            final currentUid = FirebaseAuth.instance.currentUser?.uid;


            final currentMembership = memberships
                .where((membership) => membership.userId == currentUid)
                .firstOrNull;

            final isCurrentUserOrganizer =
                currentMembership?.role.name == 'organizer';

            return BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, profileState) {
                if (profileState is ProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Unable to load members'),
                    ),
                  );
                }
              },
              builder: (context, profileState) {
                if (profileState is ProfileLoading) {
                  return Loading();
                }

                if (profileState is ProfileError) {
                  return const Center(
                    child: Text('Unable to load member profiles'),
                  );
                }

                if (profileState is ProfilesLoaded) {
                  final profiles = profileState.profiles;

                  final profileByUid = {
                    for (final profile in profiles)
                      profile.uid: profile,
                  };

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ClubMembershipBloc>().add(
                        GetClubMembers(clubId: widget.clubId),
                      );
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.secondaryText.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${memberships.length} members',
                                  style: TextStyle(
                                    color: AppColors.secondaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  color: AppColors.secondaryText.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                ...memberships.asMap().entries.map((entry) {
                                  final membership = entry.value;
                                  final profile =
                                  profileByUid[membership.userId];

                                  if (profile == null) {
                                    return const ListTile(
                                      title: Text('Profile unavailable'),
                                      subtitle: Text(
                                        'Unable to retrieve member profile',
                                      ),
                                    );
                                  }

                                  final index = entry.key;
                                  final isCurrentUser =
                                      membership.userId == currentUid;

                                  final isOrganizer =
                                      membership.role.name == 'organizer';

                                  final newRole = isOrganizer
                                      ? 'MEMBER'
                                      : 'ORGANIZER';

                                  return Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          profile.displayName,
                                          style: TextStyle(
                                            color: AppColors.primaryText,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '@${profile.username}',
                                          style: TextStyle(
                                            color: AppColors.secondaryText,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                          AppColors.selectedSurface,
                                          backgroundImage:
                                          profile.profileImageUrl != null
                                              ? NetworkImage(
                                            profile.profileImageUrl!,
                                          )
                                              : null,
                                          child:
                                          profile.profileImageUrl == null
                                              ? const Icon(
                                            Icons.person,
                                            size: 25,
                                          )
                                              : null,
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isOrganizer
                                                    ? AppColors.primary
                                                    : AppColors.selectedSurface,
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                membership.role.name
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: isOrganizer
                                                      ? AppColors.surface
                                                      : AppColors.secondary,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),

                                            // Only organizers can manage
                                            // other members' roles.
                                            if (isCurrentUserOrganizer &&
                                                !isCurrentUser)
                                              PopupMenuButton<String>(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: AppColors.secondaryText,
                                                ),
                                                onSelected: (role) {
                                                  _confirmRoleChange(
                                                    targetUid:
                                                    membership.userId,
                                                    newRole: role,
                                                    memberName: profile.displayName,
                                                  );
                                                },
                                                itemBuilder: (context) => [
                                                  PopupMenuItem<String>(
                                                    value: newRole,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          isOrganizer
                                                              ? Icons
                                                              .person_outline
                                                              : Icons
                                                              .admin_panel_settings_outlined,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          isOrganizer
                                                              ? 'Demote to member'
                                                              : 'Promote to organizer',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (index != memberships.length - 1)
                                        Divider(
                                          color: AppColors.secondaryText
                                              .withValues(alpha: 0.3),
                                        ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
