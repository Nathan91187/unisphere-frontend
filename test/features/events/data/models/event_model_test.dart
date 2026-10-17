
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_sphere/features/events/data/models/event_model.dart';
import 'package:uni_sphere/features/events/domain/entities/event_category.dart';

void main() {
  test('fromJson creates an EventModel correctly', () {
    final json = {
      'id': 1,
      'name': 'Flutter Workshop',
      'description': 'Learn Flutter development',
      'imageUrl': null,
      'category': 'TECHNOLOGY',
      'date': '2026-11-15',
      'startTime': '14:00:00',
      'endTime': '16:00:00',
      'capacity': 50,
      'attendeeCount': 12,
      'location': 'Main Campus',
      'organizerUid': 'user123',
      'organizerName': 'GDG Organizer',
      'clubId': null,
      'clubName': null,
    };

    final event = EventModel.fromJson(json);

    expect(event.id, 1);
    expect(event.name, 'Flutter Workshop');
    expect(event.date, DateTime(2026, 11, 15));
    expect(event.startTime, '14:00:00');
    expect(event.capacity, 50);
    expect(event.attendeeCount, 12);
    expect(event.category, EventCategory.technology);
    expect(event.clubId, isNull);
  });
}
