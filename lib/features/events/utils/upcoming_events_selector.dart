import 'package:uni_sphere/features/events/domain/entities/event.dart';

class UpcomingEventsSelector {
  final List<Event> events;
  const UpcomingEventsSelector({ required this.events});
  List<Event> getAllUpcomingEvents(){
    final now = DateTime.now();
    final upcomingEvents = events.where((event) {
      final startDate = _createDateTime(event);
      return startDate.isAfter(now);
    }).toList();
    upcomingEvents.sort((event,event1){
      final startDate = _createDateTime(event);
      final startDate1 = _createDateTime(event1);
      return startDate.compareTo(startDate1);
    });
    return upcomingEvents;
  }
  List<Event> getUpcomingEvents(){
   return getAllUpcomingEvents().take(3).toList();
  }
  static DateTime _createDateTime(Event event){
    final timeParts = event.startTime.split(":");
    return DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1])
    );
  }
}