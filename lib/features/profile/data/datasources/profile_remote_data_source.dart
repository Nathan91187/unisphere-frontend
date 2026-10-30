import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:uni_sphere/features/profile/data/models/create_profile_request.dart';
import 'package:uni_sphere/features/profile/data/models/profile_response_model.dart';
import 'package:uni_sphere/features/profile/data/models/update_profile_request.dart';

class ProfileRemoteDataSource {
  final String uri = "http://myIp:8080/users";
  Future<ProfileResponseModel> getProfileByUid(String uid)async{
    final response = await get(
      Uri.parse("$uri/$uid")
    ).timeout(const Duration(seconds: 15));
    if(response.statusCode != 200){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
    final Map<String,dynamic> body = jsonDecode(response.body);
    return ProfileResponseModel.fromJson(body);
  }
  Future<ProfileResponseModel> createProfile(CreateProfileRequest request) async{
    final token = await FirebaseAuth.instance.currentUser?.getIdToken().timeout(const Duration(seconds: 15));
    if(token == null){
      throw Exception('user is not authenticated');
    }
    final response = await post(
      Uri.parse(uri),
      body: jsonEncode(request.toJson()),
      headers: {
        'Authorization' : 'Bearer $token',
        'content-type' : 'application/json'
    },
    ).timeout(const Duration(seconds: 15));
    if(response.statusCode != 201){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
    final Map<String,dynamic> body= jsonDecode(response.body);
    return ProfileResponseModel.fromJson(body);
  }
  Future<ProfileResponseModel> updateProfile(UpdateProfileRequest request) async{
    final token = await FirebaseAuth.instance.currentUser?.getIdToken().timeout(Duration(seconds: 15));
    if(token == null){
      throw Exception('user is not authenticated');
    }
    final response = await put(
      Uri.parse("$uri/me"),
      body: jsonEncode(request.toJson()),
      headers: {
        'Authorization' : 'Bearer $token',
        'content-type' : 'application/json'
      }
    ).timeout(const Duration(seconds: 15));
    if(response.statusCode != 200){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
    final Map<String,dynamic> body = jsonDecode(response.body);
    return ProfileResponseModel.fromJson(body);
  }
  Future<void> deleteProfile()async{
    final token = await FirebaseAuth.instance.currentUser?.getIdToken().timeout(const Duration(seconds: 15));
    if(token == null){
      throw Exception('user is not authenticated');
    }
    final response = await delete(
      Uri.parse("$uri/me"),
      headers: {
        'Authorization' : 'Bearer $token'
      }
    ).timeout(const Duration(seconds: 15));
    if(response.statusCode != 204){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
  }
}