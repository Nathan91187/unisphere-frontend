import 'dart:convert';

import 'package:http/http.dart';
import 'package:uni_sphere/features/events/data/models/event_model.dart';

class EventRemoteDataSource {
 Future<List<EventModel>> getAllEvents() async{
    final response = await get(
      Uri.parse("http://localhost:8080/events")
    );
    if(response.statusCode != 200){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
    final List<dynamic> events = jsonDecode(response.body);
    return events.map((event)=> EventModel.fromJson(event)).toList();
  }
}