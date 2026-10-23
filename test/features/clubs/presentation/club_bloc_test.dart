
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uni_sphere/features/clubs/domain/entities/club.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club_category.dart';
import 'package:uni_sphere/features/clubs/domain/repositories/club_repository.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_bloc.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_event.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_state.dart';

class FakeClubRepository implements ClubRepository {
  final List<Club> clubs;
  final bool shouldThrow;

  FakeClubRepository({
    this.clubs = const [],
    this.shouldThrow = false,
  });

  @override
  Future<List<Club>> getAllClubs() async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return clubs;
  }
}

void main() {
  const testClub = Club(
    id: 1,
    name: 'GDG on Campus',
    description: 'A technology community for students',
    memberCount: 25,
    category: ClubCategory.technology,
  );

  const errorMsg = 'Unable to connect. Please try again';

  group('ClubBloc', () {
    blocTest<ClubBloc, ClubState>(
      'emits [ClubLoading, ClubLoaded] when clubs load successfully',
      build: () => ClubBloc(
        clubRepository: FakeClubRepository(clubs: [testClub]),
      ),
      act: (bloc) => bloc.add(LoadClubs()),
      expect: () => [
        isA<ClubLoading>(),
        isA<ClubLoaded>()
            .having((state) => state.clubs, 'clubs', [testClub]),
      ],
    );

    blocTest<ClubBloc, ClubState>(
      'emits [ClubLoading, ClubError] when repository throws',
      build: () => ClubBloc(
        clubRepository: FakeClubRepository(shouldThrow: true),
      ),
      act: (bloc) => bloc.add(LoadClubs()),
      expect: () => [
        isA<ClubLoading>(),
        isA<ClubError>()
            .having((state) => state.errorMsg, 'errorMsg', errorMsg),
      ],
    );
  });
}
