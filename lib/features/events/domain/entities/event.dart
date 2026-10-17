import 'event_category.dart';

class Event {
  final int? id;
  final String name;
  final String description;
  final String? imageUrl;
  final EventCategory category;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int capacity;
  final int attendeeCount;
  final String location;
  final String organizerUid;
  final String organizerName;
  final int? clubId;
  final String? clubName;

  const Event({
    this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.attendeeCount,
    required this.location,
    required this.organizerUid,
    required this.organizerName,
    this.clubId,
    this.clubName
  });
}