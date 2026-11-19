import 'package:bloc/bloc.dart';
import 'package:uni_sphere/features/events/domain/repositories/event_repository.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_state.dart';

import '../../domain/entities/event.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;
  final unableToConnect = 'Unable to connect. Please try again';
  EventBloc({required this.eventRepository}): super(EventInitial()){
    on<LoadEventById>((event,emit)async{
      emit(EventLoading());
      try{
        final loadedEvent = await eventRepository.getEventById(eventId: event.eventId);
        emit(EventLoadedById(event: loadedEvent));
      }
      catch(e){
        emit(EventError(
            errorMsg: e.toString().replaceFirst('Exception: ', '')
        ));
      }
    });
    on<LoadEvents>((event,emit) async {
      emit(EventLoading());
      try {
        final events = await eventRepository.getAllEvents();
        emit(EventLoaded(events: events));
      } catch (e) {
        emit(EventError(
          errorMsg: e.toString().replaceFirst('Exception: ', '')
      ));
    }
    });
    on<CreateEvent>((event, emit) async {
      emit(EventLoading());

      try {
        Event createdEvent = await eventRepository.createEvent(
          name: event.name,
          description: event.description,
          category: event.category,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime,
          capacity: event.capacity,
          location: event.location,
          clubId: event.clubId,
        );

        if (event.image != null) {
          createdEvent = await eventRepository.updateEventImage(
            createdEvent.id,
            event.image!,
          );
        }

        emit(EventOperationSuccess(
          event: createdEvent,
          message: 'Event created successfully',
        ));
      } catch (e) {
        emit(EventError(
          errorMsg: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    });
    on<UpdateEvent>((event, emit) async {
      emit(EventLoading());

      try {
        Event updatedEvent = await eventRepository.updateEvent(
          eventId: event.eventId,
          name: event.name,
          description: event.description,
          category: event.category,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime,
          capacity: event.capacity,
          location: event.location,
        );

        if (event.image != null) {
          updatedEvent = await eventRepository.updateEventImage(
            event.eventId,
            event.image!,
          );
        }

        emit(EventOperationSuccess(
          event: updatedEvent,
          message: 'Event updated successfully',
        ));
      } catch (e) {
        emit(EventError(
          errorMsg: e.toString().replaceFirst('Exception: ', ''),
        ));
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
        emit(EventError(
          errorMsg: e.toString().replaceFirst('Exception: ', '')
        ));
      }
    });
  }

}