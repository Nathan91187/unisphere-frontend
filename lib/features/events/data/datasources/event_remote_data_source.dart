import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:uni_sphere/features/events/data/models/event_model.dart';

class EventRemoteDataSource {
  String uri = "http://myIp.7:8080/events";
 Future<List<EventModel>> getAllEvents() async{
    try {
      final response = await get(
        Uri.parse(uri)
      );
      if(response.statusCode != 200){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final List<dynamic> events = jsonDecode(response.body);
      return events.map((event)=> EventModel.fromJson(event)).toList();
    } on  http.ClientException {

      throw Exception("Unable to connect to the server");
    }
  }
}