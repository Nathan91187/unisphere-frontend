import 'package:flutter_test/flutter_test.dart';
import 'package:uni_sphere/features/clubs/data/models/club_model.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club_category.dart';

void main(){
  test('fromJson creates club model correctly' ,(){
    final json = {
      'id': 1,
      'name' : 'test name',
      'description' : 'test description',
      'memberCount' : 10,
      'category' : 'TECHNOLOGY'
    };
    final club = ClubModel.fromJson(json);
    expect(club.id, 1);
    expect(club.name, 'test name');
    expect(club.description, 'test description');
    expect(club.memberCount, 10);
    expect(club.category, ClubCategory.technology);
  });
}