import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';
import 'package:uni_sphere/core/widgets/loading.dart';
import 'package:uni_sphere/core/widgets/unable_to_connect.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_bloc.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_event.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_state.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_state.dart';
import 'package:uni_sphere/features/home/utils/event_date_formatter.dart';
import 'package:uni_sphere/features/events/utils/upcoming_events_selector.dart';

import '../../../clubs/presentation/pages/club_details_page.dart';
import '../../../events/presentation/bloc/event_event.dart';

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
          title: Text(
              'Unisphere',
              style: TextStyle(
                fontSize: 20,
                color: colors.primary,
                fontWeight: FontWeight.w500
              ),
          ),
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
                      "Upcoming Events",
                      style: TextStyle(
                          color: textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      context.go('/events');
                    },
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
              SizedBox(height: 10),
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
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Featured Clubs",
                      style: TextStyle(
                          color: textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      context.go('/clubs');
                    },
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
              SizedBox(height: 10),
              BlocBuilder<ClubBloc, ClubState>(
                  builder: (context,state){
                    if(state is ClubLoading){
                      return const Center(
                        child: Loading(),
                      );
                    }
                    if(state is ClubError){
                      return unableToConnectWidget(state.errorMsg, ()=> context.read<ClubBloc>().add(LoadClubs()));
                    }
                    if(state is ClubLoaded){
                      final clubs = state.clubs.take(3).toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                          itemCount: clubs.length,
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
                                     '/club-details',
                                     extra: clubs[index]
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
                                                  clubs[index].category.name.toUpperCase(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      overflow: TextOverflow.ellipsis,
                                                      color: colors.secondary,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Text(
                                                  clubs[index].name,
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
                                                  maxLines: 2,
                                                 overflow: TextOverflow.ellipsis,
                                                 clubs[index].description,
                                                  style: TextStyle(
                                                    color: textSecondary,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.people,
                                                      color: textSecondary,
                                                      size: 15,
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text(
                                                        "${clubs[index].memberCount} members",
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
                    return SizedBox.shrink();
                  })

            ],
          ),
        ),
      )
    );
  }
}
