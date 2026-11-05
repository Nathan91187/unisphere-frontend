import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';
import 'package:uni_sphere/features/events/domain/entities/event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_state.dart';
import 'package:uni_sphere/features/home/utils/event_date_formatter.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;
  const EventDetailsPage({
    super.key,
    required this.event
  });

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  Future<bool?> showDeleteEventDialog(BuildContext context) {
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
            'Delete Event?',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this event? '
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
  late Event event;
  @override
  void initState(){
    super.initState();
    event = widget.event;
  }
  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.primaryText;
    final textSecondary = AppColors.secondaryText;
    final colors = Theme.of(context).colorScheme;
    return BlocListener<EventBloc,EventState>(
      listener: (context,state){
        if(state is EventOperationSuccess && state.event == null){
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Event Details"),
          actions: [
            if (event.organizerUid ==
                FirebaseAuth.instance.currentUser?.uid)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'edit') {
                    final updatedEvent = await context.push<Event>(
                      '/event-form',
                      extra: event,
                    );

                    if (updatedEvent != null && context.mounted) {
                      setState(() {
                        event = updatedEvent;
                      });
                    }
                  } else if (value == 'delete') {
                    final shouldDelete =
                    await showDeleteEventDialog(context);

                    if (shouldDelete == true && context.mounted) {
                      context.read<EventBloc>().add(
                        DeleteEvent(eventId: event.id),
                      );
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 10),
                        Text('Edit Event'),
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
                          'Delete Event',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
            body: SafeArea(
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
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                        decoration: BoxDecoration(
                            color: colors.secondary.withValues(alpha: 0.30),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(
                          event.category.name.toUpperCase(),
                          style: TextStyle(
                              color: colors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        event.name,
                        style: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: 18,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 10,),
                          Icon(
                            Icons.calendar_month_outlined,
                            color: colors.primary.withValues(alpha: 0.7),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "DATE",
                                style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 12
                                ),
                              ),
                              Text(
                                EventDateFormatter.eventDetailsDateFormatter(event.date),
                                style: TextStyle(
                                    color: textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 13,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 10,),
                          Icon(
                            CupertinoIcons.clock,
                            color: colors.primary.withValues(alpha: 0.7),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TIME",
                                style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 12
                                ),
                              ),
                              Text(
                                "${EventDateFormatter.startTimeFormatter(event.startTime)} - ${EventDateFormatter.startTimeFormatter(event.endTime)}",
                                style: TextStyle(
                                    color: textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 13,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 10,),
                          Icon(
                            Icons.location_on_outlined,
                            color: colors.primary.withValues(alpha: 0.7),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "LOCATION",
                                style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 12
                                ),
                              ),
                              Text(
                                event.location,
                                style: TextStyle(
                                    color: textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text(
                        "About this event",
                        style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 6,),
                      Text(
                        event.description,
                        style: TextStyle(
                            color: textSecondary
                        ),
                      ),
                      SizedBox(height: 14),
                      Divider(height: 1,color: textSecondary.withValues(alpha: 0.3)),
                      SizedBox(height: 14,),
                      Text(
                        "Organized by",
                        style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.secondary.withValues(alpha: 0.25),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: colors.primary,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.clubId != null
                                    ? event.clubName! : event.organizerName,
                                style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Event organizer",
                                style: TextStyle(
                                    color: textSecondary
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline,
                            color: colors.secondary,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "${event.attendeeCount} / ${event.capacity} attendees",
                              style: TextStyle(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          Text(
                            "${event.capacity - event.attendeeCount} spots left",
                            style: TextStyle(
                                color: textSecondary,
                                fontSize: 12
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                              )
                          ),
                          onPressed: () {},
                          child: const Text('Register for event'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
      }}
