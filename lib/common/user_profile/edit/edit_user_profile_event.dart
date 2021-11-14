part of 'edit_user_profile_bloc.dart';

abstract class EditUserProfileEvent extends Equatable {
  const EditUserProfileEvent();

  @override
  List<Object> get props => [];
}

class EditUserProfileInitialized extends EditUserProfileEvent {
  final UserProfile userProfile;

  EditUserProfileInitialized({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

class EditUserProfileTypeChanged extends EditUserProfileEvent {
  final UserType userType;

  const EditUserProfileTypeChanged({required this.userType});

  @override
  List<Object> get props => [userType];
}

class EditUserProfileSubmitted extends EditUserProfileEvent {}
