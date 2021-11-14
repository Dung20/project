import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neptune_app/common/repositories/user_repository.dart';
import 'package:neptune_app/common/user_profile/user_profile.dart';

part 'edit_user_profile_event.dart';
part 'edit_user_profile_state.dart';

class EditUserProfileBloc extends Bloc<EditUserProfileEvent, EditUserProfileState> {
  final UserRepository userRepository;

  EditUserProfileBloc({required this.userRepository}) : super(EditUserProfileUninitialized());

  @override
  Stream<EditUserProfileState> mapEventToState(
    EditUserProfileEvent event,
  ) async* {
    if (state is EditUserProfileUninitialized) {
      if (event is EditUserProfileInitialized) {
        yield EditUserProfileEditing(userProfile: event.userProfile);
      }
    }
    if (state is EditUserProfileEditing) {
      var stateEditing = state as EditUserProfileEditing;

      if (event is EditUserProfileTypeChanged) {
        yield EditUserProfileEditing(userProfile: stateEditing.userProfile.withUserType(event.userType));
      }

      if (event is EditUserProfileSubmitted) {
        yield EditUserProfileSubmitting();
        var success = await userRepository.setUserProfile(stateEditing.userProfile);
        if (success) {
          yield EditUserProfileSuccess();
        } else {
          yield EditUserProfileFail(message: 'Edit user profile failed'); // TODO: validation
        }
      }
    }
  }
}
