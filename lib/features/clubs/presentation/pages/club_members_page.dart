import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    required this.clubName
  });

  @override
  State<ClubMembersPage> createState() => _ClubMembersPageState();
}

class _ClubMembersPageState extends State<ClubMembersPage> {
  @override
  void initState(){
    super.initState();
   context.read<ClubMembershipBloc>().add(GetClubMembers(clubId: widget.clubId));
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
        body: BlocConsumer<ClubMembershipBloc,ClubMembershipState>(
            listener: (context,state){
              if(state is ClubMembersLoaded){
                final memberships = state.members;
                final uids =  memberships.map((membership)=>membership.userId).toList();
                context.read<ProfileBloc>().add(GetAllProfilesByUid(uids: uids));
              }
              if(state is ClubMembershipError){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMsg))
                );
              }
            },
            builder: (context,state){
              if(state is ClubMembershipLoading){
                return Loading();
              }
              if (state is ClubMembersLoaded && state.members.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ClubMembershipBloc>().add(
                        GetClubMembers(clubId: widget.clubId));
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
              if(state is ClubMembersLoaded){
                final memberships = state.members;
                return BlocConsumer<ProfileBloc,ProfileState>(
                  listener: (context,profileState){
                    if(profileState is ProfileError){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Unable to load members'))
                      );
                    }
                  },
                  builder: (context,profileState){
                    if(profileState is ProfileLoading){
                      return Loading();
                    }
                    if (profileState is ProfileError) {
                      return Center(
                        child: Text('Unable to load member profiles'),
                      );
                    }
                    if(profileState is ProfilesLoaded){
                      final profiles = profileState.profiles;
                      final profileByUid = {
                        for (final profile in profiles)
                          profile.uid: profile,
                      };
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ClubMembershipBloc>().add(
                              GetClubMembers(clubId: widget.clubId));
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0,),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 14),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppColors.secondaryText
                                            .withValues(alpha: 0.3),
                                        width: 1
                                    )
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
                                    SizedBox(height: 8,),
                                    Divider(
                                      color: AppColors.secondaryText.withValues(
                                          alpha: 0.3),
                                    ),
                                    ...memberships.asMap().entries.map((entry) {
                                      final membership = entry.value;
                                      final profile = profileByUid[membership.userId];
                                      if (profile == null) {
                                        return ListTile(
                                          title: const Text('Profile unavailable'),
                                          subtitle: const Text('Unable to retrieve member profile'),
                                        );
                                      }
                                      final index = entry.key;
                                      return Column(
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              profile.displayName,
                                              style: TextStyle(
                                                  color: AppColors.primaryText,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                            subtitle: Text(
                                              '@${profile.username}',
                                              style: TextStyle(
                                                  color: AppColors.secondaryText
                                              ),
                                            ),
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: AppColors
                                                  .selectedSurface,
                                              backgroundImage: profile
                                                  .profileImageUrl != null
                                                  ? NetworkImage(
                                                  profile.profileImageUrl!)
                                                  : null,
                                              child: profile.profileImageUrl ==
                                                  null
                                                  ? const Icon(
                                                  Icons.person, size: 25)
                                                  : null,
                                            ),
                                            trailing: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: membership.role
                                                      .name == 'organizer'
                                                      ? AppColors.primary
                                                      : AppColors
                                                      .selectedSurface,
                                                  borderRadius: BorderRadius
                                                      .circular(20),
                                                ),
                                                child: Text(
                                                  membership.role.name.toUpperCase(),
                                                  style: TextStyle(
                                                    color: membership.role
                                                        .name == 'organizer'
                                                        ? AppColors.surface
                                                        : AppColors.secondary,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )),
                                          ),
                                          if(index != memberships.length - 1 )
                                            Divider(
                                                color: AppColors.secondaryText
                                                    .withValues(alpha: 0.3)),
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
                    return SizedBox.shrink();
                  },
                );
              }
              return SizedBox.shrink();
              }
            ),
    );
  }
}
