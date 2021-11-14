part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  final UserProfile? userProfile;

  const UserProfileEvent({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}

class UserProfileUpdated extends UserProfileEvent {
  UserProfileUpdated({required UserProfile? userProfile}) : super(userProfile: userProfile);
}
