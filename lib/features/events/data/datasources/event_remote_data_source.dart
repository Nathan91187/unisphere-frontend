import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:uni_sphere/features/events/data/models/create_event_request.dart';
import 'package:uni_sphere/features/events/data/models/event_model.dart';
import 'package:uni_sphere/features/events/data/models/rsvp_model.dart';
import 'package:uni_sphere/features/events/data/models/update_event_request.dart';
import 'package:uni_sphere/features/events/domain/entities/rsvp_status.dart';

class EventRemoteDataSource {
  final String uri = "http://localhost:8080/events";
  final String unableToConnect =  "Unable to connect to the server";
  final String notAuthenticated = 'Sign in or register to proceed';
 Future<List<EventModel>> getAllEvents() async{
    try {
      final response = await get(
        Uri.parse(uri),
      ).timeout(const Duration(seconds: 15));
      if(response.statusCode != 200){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final List<dynamic> events = jsonDecode(response.body);
      return events.map((event)=> EventModel.fromJson(event)).toList();
    } on  http.ClientException {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<EventModel> createEvent(CreateEventRequest request) async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception(notAuthenticated);
      }
      final response = await post(
        Uri.parse(uri),
        headers: {
          'Authorization' : 'Bearer $token',
          'Content-type' : 'application/json'
        },
        body: jsonEncode(request.toJson())
      ).timeout(const Duration(seconds: 15));
      if(response.statusCode != 201){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String,dynamic> event = jsonDecode(response.body);
      return EventModel.fromJson(event);
    }
    on  http.ClientException {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<EventModel> updateEvent(UpdateEventRequest request, int eventId)async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception(notAuthenticated);
      }
      final response = await put(
          Uri.parse("$uri/$eventId"),
          headers: {
            'Authorization' : 'Bearer $token',
            'Content-type' : 'application/json'
          },
          body: jsonEncode(request.toJson())
      ).timeout(const Duration(seconds: 15));
      if(response.statusCode != 200){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String,dynamic> event = jsonDecode(response.body);
      return EventModel.fromJson(event);
    }
    on  http.ClientException {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<void> deleteEvent(int eventId) async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception(notAuthenticated);
      }
      final response = await delete(
          Uri.parse("$uri/$eventId"),
          headers: {
            'Authorization' : 'Bearer $token'
          },
      ).timeout(const Duration(seconds: 15));
      if(response.statusCode != 204){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
    }
    on  http.ClientException {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<RsvpModel?> getMyRsvp(int eventId)async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception(notAuthenticated);
      }
      final response = await get(
          Uri.parse('$uri/$eventId/rsvps/me'),
          headers: {
            'Authorization' : 'Bearer $token',
          },
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 404) {
        return null;
      }
      if(response.statusCode != 200){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String,dynamic> body = jsonDecode(response.body);
      return RsvpModel.fromJson(body);
    }
    on  http.ClientException {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<List<RsvpModel>> getRsvpsByEventId(int eventId)async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception(notAuthenticated);
      }
      final response = await get(
        Uri.parse('$uri/$eventId/rsvps'),
        headers: {
          'Authorization' : 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));
      if(response.statusCode != 200){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((rsvpModel)=> RsvpModel.fromJson(rsvpModel)).toList();
    }
    on  http.ClientException {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<RsvpModel> createRsvp(int eventId, RsvpStatus status)async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception(notAuthenticated);
      }
      final response = await post(
          Uri.parse('$uri/$eventId/rsvps').replace(
            queryParameters: {
              'status' : status.name.toUpperCase()
            }
          ),
          headers: {
            'Authorization' : 'Bearer $token',
          },
      ).timeout(const Duration(seconds: 15));
      if(response.statusCode != 201){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String,dynamic> body = jsonDecode(response.body);
      return RsvpModel.fromJson(body);
    }
    on  http.ClientException {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<RsvpModel> updateRsvp(int eventId, RsvpStatus status)async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception(notAuthenticated);
      }
      final response = await put(
        Uri.parse('$uri/$eventId/rsvps').replace(
            queryParameters: {
              'status' : status.name.toUpperCase()
            }
        ),
        headers: {
          'Authorization' : 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));
      if(response.statusCode != 200){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String,dynamic> body = jsonDecode(response.body);
      return RsvpModel.fromJson(body);
    }
    on  http.ClientException {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<void> deleteRsvp(int eventId) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();

      if (token == null) {
        throw Exception(notAuthenticated);
      }

      final response = await delete(
        Uri.parse('$uri/$eventId/rsvps'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 204) {
        final Map<String, dynamic> errorResponse =
        jsonDecode(response.body);

        throw Exception(errorResponse['message']);
      }
    } on http.ClientException {
      throw Exception(unableToConnect);
    } on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  }