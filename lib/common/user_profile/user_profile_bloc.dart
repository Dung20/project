import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neptune_app/common/authentication/authentication_bloc.dart';
import 'package:neptune_app/common/user_profile/user_profile.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final AuthenticationBloc authenticationBloc;
  StreamSubscription<UserProfile?>? _profileSubscription;
  late final StreamSubscription<AuthenticationState> _authSubscription;

  UserProfileBloc({required this.authenticationBloc}) : super(UserProfileUninitialized()) {
    _authSubscription = authenticationBloc.stream.listen((state) {
      if (state is AuthenticationAuthenticated) {
        _profileSubscription = authenticationBloc.userRepository.getCurrentProfileStream().listen((profile) {
          add(UserProfileUpdated(userProfile: profile));
        });
      }
      if (state is AuthenticationUnauthenticated) {
        _profileSubscription?.cancel();
        _profileSubscription = null;
        add(UserProfileUpdated(userProfile: null));
      }
    });

    authenticationBloc.add(AuthenticationAppStarted()); // TODO: remove hack
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _profileSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is UserProfileUpdated) {
      var profile = event.userProfile;
      if (profile == null) {
        yield UserProfileNotFound();
      } else {
        yield UserProfileLoaded(userProfile: profile);
      }
    }
  }
}
