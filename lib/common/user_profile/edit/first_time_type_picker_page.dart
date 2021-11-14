import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neptune_app/common/user_profile/edit/edit_user_profile_bloc.dart';
import 'package:neptune_app/common/user_profile/user_profile.dart';

class FirstTimeTypePickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<EditUserProfileBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your usage'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Normal driver'),
            onTap: () {
              bloc.add(EditUserProfileInitialized(userProfile: UserProfile.getDefault()));
              bloc.add(EditUserProfileTypeChanged(userType: UserType.moving));
              bloc.add(EditUserProfileSubmitted());
            },
          ),
          ListTile(
            title: const Text('Truck driver'),
            onTap: () {
              bloc.add(EditUserProfileInitialized(userProfile: UserProfile.getDefault()));
              bloc.add(EditUserProfileTypeChanged(userType: UserType.parking));
              bloc.add(EditUserProfileSubmitted());
            },
          ),
        ],
      ),
    );
  }
}
