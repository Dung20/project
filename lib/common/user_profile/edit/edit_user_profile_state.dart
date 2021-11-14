part of 'edit_user_profile_bloc.dart';

abstract class EditUserProfileState extends Equatable {
  const EditUserProfileState();

  @override
  List<Object> get props => [];
}

class EditUserProfileUninitialized extends EditUserProfileState {}

class EditUserProfileEditing extends EditUserProfileState {
  final UserProfile userProfile;

  EditUserProfileEditing({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

class EditUserProfileSubmitting extends EditUserProfileState {}

class EditUserProfileSuccess extends EditUserProfileState {}

class EditUserProfileFail extends EditUserProfileState {
  final String message;

  EditUserProfileFail({required this.message});

  @override
  List<Object> get props => [message];
}
