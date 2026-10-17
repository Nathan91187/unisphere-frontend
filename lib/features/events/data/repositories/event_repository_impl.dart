import 'package:uni_sphere/features/events/data/datasources/event_remote_data_source.dart';
import 'package:uni_sphere/features/events/data/models/event_model.dart';
import 'package:uni_sphere/features/events/domain/entities/event.dart';
import 'package:uni_sphere/features/events/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository{
  final EventRemoteDataSource dataSource;
   const EventRepositoryImpl({required this.dataSource});
  @override
  Future<List<Event>> getAllEvents() async{
    List<EventModel> eventModels = await dataSource.getAllEvents();
    return eventModels.map((eventModel){
      return Event(
          id: eventModel.id,
          name: eventModel.name,
          description: eventModel.description,
          category: eventModel.category,
          date: eventModel.date,
          startTime: eventModel.startTime,
          endTime: eventModel.endTime,
          capacity: eventModel.capacity,
          attendeeCount: eventModel.attendeeCount,
          location: eventModel.location,
          organizerUid: eventModel.organizerUid,
          organizerName: eventModel.organizerName,
          clubName: eventModel.clubName,
          clubId: eventModel.clubId,
          imageUrl: eventModel.imageUrl
      );
    }).toList();
  }

}