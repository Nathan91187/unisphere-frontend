
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_sphere/features/events/domain/entities/event.dart';
import 'package:uni_sphere/features/events/domain/entities/event_category.dart';
import 'package:uni_sphere/features/events/domain/repositories/event_repository.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_state.dart';

class FakeEventRepository implements EventRepository {
  final bool shouldFail;
  final List<Event> events;

  FakeEventRepository({
    this.shouldFail = false,
    this.events = const [],
  });

  @override
  Future<List<Event>> getAllEvents() async {
    if (shouldFail) {
      throw Exception('Failed to fetch events');
    }

    return events;
  }
}

Event createSampleEvent() {
  return Event(
    id: 1,
    name: 'Flutter Workshop',
    description: 'Learn Flutter development',
    category: EventCategory.technology,
    date: DateTime(2026, 11, 15),
    startTime: '14:00:00',
    endTime: '16:00:00',
    capacity: 50,
    attendeeCount: 10,
    location: 'Computer Lab',
    organizerUid: 'user-1',
    organizerName: 'Test Organizer',
  );
}

void main() {
  blocTest<EventBloc, EventState>(
    'emits loading then loaded with fetched events',
    build: () => EventBloc(
      eventRepository: FakeEventRepository(
        events: [createSampleEvent()],
      ),
    ),
    act: (bloc) => bloc.add(LoadEvents()),
    expect: () => [
      isA<EventLoading>(),
      isA<EventLoaded>()
          .having(
            (state) => state.events.length,
        'number of events',
        1,
      )
          .having(
            (state) => state.events.first.name,
        'event name',
        'Flutter Workshop',
      )
          .having(
            (state) => state.events.first.id,
        'event id',
        1,
      ),
    ],
  );

  blocTest<EventBloc, EventState>(
    'emits loading then error when fetching events fails',
    build: () => EventBloc(
      eventRepository: FakeEventRepository(shouldFail: true),
    ),
    act: (bloc) => bloc.add(LoadEvents()),
    expect: () => [
      isA<EventLoading>(),
      isA<EventError>(),
    ],
  );
}
