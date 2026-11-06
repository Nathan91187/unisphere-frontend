import '../../domain/entities/event_category.dart';

abstract class EventEvent {
  const EventEvent();
}
class LoadEventById extends EventEvent{
  final int eventId;
  const LoadEventById({required this.eventId});
}
class LoadEvents extends EventEvent{
  const LoadEvents();
}
class CreateEvent extends EventEvent{
  final String name;
  final String description;
  final String? imageUrl;
  final EventCategory category;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int capacity;
  final String location;
  final int? clubId;
  CreateEvent({
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.location,
    this.clubId,
});
}
class UpdateEvent extends EventEvent{
  final int eventId;
  final String name;
  final String description;
  final String? imageUrl;
  final EventCategory category;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int capacity;
  final String location;
  UpdateEvent({
    required this.eventId,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.location,
  });
}
class DeleteEvent extends EventEvent{
  final int eventId;
  DeleteEvent({required this.eventId});
}
