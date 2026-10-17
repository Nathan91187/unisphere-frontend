import 'package:uni_sphere/features/events/domain/entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> getAllEvents();
}