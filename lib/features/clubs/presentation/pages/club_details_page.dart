import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_state.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club_member_role.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_event.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_membership_bloc.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_membership_event.dart' as club_membership_event;
import 'package:uni_sphere/features/clubs/presentation/bloc/club_membership_state.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/unable_to_connect.dart';
import '../../../events/domain/entities/event.dart';
import '../../../events/presentation/bloc/event_state.dart';
import '../../../events/utils/upcoming_events_selector.dart';
import '../../../home/utils/event_date_formatter.dart';
import '../bloc/club_bloc.dart';
import '../bloc/club_state.dart';
class ClubDetailsPage extends StatefulWidget {
  final Club club;
  const ClubDetailsPage({
    super.key,
    required this.club
  });

  @override
  State<ClubDetailsPage> createState() => _ClubDetailsPageState();
}

class _ClubDetailsPageState extends State<ClubDetailsPage> {
  late Club club;
  @override
  void initState(){
    super.initState();
    club = widget.club;
    context.read<ClubMembershipBloc>().add(club_membership_event.GetMyMembership(clubId: club.id));
  }
  Future<bool?> showLeaveClubDialog(
      BuildContext context, {
        required String body,
      }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Leave Club?',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
         body,
          style: TextStyle(
            color: AppColors.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Leave Club'),
          ),
        ],
      ),
    );
  }
  Future<bool?> showDeleteClubDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Text(
            'Delete Club?',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this club? '
                'This action cannot be undone.',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
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
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.primaryText;
    final textSecondary = AppColors.secondaryText;
    final colors = Theme.of(context).colorScheme;
    return BlocListener<ClubBloc,ClubState>(
      listener: (context,state){
        if(state is ClubOperationSuccess && state.club == null){
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text("Club Details"),
          actions: [
            BlocBuilder<ClubMembershipBloc, ClubMembershipState>(
              builder: (context,state) {
                if(state is ClubMembershipLoaded && state.membership.role == ClubMemberRole.organizer &&state.membership.clubId == club.id ){
                  return PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async{
                      if (value == 'edit') {
                        final updatedClub = await context.push<Club>(
                            '/club-form',
                            extra: club);
                        if(updatedClub != null && context.mounted){
                          setState(() {
                            club = updatedClub;
                          });
                        }
                      } else if (value == 'delete') {
                        final shouldDelete = await showDeleteClubDialog(context);
                        if (shouldDelete == true && context.mounted) {
                          context.read<ClubBloc>().add(DeleteClub(clubId: club.id));
                        }
                      }
                      else if(value == 'create-event'){
                        final createdEvent = await context.push<Event>(
                            '/event-form', extra: {'clubId' : club.id},);
                        if(createdEvent != null && context.mounted){
                          context.read<EventBloc>().add(const LoadEvents());
                          context.push('/event-details', extra: {
                            'event' : createdEvent
                          });
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'create-event',
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 10),
                            Text(
                              'Create Event',
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 10),
                            Text('Edit Club'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 10),
                            Text(
                              'Delete Club',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocConsumer<ClubMembershipBloc,ClubMembershipState>(
          listener: (context,state){
            if(state is ClubMembershipOperationSuccess){
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message))
              );
            }
          },
          builder: (context,state){
            final membership =
            state is ClubMembershipLoaded &&
                state.membership.clubId == club.id
                ? state.membership
                : null;

            final isOrganizer =
                membership?.role == ClubMemberRole.organizer;

            final isMember =
                membership?.role == ClubMemberRole.member;
            final isSoleOrganizer =
                state is ClubMembershipLoaded &&
                state.membership.clubId == club.id &&
                state.isOnlyOrganizer == true;
            return SafeArea(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          child: Image.asset(
                              fit: BoxFit.cover,
                              width: double.infinity,
                              "assets/images/ronaldo_crying.png"
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            decoration: BoxDecoration(
                                color: colors.secondary.withValues(alpha: 0.30),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              club.category.name.toUpperCase(),
                              style: TextStyle(
                                  color: colors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          if (isOrganizer)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.selectedSurface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.shield_outlined,
                                        size: 15,
                                        color: AppColors.secondary,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'ORGANIZER',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        club.name,
                        style: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: colors.secondary,
                            size: 20,
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                "${club.memberCount.toString()} members",
                                style: TextStyle(
                                    color: textSecondary,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6,),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                              ),
                            backgroundColor: isMember || isOrganizer ||isSoleOrganizer
                                ? colors.error.withValues(alpha: 0.8)
                                : AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            final authState = context.read<AuthBloc>().state;
                            if(authState is !Authenticated && context.mounted){
                              await context.push('/sign-in');
                              return;
                            }
                            if (isMember || isOrganizer) {
                              if (isSoleOrganizer) {
                                final confirmed = await showLeaveClubDialog(
                                  context,
                                  body: 'Leaving this club will result in the deletion '
                                      'of the entire club and all its associated data. '
                                      'Are you sure you want to proceed?',
                                );

                                if (confirmed == true && context.mounted) {
                                  context.read<ClubBloc>().add(
                                    DeleteClub(clubId: club.id),
                                  );
                                }
                              } else {
                                final confirmed = await showLeaveClubDialog(
                                  context,
                                  body: 'Are you sure you want to leave this club?',
                                );

                                if (confirmed == true && context.mounted) {
                                  context.read<ClubMembershipBloc>().add(
                                    club_membership_event.LeaveClub(clubId: club.id),
                                  );
                                }
                              }
                            } else {
                              context.read<ClubMembershipBloc>().add(
                                club_membership_event.JoinClub(clubId: club.id),
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isMember || isOrganizer || isSoleOrganizer? Icons.logout : Icons.group_add,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(isMember || isOrganizer ||isSoleOrganizer? 'Leave Club' : 'Join Club'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "About",
                        style: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 15

                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        club.description,
                        style: TextStyle(
                            color: textSecondary
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(height: 1,color: textSecondary.withValues(alpha: 0.3)),
                      SizedBox(height: 15,),
                      Text(
                        "Upcoming club events",
                        style: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: 10,),
                      BlocBuilder<EventBloc, EventState>(
                        builder: (context,state){
                          if(state is EventLoading){
                            return const Center(
                              child: Loading(),
                            );
                          }
                          if(state is EventError){
                            return unableToConnectWidget(state.errorMsg, ()=>context.read<EventBloc>().add(LoadEvents()));
                          }
                          if(state is EventLoaded){
                            final upcomingEvents = UpcomingEventsSelector(events: state.events).getUpcomingEventsByClub(widget.club.id);
                            if(upcomingEvents.isEmpty){
                              return Center(
                                child: Text(
                                    "No upcoming events"
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: upcomingEvents.length,
                              itemBuilder: (context,index)=>
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: textSecondary.withValues(alpha: 0.20),
                                          width: 0.5
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    color: colors.surface,
                                    child: InkWell(
                                      onTap: (){
                                        context.push(
                                          '/event-details',
                                          extra: upcomingEvents[index],
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 70,
                                              height: 110,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.asset(
                                                  "assets/images/ronaldo_crying.png",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8,),
                                            Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      upcomingEvents[index].category.name.toUpperCase(),
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          overflow: TextOverflow.ellipsis,
                                                          color: colors.secondary,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    Text(
                                                      upcomingEvents[index].name,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          overflow: TextOverflow.ellipsis,
                                                          color: textPrimary,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      "${EventDateFormatter.dateFormatter(upcomingEvents[index].date)} · ${EventDateFormatter.startTimeFormatter(upcomingEvents[index].startTime)}",
                                                      style: TextStyle(
                                                        color: textSecondary,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          color: textSecondary,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                            upcomingEvents[index].location,
                                                            style: TextStyle(
                                                              color: textSecondary,
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                            Icon(
                                              Icons.chevron_right,
                                              color: textSecondary,
                                              size: 22,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
