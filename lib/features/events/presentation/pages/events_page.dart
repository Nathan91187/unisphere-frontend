import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';
import 'package:uni_sphere/core/widgets/loading.dart';
import 'package:uni_sphere/core/widgets/unable_to_connect.dart';
import 'package:uni_sphere/features/events/domain/entities/event_category.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_state.dart';
import 'package:uni_sphere/features/events/utils/upcoming_events_selector.dart';
import '../../../home/utils/event_date_formatter.dart';
import '../../domain/entities/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String selectedCategory = '';
  final textPrimary = AppColors.primaryText;
  final textSecondary = AppColors.secondaryText;
  final primary = AppColors.primary;
  final secondary = AppColors.secondary;
  final surface = AppColors.surface;
  final searchController = TextEditingController();
  List<Event> _filterEvents(List<Event> events) {
    final query = searchController.text.trim().toLowerCase();

    return events.where((event) {
      final matchesCategory = selectedCategory.isEmpty || //if no category is selected every event passes the filter
          event.category.name == selectedCategory; //if the selected category is the same as current events category

      final matchesName = event.name.toLowerCase().contains(query); // if the current event contains the search text in any part of it

      return matchesCategory && matchesName;
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
      ),
      body: SingleChildScrollView(
        child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Form(
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value){
                              setState(() {
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Search events",
                              fillColor: colors.surface,
                              filled: true,
                              prefixIcon: Icon(
                                  Icons.search,
                                  color: primary.withValues(alpha: .8),
                              ),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {});
                                },
                              )
                                  : null,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: primary
                                )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: textPrimary.withValues(alpha: .3)
                                  )
                              ),
                            ),
                          )),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...EventCategory.values.map((value){
                              final name = value.name;
                              final isSelected = selectedCategory == value.name;
                              final buttonColor = isSelected
                                  ? primary
                                  : colors.secondary.withValues(alpha: 0.30);
                              final textColor = isSelected ? surface : colors.primary;
                              return Row(
                                children: [
                                  TextButton(
                                      onPressed: (){
                                        setState(() {
                                          if(selectedCategory == value.name){
                                            selectedCategory = '';
                                          }
                                          else{
                                            selectedCategory = value.name;
                                          }
                                        });
                                      },
                                    style: TextButton.styleFrom(
                                      backgroundColor: buttonColor
                                    ),
                                      child: Text(
                                        name.toUpperCase(),
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                  ),
                                  SizedBox(width: 5)
                                ],
                              );
                            })
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                  BlocBuilder<EventBloc,EventState>(
                    builder: (context,state){
                      if(state is EventLoading){
                        return Center(
                          child: Loading(),
                        );
                      }
                      if(state is EventError){
                        return unableToConnectWidget(state.errorMsg, ()=>context.read<EventBloc>().add(LoadEvents()));
                      }
                      if(state is EventLoaded){
                        final events = UpcomingEventsSelector(events: _filterEvents(state.events)).getAllUpcomingEvents();
                        if(events.isEmpty){
                          return Center(
                            child: Text(
                                "No events"
                            ),
                          );
                        }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: events.length,
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
                                  extra: events[index],
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: ClipRRect(
                                        borderRadius: BorderRadiusGeometry.circular(10),
                                        child: Image.asset(
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 500,
                                            "assets/images/ronaldo_crying.png"
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                  decoration: BoxDecoration(
                                                      color: colors.secondary.withValues(alpha: 0.30),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: Text(
                                                    events[index].category.name.toUpperCase(),
                                                    style: TextStyle(
                                                        color: colors.primary,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 3,),
                                                Text(
                                                  events[index].name,
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
                                                  "${EventDateFormatter.dateFormatter(events[index].date)} · ${EventDateFormatter.startTimeFormatter(events[index].startTime)}",
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
                                                    Expanded(
                                                      child: Text(
                                                        overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          events[index].location,
                                                          style: TextStyle(
                                                            color: textSecondary,
                                                          )
                                                      ),
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                    );}
                    return SizedBox.shrink();
                    }
                  )
                    ],
                  ),
        )
      )
      );
  }
}
