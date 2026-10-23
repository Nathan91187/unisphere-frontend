import 'dart:convert';

import 'package:http/http.dart';
import 'package:uni_sphere/features/clubs/data/models/club_model.dart';

class ClubRemoteDataSource {
  final uri = "http://192.168.100.7:8080/clubs";
  Future<List<ClubModel>> getAllClubs() async{
    final response = await get(
      Uri.parse(uri)
    );
    if(response.statusCode != 200){
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message']);
    }
    final List<dynamic> clubs = jsonDecode(response.body);
    return clubs.map((club)=> ClubModel.fromJson(club)).toList();
  }
}