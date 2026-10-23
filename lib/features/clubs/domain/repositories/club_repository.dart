import 'package:uni_sphere/features/clubs/domain/entities/club.dart';

abstract class ClubRepository {
  Future<List<Club>> getAllClubs();
}