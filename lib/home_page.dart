import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neptune_app/common/loading_screen.dart';
import 'package:neptune_app/common/user_profile/edit/first_time_type_picker_page.dart';
import 'package:neptune_app/common/user_profile/user_profile.dart';
import 'package:neptune_app/common/user_profile/user_profile_bloc.dart';
import 'package:neptune_app/moving/home_page.dart';
import 'package:neptune_app/parking/home_page.dart';

import 'common/authentication/authentication_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        BlocProvider.of<UserProfileBloc>(context); // TODO: hack

        if (state is AuthenticationUnauthenticated || state is AuthenticationUninitialized) {
          return LoadingScreen();
        }
        return _buildFirstTimePicker();
      },
    );
  }

  Widget _buildFirstTimePicker() {
    return BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state) {
      if (state is UserProfileUninitialized) {
        return LoadingScreen();
      }
      if (state is UserProfileNotFound) {
        return FirstTimeTypePickerPage();
      }
      var stateLoaded = state as UserProfileLoaded;
      switch (state.userProfile.userType) {
        case UserType.moving:
          return MovingHomePage();
        case UserType.parking:
          return ParkingHomePage();
      }
    });
  }
}
