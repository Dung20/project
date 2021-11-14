import 'package:bloc/bloc.dart';
import 'package:neptune_app/common/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository}) : super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationAppStarted) {
      yield* _checkLogin();
    }

    if (event is AuthenticationLoggedIn) {
      yield AuthenticationAuthenticated();
    }

    if (event is AuthenticationLoggedOut) {
      await userRepository.logout();
      yield AuthenticationUnauthenticated();
      yield* _checkLogin();
    }
  }

  Stream<AuthenticationState> _checkLogin() async* {
    if (await userRepository.isLoggedIn()) {
      yield AuthenticationAuthenticated();
    } else {
      yield AuthenticationUnauthenticated();

      var success = false;
      while (!success) {
        success = await userRepository.startFirebaseUI();
      }

      yield AuthenticationAuthenticated();
    }
  }
}