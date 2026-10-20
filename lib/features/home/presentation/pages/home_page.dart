import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';
import 'package:uni_sphere/core/widgets/loading.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_state.dart';
import 'package:uni_sphere/features/home/utils/event_category_icon.dart';
import 'package:uni_sphere/features/home/utils/event_date_formatter.dart';
import 'package:uni_sphere/features/home/utils/upcoming_events_selector.dart';

class HomePage extends StatelessWidget {
  final textPrimary = AppColors.primaryText;
  final textSecondary = AppColors.secondaryText;


  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          leading: Center(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.school_outlined,
                color: AppColors.background,
              ),
            ),
          ),
          titleSpacing: 0,
          title: const Text('UniSphere'),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Discover",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 20),
              Text(
                "What's happening around campus",
                style: TextStyle(
                  color: textSecondary,
                ),
              ),
              SizedBox(height: 23),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Upcoming events",
                      style: TextStyle(
                          color: textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: colors.secondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
                BlocBuilder<EventBloc, EventState>(
                  builder: (context,state){
                    if(state is EventLoading){
                      const Center(
                        child: Loading(),
                      );
                    }
                    if(state is EventError){
                      return Center(
                        child: Text(
                          state.errorMsg
                        ),
                      );
                    }
                    if(state is EventLoaded){
                      final upcomingEvents = UpcomingEventsSelector(events: state.events).getUpcomingEvents();
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
                                onTap: (){},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: colors.secondary.withValues(alpha: 0.30),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Icon(
                                          EventCategoryIcon.getIcon(upcomingEvents[index].category),
                                          color: colors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 8,),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
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
                                                    Icons.location_on_outlined,
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
      )
    );
  }
}
