import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:uni_sphere/features/clubs/data/models/club_membership_model.dart';
import 'package:uni_sphere/features/clubs/data/models/club_model.dart';
import 'package:uni_sphere/features/clubs/data/models/create_club_request.dart';
import 'package:uni_sphere/features/clubs/data/models/update_club_request.dart';

class ClubRemoteDataSource {
  final uri = "http://localhost:8080/clubs";
  final String unableToConnect =  "Unable to connect to the server";
  Future<List<ClubModel>> getAllClubs() async{
    try {
      final response = await get(
        Uri.parse(uri)
      ).timeout(const Duration(seconds: 15));
      if(response.statusCode != 200){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final List<dynamic> clubs = jsonDecode(response.body);
      return clubs.map((club)=> ClubModel.fromJson(club)).toList();
    } on http.ClientException catch (e) {
     throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception("Unable to connect to the server");
    }
  }
  Future<ClubModel> getClubById(int clubId)async{
    try {
      final response = await get(
        Uri.parse("$uri/$clubId")
      ).timeout(const Duration(seconds: 15));
      if(response.statusCode != 200){
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String, dynamic> club = jsonDecode(response.body);
      return ClubModel.fromJson(club);
    } on http.ClientException catch (e) {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception("Unable to connect to the server");
    }
  }
  Future<ClubModel> createClub(CreateClubRequest request)async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception('User is not authenticated');
      }
      final response = await post(
          Uri.parse(uri),
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(request.toJson())
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 201) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String, dynamic> club = jsonDecode(response.body);
      return ClubModel.fromJson(club);
    }
    on http.ClientException catch (e) {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception("Unable to connect to the server");
    }
  }
  Future<ClubModel> updateClub(int clubId,UpdateClubRequest request) async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception('User is not authenticated');
      }
      final response = await put(
          Uri.parse("$uri/$clubId"),
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(request.toJson())
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String, dynamic> club = jsonDecode(response.body);
      return ClubModel.fromJson(club);
    }
    on http.ClientException catch (e) {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception("Unable to connect to the server");
    }
  }
  Future<void> deleteClub(int clubId)async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception('User is not authenticated');
      }
      final response = await delete(
        Uri.parse("$uri/$clubId"),
        headers: {
          'Authorization': 'Bearer $token'
        },
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 204) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
    }on http.ClientException catch (e) {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception("Unable to connect to the server");
    }
  }
  Future<ClubMembershipModel> getMyMembership(int clubId) async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception('User is not authenticated');
      }
      final response = await get(
          Uri.parse("$uri/$clubId/memberships/me"),
          headers: {
            'Authorization': 'Bearer $token'
          }
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String, dynamic> body = jsonDecode(response.body);
      return ClubMembershipModel.fromJson(body);
    }on http.ClientException catch (e) {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception("Unable to connect to the server");
    }
  }
  Future<void> leaveClub(int clubId) async{
    try{
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) {
        throw Exception('User is not authenticated');
      }
      final response = await delete(
          Uri.parse("$uri/$clubId/memberships"),
          headers: {
            'Authorization': 'Bearer $token'
          }
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 204) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
    }on http.ClientException catch (e) {
      throw Exception(unableToConnect);
    }
    on TimeoutException {
      throw Exception("Unable to connect to the server");
    }
  }
    Future<ClubMembershipModel> joinClub(int clubId) async {
      try{
        final token = await FirebaseAuth.instance.currentUser?.getIdToken();
        if (token == null) {
          throw Exception('User is not authenticated');
        }
        final response = await post(
            Uri.parse("$uri/$clubId/memberships"),
            headers: {
              'Authorization': 'Bearer $token'
            }
        ).timeout(const Duration(seconds: 15));
        if (response.statusCode != 201) {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          throw Exception(errorResponse['message']);
        }
        final body = jsonDecode(response.body);
        return ClubMembershipModel.fromJson(body);
      }on http.ClientException catch (e) {
        throw Exception(unableToConnect);
      }
      on TimeoutException {
        throw Exception("Unable to connect to the server");
      }
    }
    Future<bool> checkLeaveEligibility(int clubId) async{
      try{
        final token = await FirebaseAuth.instance.currentUser?.getIdToken();
        if (token == null) {
          throw Exception('User is not authenticated');
        }
        final response = await get(
          Uri.parse('$uri/$clubId/memberships/leave-check'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode != 200) {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          throw Exception(errorResponse['message']);
        }
        return jsonDecode(response.body) as bool;
      }on http.ClientException catch (e) {
        throw Exception(unableToConnect);
      }
      on TimeoutException {
        throw Exception("Unable to connect to the server");
      }
    }
    
  }