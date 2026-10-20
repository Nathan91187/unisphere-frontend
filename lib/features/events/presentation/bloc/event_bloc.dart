import 'package:bloc/bloc.dart';
import 'package:uni_sphere/features/events/domain/repositories/event_repository.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;
  EventBloc({required this.eventRepository}): super(EventInitial()){
    on<LoadEvents>((event,emit) async {
      emit(EventLoading());
      try {
        final events = await eventRepository.getAllEvents();
        emit(EventLoaded(events: events));
      } catch (e) {
      emit(EventError(
        errorMsg: 'Unable to connect. Please try again',
      ));
    }
    });
  }
}