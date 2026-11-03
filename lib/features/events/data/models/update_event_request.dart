import 'package:uni_sphere/features/events/domain/entities/event_category.dart';

class UpdateEventRequest {
  final String name;
  final String description;
  final String? imageUrl;
  final EventCategory category;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int capacity;
  final String location;

  const UpdateEventRequest({
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category.name.toUpperCase(),
      'date': date.toIso8601String().split('T')[0],
      'startTime': startTime,
      'endTime': endTime,
      'capacity': capacity,
      'location': location,
    };
  }
}