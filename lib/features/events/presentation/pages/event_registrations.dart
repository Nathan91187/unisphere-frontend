import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/core/widgets/loading.dart';
import 'package:uni_sphere/features/events/presentation/bloc/rsvp_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/rsvp_event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/rsvp_state.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_event.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_state.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/unable_to_connect.dart';
class EventRegistrations extends StatefulWidget {

  final int eventId;
  const EventRegistrations({
    super.key,
    required this.eventId
  });

  @override
  State<EventRegistrations> createState() => _EventRegistrationsState();
}

class _EventRegistrationsState extends State<EventRegistrations> {
  @override
  void initState() {
    super.initState();

    context.read<RsvpBloc>().add(
      LoadRsvps(eventId: widget.eventId),
    );
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
              'Registrations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            Text(
              'People registered for this event',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<RsvpBloc,RsvpState>(
          builder: (context,state){
            if(state is RsvpLoading){
              return const Loading();
            }
            if (state is RsvpError) {
              return unableToConnectWidget(
                state.errorMsg,
                    () => context.read<RsvpBloc>().add(LoadRsvps(eventId: widget.eventId)),
              );
            }
            if(state is RsvpLoaded){
              final rsvps = state.rsvps;
              if(rsvps.isEmpty){
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<RsvpBloc>().add(LoadRsvps(eventId: widget.eventId));
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Text('No one has registered for this event'),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final uids = rsvps.map((rsvp)=>rsvp.userUid).toList();
              context.read<ProfileBloc>().add(
                GetAllProfilesByUid(uids: uids)
              );
             return BlocConsumer<ProfileBloc,ProfileState>(
               listener: (context,profileState){
                 if(profileState is ProfileError){
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Unable to load attendees'))
                   );
                 }
               },
               builder: (context,profileState){
                 if(profileState is ProfileLoading){
                   return Loading();
                 }
                 if(profileState is ProfilesLoaded){
                   final profiles = profileState.profiles;
                   return RefreshIndicator(
                     onRefresh: () async{
                       context.read<RsvpBloc>().add(LoadRsvps(eventId: widget.eventId));
                     },
                     child: SingleChildScrollView(
                       physics: const AlwaysScrollableScrollPhysics(),
                       child: SafeArea(
                         child: Padding(
                           padding: const EdgeInsets.all( 8.0,),
                           child: Container(
                             padding: EdgeInsets.symmetric(horizontal: 8,vertical: 14),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(12),
                               border: Border.all(
                                 color: AppColors.secondaryText.withValues(alpha: 0.3),
                                 width: 1
                               )
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   'Attendees',
                                   style: TextStyle(
                                     color: AppColors.primaryText,
                                     fontWeight: FontWeight.w600
                                   ),
                                 ),
                                 SizedBox(height: 8,),
                                 Divider(
                                     color: AppColors.secondaryText.withValues(alpha: 0.3),
                                 ),
                                 ...profiles.asMap().entries.map((entry){
                                   final profile = entry.value;
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
                                           backgroundColor: AppColors.selectedSurface,
                                           backgroundImage: profile.profileImageUrl != null
                                               ? NetworkImage(profile.profileImageUrl!)
                                               : null,
                                           child: profile.profileImageUrl == null
                                               ? const Icon(Icons.person, size: 25)
                                               : null,
                                         ),
                                         trailing: Container(
                                             padding: const EdgeInsets.symmetric(
                                               horizontal: 10,
                                               vertical: 5,
                                             ),
                                             decoration: BoxDecoration(
                                               color: rsvps[index].status.name == 'going'
                                                   ? AppColors.primary
                                                   : AppColors.selectedSurface,
                                               borderRadius: BorderRadius.circular(20),
                                             ),
                                             child: Text(
                                                 rsvps[index].status.name == "not_going" ? "NOT GOING" : rsvps[index].status.name.toUpperCase(),
                                               style: TextStyle(
                                                 color: rsvps[index].status.name == 'going'
                                                     ? AppColors.surface
                                                     : AppColors.secondary,
                                                 fontSize: 11,
                                                 fontWeight: FontWeight.w600,
                                               ),
                                             )),
                                       ),
                                       if(index != profiles.length -1 )
                                         Divider(color: AppColors.secondaryText.withValues(alpha: 0.3)),
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
          }),
    );
  }
}
