import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:uni_sphere/features/profile/data/models/create_profile_request.dart';
import 'package:uni_sphere/features/profile/data/models/profile_response_model.dart';
import 'package:uni_sphere/features/profile/data/models/update_profile_request.dart';

class ProfileRemoteDataSource {
  final String uri = "https://unisphere-backend-hj5x.onrender.com/users";
  final String unableToConnect =  "Unable to connect to the server";
  final httpClientException = 'Unable to connect. Please check your connection and try again.';
  Future<ProfileResponseModel> updateProfileImage(File image)async{
    try{
      final token = await FirebaseAuth.instance.currentUser
          ?.getIdToken()
          .timeout(const Duration(seconds: 15));
      if (token == null) {
        throw Exception('user is not authenticated');
      }
      final request = http.MultipartRequest(
          'POST',
          Uri.parse('$uri/me/update-profile-image'));
      request.files.add(
        await http.MultipartFile.fromPath(
            'file',
            image.path
          )
      );
      request.headers['Authorization'] =  'Bearer $token';
      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String, dynamic> body = jsonDecode(response.body);
      return ProfileResponseModel.fromJson(body);
    }on http.ClientException {
      throw Exception(httpClientException);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<bool> isUsernameAvailable(String username)async{
    try{
      final response = await get(
        Uri.parse("$uri/availability").replace(
          queryParameters: {
            'username' : username.trim()
          }
        ),
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      return jsonDecode(response.body) as bool;
    }on http.ClientException catch (e) {
      throw Exception(httpClientException);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<ProfileResponseModel> getProfileByUid(String uid)async{
    try{
      final token = await FirebaseAuth.instance.currentUser
          ?.getIdToken()
          .timeout(const Duration(seconds: 15));
      if (token == null) {
        throw Exception('user is not authenticated');
      }
      final response = await get(
          Uri.parse("$uri/$uid"),
        headers: {
          'Authorization' : 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String, dynamic> body = jsonDecode(response.body);
      return ProfileResponseModel.fromJson(body);
    }on http.ClientException catch (e) {
      throw Exception(e.toString());
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<List<ProfileResponseModel>> getAllProfilesByUid(List<String>uids)async{
    try{
      final token = await FirebaseAuth.instance.currentUser
          ?.getIdToken()
          .timeout(const Duration(seconds: 15));
      if (token == null) {
        throw Exception('user is not authenticated');
    }
      final response = await post(
        Uri.parse('$uri/bulk'),
        headers: {
          'Authorization' : 'Bearer $token',
           'Content-Type': 'application/json',
        },
        body: jsonEncode(uids)
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((profile)=>ProfileResponseModel.fromJson(profile as Map<String, dynamic>)).toList();
    }
    on http.ClientException catch (e) {
      throw Exception(httpClientException);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<List<ProfileResponseModel>> searchUsersByUsername(String username)async{
    try{
      final token = await FirebaseAuth.instance.currentUser
          ?.getIdToken()
          .timeout(const Duration(seconds: 15));
      if (token == null) {
        throw Exception('user is not authenticated');
      }
      final response = await get(
          Uri.parse('$uri/search').replace(
            queryParameters: {
              'username' : username
            }
          ),
          headers: {
            'Authorization' : 'Bearer $token',
          },
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((profile)=>ProfileResponseModel.fromJson(profile as Map<String, dynamic>)).toList();
    }
    on http.ClientException catch (e) {
      throw Exception(httpClientException);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<ProfileResponseModel> createProfile(CreateProfileRequest request) async{
    try{
      final token = await FirebaseAuth.instance.currentUser
          ?.getIdToken()
          .timeout(const Duration(seconds: 15));
      if (token == null) {
        throw Exception('user is not authenticated');
      }
      final response = await post(
        Uri.parse(uri),
        body: jsonEncode(request.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'content-type': 'application/json'
        },
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 201) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String, dynamic> body = jsonDecode(response.body);
      return ProfileResponseModel.fromJson(body);
    }on http.ClientException catch (e) {
      throw Exception(httpClientException);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<ProfileResponseModel> updateProfile(UpdateProfileRequest request) async{
    try{
      final token = await FirebaseAuth.instance.currentUser
          ?.getIdToken()
          .timeout(Duration(seconds: 15));
      if (token == null) {
        throw Exception('user is not authenticated');
      }
      final response = await put(
          Uri.parse("$uri/me"),
          body: jsonEncode(request.toJson()),
          headers: {
            'Authorization': 'Bearer $token',
            'content-type': 'application/json'
          }
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
      final Map<String, dynamic> body = jsonDecode(response.body);
      return ProfileResponseModel.fromJson(body);
    }on http.ClientException catch (e) {
      throw Exception(httpClientException);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
  Future<void> deleteProfile()async{
    try{
      final token = await FirebaseAuth.instance.currentUser
          ?.getIdToken()
          .timeout(const Duration(seconds: 15));
      if (token == null) {
        throw Exception('user is not authenticated');
      }
      final response = await delete(
          Uri.parse("$uri/me"),
          headers: {
            'Authorization': 'Bearer $token'
          }
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 204) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message']);
      }
    } on http.ClientException catch (e) {
      throw Exception(httpClientException);
    }
    on TimeoutException {
      throw Exception(unableToConnect);
    }
  }
}