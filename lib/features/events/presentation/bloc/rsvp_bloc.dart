import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/features/events/domain/repositories/event_repository.dart';
import 'package:uni_sphere/features/events/presentation/bloc/rsvp_event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/rsvp_state.dart';

class RsvpBloc extends Bloc<RsvpEvent,RsvpState>{
  final EventRepository repository;
   RsvpBloc({required this.repository}):super(RsvpInitial()){
    on<LoadRsvps>((event,emit)async{
      emit(RsvpLoading());
      try{
        final rsvps = await repository.getRsvpsByEventId(eventId: event.eventId);
        emit(RsvpLoaded(rsvps: rsvps));
      }
      catch(e){
        emit(RsvpError(errorMsg: e.toString()));
      }
    });
    on<LoadMyRsvp>((event,emit)async{
      emit(RsvpLoading());
      try{
        final myRsvp = await repository.getMyRsvp(eventId: event.eventId);
        emit(MyRsvpLoaded(rsvp: myRsvp));
      }
      catch(e){
        emit(RsvpError(errorMsg: e.toString()));
      }
    });
    on<CreateRsvp>((event,emit)async{
      emit(RsvpLoading());
      try{
        final rsvp = await repository.createRsvp(status: event.status, eventId: event.eventId);
        emit(RsvpOperationSuccess(message: 'You have successfully registered for this event.'));
        emit(MyRsvpLoaded(rsvp: rsvp));
      }
      catch(e){
        emit(RsvpError(errorMsg: e.toString()));
        }
    });
    on<UpdateRsvp>((event,emit)async{
      emit(RsvpLoading());
      try{
        final rsvp = await repository.updateRsvp(status: event.status, eventId: event.eventId);
        emit(RsvpOperationSuccess(message: 'Your registration has been updated successfully.'));
        emit(MyRsvpLoaded(rsvp: rsvp));
        }
      catch(e){
          emit(RsvpError(errorMsg: e.toString()));
        }
      });
    on<DeleteRsvp>((event,emit)async{
      emit(RsvpLoading());
      try{
        await repository.deleteRsvp(eventId: event.eventId);
        emit(RsvpOperationSuccess(message: 'Your registration has been cancelled successfully'));
        emit(MyRsvpLoaded(rsvp: null));
        }
      catch(e){
          emit(RsvpError(errorMsg: e.toString()));
        }
      });
  }
}