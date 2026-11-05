import 'package:uni_sphere/features/events/domain/entities/event.dart';
import 'package:uni_sphere/features/events/domain/entities/event_category.dart';
import 'package:uni_sphere/features/events/domain/entities/rsvp.dart';
import 'package:uni_sphere/features/events/domain/entities/rsvp_status.dart';

abstract class EventRepository {
  Future<List<Event>> getAllEvents();
  Future<Event> createEvent({
    required String name,
    required String description,
     String? imageUrl,
    required EventCategory category,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int capacity,
    required String location,
     int? clubId
});
  Future<Event> updateEvent({
    required int eventId,
    required String name,
    required String description,
     String? imageUrl,
    required EventCategory category,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int capacity,
    required String location,
});
  Future<void> deleteEvent({
    required int eventId
});
  Future<Rsvp?> getMyRsvp({required int eventId});
  Future <List<Rsvp>> getRsvpsByEventId ({required int eventId});
  Future<Rsvp> createRsvp({required RsvpStatus status, required int eventId});
  Future<Rsvp> updateRsvp({required RsvpStatus status, required int eventId});
  Future<void> deleteRsvp({required int eventId});
}