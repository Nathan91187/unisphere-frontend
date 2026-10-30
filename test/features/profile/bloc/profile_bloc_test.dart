import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uni_sphere/features/profile/domain/entities/profile_user.dart';
import 'package:uni_sphere/features/profile/domain/repository/profile_repository.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_event.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_state.dart';

class FakeProfileRepository implements ProfileRepository {
  final bool shouldFail;
  final ProfileUser profile;

  FakeProfileRepository({this.shouldFail = false, required this.profile});

  @override
  Future<ProfileUser> getProfileByUid({required String uid}) async {
    if (shouldFail) {
      throw Exception('Failed to fetch profile');
    }
    return profile;
  }

  @override
  Future<ProfileUser> createProfile({
    required String displayName,
    String? profileImageUrl,
  }) async {
    if (shouldFail) {
      throw Exception('Failed to create profile');
    }
    return profile;
  }

  @override
  Future<ProfileUser> updateProfile({
    required String displayName,
    String? profileImageUrl,
  }) async {
    if (shouldFail) {
      throw Exception('Failed to update profile');
    }
    return profile;
  }

  @override
  Future<void> deleteProfile() async {
    if (shouldFail) {
      throw Exception('Failed to delete profile');
    }
  }
}

ProfileUser createSampleProfile() {
  return const ProfileUser(
    uid: 'user-1',
    email: 'test@example.com',
    displayName: 'Test User',
    profileImageUrl: null,
  );
}

void main() {
  // GET PROFILE

  blocTest<ProfileBloc, ProfileState>(
    'emits loading then loaded with fetched profile',
    build: () => ProfileBloc(
      profileRepository: FakeProfileRepository(profile: createSampleProfile()),
    ),
    act: (bloc) => bloc.add(const GetProfileByUid(uid: 'user-1')),
    expect: () => [
      isA<ProfileLoading>(),
      isA<ProfileLoaded>()
          .having((state) => state.profileUser.uid, 'profile uid', 'user-1')
          .having(
            (state) => state.profileUser.displayName,
            'display name',
            'Test User',
          ),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits loading then error when fetching profile fails',
    build: () => ProfileBloc(
      profileRepository: FakeProfileRepository(
        shouldFail: true,
        profile: createSampleProfile(),
      ),
    ),
    act: (bloc) => bloc.add(const GetProfileByUid(uid: 'user-1')),
    expect: () => [isA<ProfileLoading>(), isA<ProfileError>()],
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits loading then loaded when profile is created',
    build: () => ProfileBloc(
      profileRepository: FakeProfileRepository(profile: createSampleProfile()),
    ),
    act: (bloc) => bloc.add(const CreateProfile(displayName: 'Test User')),
    expect: () => [isA<ProfileLoading>(), isA<ProfileLoaded>()],
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits loading then error when profile creation fails',
    build: () => ProfileBloc(
      profileRepository: FakeProfileRepository(
        shouldFail: true,
        profile: createSampleProfile(),
      ),
    ),
    act: (bloc) => bloc.add(const CreateProfile(displayName: 'Test User')),
    expect: () => [isA<ProfileLoading>(), isA<ProfileError>()],
  );


  blocTest<ProfileBloc, ProfileState>(
    'emits loading then loaded when profile is updated',
    build: () => ProfileBloc(
      profileRepository: FakeProfileRepository(profile: createSampleProfile()),
    ),
    act: (bloc) => bloc.add(const UpdateProfile(displayName: 'Updated User')),
    expect: () => [isA<ProfileLoading>(), isA<ProfileLoaded>()],
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits loading then error when profile update fails',
    build: () => ProfileBloc(
      profileRepository: FakeProfileRepository(
        shouldFail: true,
        profile: createSampleProfile(),
      ),
    ),
    act: (bloc) => bloc.add(const UpdateProfile(displayName: 'Updated User')),
    expect: () => [isA<ProfileLoading>(), isA<ProfileError>()],
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits loading then deleted when profile is deleted',
    build: () => ProfileBloc(
      profileRepository: FakeProfileRepository(profile: createSampleProfile()),
    ),
    act: (bloc) => bloc.add(const DeleteProfile()),
    expect: () => [isA<ProfileLoading>(), isA<ProfileDeleted>()],
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits loading then error when profile deletion fails',
    build: () => ProfileBloc(
      profileRepository: FakeProfileRepository(
        shouldFail: true,
        profile: createSampleProfile(),
      ),
    ),
    act: (bloc) => bloc.add(const DeleteProfile()),
    expect: () => [isA<ProfileLoading>(), isA<ProfileError>()],
  );
}
