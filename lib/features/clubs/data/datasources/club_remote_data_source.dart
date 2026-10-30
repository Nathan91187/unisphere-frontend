import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:uni_sphere/features/clubs/data/models/club_model.dart';
import 'package:uni_sphere/features/clubs/data/models/create_club_request.dart';
import 'package:uni_sphere/features/clubs/data/models/update_club_request.dart';

class ClubRemoteDataSource {
  final uri = "http://192.168.100.7:8080/clubs";
  Future<List<ClubModel>> getAllClubs() async{
    final response = await get(
      Uri.parse(uri)
    ).timeout(const Duration(seconds: 15));
    if(response.statusCode != 200){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
    final List<dynamic> clubs = jsonDecode(response.body);
    return clubs.map((club)=> ClubModel.fromJson(club)).toList();
  }
  Future<ClubModel> getClubById(int clubId)async{
    final response = await get(
      Uri.parse("$uri/$clubId")
    ).timeout(const Duration(seconds: 15));
    if(response.statusCode != 200){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
    final Map<String, dynamic> club = jsonDecode(response.body);
    return ClubModel.fromJson(club);
  }
  Future<ClubModel> createClub(CreateClubRequest request)async{
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    final response = await post(
      Uri.parse(uri),
      headers: {
        'Content-type' : 'application/json',
        'Authorization' : 'Bearer $token'
      },
      body: jsonEncode(request.toJson())
    ).timeout(const Duration(seconds: 15));
    if(response.statusCode != 201){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
    final Map<String,dynamic> club = jsonDecode(response.body);
    return ClubModel.fromJson(club);
  }
  Future<ClubModel> updateClub(int clubId,UpdateClubRequest request) async{
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    final response = await put(
        Uri.parse("$uri/$clubId"),
        headers: {
          'Content-type' : 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: jsonEncode(request.toJson())
    ).timeout(const Duration(seconds: 15));
    if(response.statusCode != 200){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
    final Map<String,dynamic> club = jsonDecode(response.body);
    return ClubModel.fromJson(club);
  }
  Future<void> deleteClub(int clubId)async{
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    final response = await delete(
        Uri.parse("$uri/$clubId"),
        headers: {
          'Authorization' : 'Bearer $token'
        },
    ).timeout(const Duration(seconds: 15));
    if(response.statusCode != 204){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
  }
}