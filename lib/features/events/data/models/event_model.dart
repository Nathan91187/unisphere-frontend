import 'package:uni_sphere/features/events/domain/entities/event_category.dart';

class EventModel {
  final int id;
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
   EventModel({
    required this.id,
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
  factory EventModel.fromJson(Map<String,dynamic> json){
    return EventModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        category: EventCategory.values.byName(json['category'].toString().toLowerCase()),
        date: DateTime.parse(json['date']),
        startTime: json['startTime'],
        endTime: json['endTime'],
        capacity: json['capacity'],
        attendeeCount: json['attendeeCount'],
        location: json['location'],
        organizerUid: json['organizerUid'],
        organizerName: json['organizerName'],
        clubId: json['clubId'],
        clubName: json['clubName']
    );
    }
}