
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

  @override
  Future<Club> getClubById({required int clubId}) async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return clubs.firstWhere((club) => club.id == clubId);
  }

  @override
  Future<Club> createClub({
    required String name,
    required String description,
    String? imageUrl,
    required ClubCategory category,
  }) async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return Club(
      id: 2,
      name: name,
      description: description,
      imageUrl: imageUrl,
      memberCount: 0,
      category: category,
    );
  }

  @override
  Future<Club> updateClub({
    required int clubId,
    required String name,
    required String description,
    String? imageUrl,
    required ClubCategory category,
  }) async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return Club(
      id: clubId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      memberCount: 25,
      category: category,
    );
  }

  @override
  Future<void> deleteClub({required int clubId}) async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
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

  const errorMsg = 'Exception: Network error';

  group('ClubBloc', () {
    blocTest<ClubBloc, ClubState>(
      'emits [ClubLoading, ClubLoaded] when clubs load successfully',
      build: () => ClubBloc(
        clubRepository: FakeClubRepository(clubs: [testClub]),
      ),
      act: (bloc) => bloc.add(const LoadClubs()),
      expect: () => [
        isA<ClubLoading>(),
        isA<ClubLoaded>()
            .having((state) => state.clubs, 'clubs', [testClub]),
      ],
    );

    blocTest<ClubBloc, ClubState>(
      'emits [ClubLoading, ClubError] when loading clubs fails',
      build: () => ClubBloc(
        clubRepository: FakeClubRepository(shouldThrow: true),
      ),
      act: (bloc) => bloc.add(const LoadClubs()),
      expect: () => [
        isA<ClubLoading>(),
        isA<ClubError>()
            .having((state) => state.errorMsg, 'errorMsg', errorMsg),
      ],
    );

    blocTest<ClubBloc, ClubState>(
      'emits [ClubLoading, ClubDetailsLoaded] when club is retrieved',
      build: () => ClubBloc(
        clubRepository: FakeClubRepository(clubs: [testClub]),
      ),
      act: (bloc) => bloc.add(const GetClubById(clubId: 1)),
      expect: () => [
        isA<ClubLoading>(),
        isA<ClubDetailsLoaded>()
            .having((state) => state.club, 'club', testClub),
      ],
    );

    blocTest<ClubBloc, ClubState>(
      'emits [ClubLoading, ClubOperationSuccess] when club is created',
      build: () => ClubBloc(clubRepository: FakeClubRepository()),
      act: (bloc) => bloc.add(
        CreateClub(
          name: 'GDG on Campus',
          description: 'A technology community for students',
          category: ClubCategory.technology,
        ),
      ),
      expect: () => [
        isA<ClubLoading>(),
        isA<ClubOperationSuccess>()
            .having((state) => state.club?.name, 'club name', 'GDG on Campus')
            .having(
              (state) => state.message,
          'message',
          'Club created successfully',
        ),
      ],
    );

    blocTest<ClubBloc, ClubState>(
      'emits [ClubLoading, ClubOperationSuccess] when club is updated',
      build: () => ClubBloc(clubRepository: FakeClubRepository()),
      act: (bloc) => bloc.add(
        UpdateClub(
          clubId: 1,
          name: 'Updated GDG',
          description: 'Updated description',
          category: ClubCategory.technology,
        ),
      ),
      expect: () => [
        isA<ClubLoading>(),
        isA<ClubOperationSuccess>()
            .having((state) => state.club?.name, 'club name', 'Updated GDG')
            .having(
              (state) => state.message,
          'message',
          'Club updated successfully',
        ),
      ],
    );

    blocTest<ClubBloc, ClubState>(
      'emits [ClubLoading, ClubOperationSuccess] when club is deleted',
      build: () => ClubBloc(clubRepository: FakeClubRepository()),
      act: (bloc) => bloc.add(const DeleteClub(clubId: 1)),
      expect: () => [
        isA<ClubLoading>(),
        isA<ClubOperationSuccess>()
            .having((state) => state.club, 'club', null)
            .having(
              (state) => state.message,
          'message',
          'Club deleted successfully',
        ),
      ],
    );
  });
}
