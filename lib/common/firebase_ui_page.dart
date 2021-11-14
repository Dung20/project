import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neptune_app/common/loading_screen.dart';
import 'authentication/authentication_bloc.dart';
import 'repositories/user_repository.dart';

class FirebaseUiPage extends StatelessWidget {
  final UserRepository userRepository;

  const FirebaseUiPage({Key? key, required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return BlocListener<AuthenticationBloc, AuthenticationState>(
    //   listener: (context, state) async {
    //     if (state is AuthenticationUnauthenticated) {
    //       var success = await userRepository.startFirebaseUI();
    //       if (success) {
    //         BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedIn());
    //       }
    //     }
    //     if (state is AuthenticationAuthenticated) {
    //       Navigator.pushNamedAndRemoveUntil(context, '/parking', (r) => false);
    //     }
    //   },
    //   child: LoadingScreen(),
    // );
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, '/parking', (r) => false);
        }
      },
      builder: (context, state) {
        return FutureBuilder(
          future: userRepository.startFirebaseUI(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data as bool) {
                BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedIn());
              } else {
                return Text('test');
              }
            }

            return Container();
          },
        );
      },
    );
  }
}
