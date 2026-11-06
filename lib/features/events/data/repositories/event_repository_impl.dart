import 'package:uni_sphere/features/events/data/datasources/event_remote_data_source.dart';
import 'package:uni_sphere/features/events/data/models/create_event_request.dart';
import 'package:uni_sphere/features/events/data/models/event_model.dart';
import 'package:uni_sphere/features/events/data/models/update_event_request.dart';
import 'package:uni_sphere/features/events/domain/entities/event.dart';
import 'package:uni_sphere/features/events/domain/entities/event_category.dart';
import 'package:uni_sphere/features/events/domain/entities/rsvp.dart';
import 'package:uni_sphere/features/events/domain/entities/rsvp_status.dart';
import 'package:uni_sphere/features/events/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository{
  final EventRemoteDataSource dataSource;
   const EventRepositoryImpl({required this.dataSource});
  @override
  Future<Event> getEventById({required int eventId}) async{
   final event = await dataSource.getEventById(eventId);
   return event.toEntity();
  }
  @override
  Future<List<Event>> getAllEvents() async{
    final List<EventModel> eventModels = await dataSource.getAllEvents();
    return eventModels.map((eventModel)=>eventModel.toEntity()).toList();
  }

  @override
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
    int? clubId}) async{
    final request = CreateEventRequest(
        name: name,
        description: description,
        category: category,
        date: date,
        startTime: startTime,
        endTime: endTime,
        capacity: capacity,
        location: location,
        clubId: clubId
    );
    final eventModel = await dataSource.createEvent(request);
    return eventModel.toEntity();
  }

  @override
  Future<void> deleteEvent({required int eventId}) async{
   await dataSource.deleteEvent(eventId);
  }

  @override
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
    int? clubId}) async{
    final request = UpdateEventRequest(
        name: name,
        description: description,
        category: category,
        date: date,
        startTime: startTime,
        endTime: endTime,
        capacity: capacity,
        location: location);
    final eventModel = await dataSource.updateEvent(request,eventId);
    return eventModel.toEntity();
  }

  @override
  Future<Rsvp> createRsvp({
    required RsvpStatus status,
    required int eventId}) async{
    final rsvp = await dataSource.createRsvp(eventId, status);
    return rsvp.toEntity();
  }

  @override
  Future<void> deleteRsvp({required int eventId}) async{
    await dataSource.deleteRsvp(eventId);
  }

  @override
  Future<Rsvp?> getMyRsvp({required int eventId}) async{
    final rsvp = await dataSource.getMyRsvp(eventId);
    return rsvp?.toEntity();
  }

  @override
  Future<List<Rsvp>> getRsvpsByEventId({required int eventId}) async{
    final rsvps = await dataSource.getRsvpsByEventId(eventId);
    return rsvps.map((rsvp)=>rsvp.toEntity()).toList();
  }

  @override
  Future<Rsvp> updateRsvp({required RsvpStatus status, required int eventId}) async{
    final rsvp = await dataSource.updateRsvp(eventId, status);
    return rsvp.toEntity();
  }


}