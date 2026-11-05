import 'package:bloc/bloc.dart';
import 'package:uni_sphere/features/events/domain/repositories/event_repository.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;
  final unableToConnect = 'Unable to connect. Please try again';
  EventBloc({required this.eventRepository}): super(EventInitial()){
    on<LoadEvents>((event,emit) async {
      emit(EventLoading());
      try {
        final events = await eventRepository.getAllEvents();
        emit(EventLoaded(events: events));
      } catch (e) {
      emit(EventError(
        errorMsg: e.toString(),
      ));
    }
    });
    on<CreateEvent>((event,emit)async{
      emit(EventLoading());
      try{
        final createdEvent = await eventRepository.createEvent(
            name: event.name,
            description: event.description,
            category: event.category,
            imageUrl: event.imageUrl,
            date: event.date,
            startTime: event.startTime,
            endTime: event.endTime,
            capacity: event.capacity,
            location: event.location);
        emit(EventOperationSuccess(
            event: createdEvent,
            message: 'Event created successfully'));
      }
      catch(e){
        emit(
          EventError(errorMsg: e.toString())
        );
      }
    });
    on<UpdateEvent> ((event,emit)async{
      emit(EventLoading());
      try{
        final updatedEvent = await eventRepository.updateEvent(
            eventId: event.eventId,
            name: event.name,
            imageUrl: event.imageUrl,
            description: event.description,
            category: event.category,
            date: event.date,
            startTime: event.startTime,
            endTime: event.endTime,
            capacity: event.capacity,
            location: event.location);
        emit(EventOperationSuccess(
            event: updatedEvent,
            message: 'Event updated successfully'));
      }
      catch(e){
        emit(
            EventError(errorMsg: e.toString())
        );
      }
    });
    on<DeleteEvent> ((event,emit)async{
      try{
        emit(EventLoading());
        await eventRepository.deleteEvent(eventId: event.eventId);
        emit(EventOperationSuccess(
            message: 'Event deleted successfully')
        );
      }
      catch(e){
        emit(EventError(errorMsg: e.toString()));
      }
    });
  }

}