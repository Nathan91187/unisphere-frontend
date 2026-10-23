import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';
import 'package:uni_sphere/features/events/domain/entities/event.dart';
import 'package:uni_sphere/features/home/utils/event_date_formatter.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;
  const EventDetailsPage({
    super.key,
    required this.event
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.primaryText;
    final textSecondary = AppColors.secondaryText;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
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
                          event.organizerName,
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
    );
  }
}
