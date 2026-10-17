import 'package:uni_sphere/features/events/domain/entities/event.dart';

abstract class EventState {}
class EventLoading extends EventState{}
class EventInitial extends EventState{}
class EventLoaded extends EventState{
  final List<Event> events;
  EventLoaded({required this.events});
}
class EventError extends EventState{
  final String errorMsg;
  EventError ({required this.errorMsg});
}