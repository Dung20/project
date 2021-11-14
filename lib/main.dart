import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:neptune_app/common/api/open_route_service_api.dart';
import 'package:neptune_app/common/constants.dart';
import 'package:neptune_app/common/repositories/route_repository.dart';
import 'package:neptune_app/common/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neptune_app/common/repositories/vehicle_repository.dart';
import 'package:neptune_app/common/user_profile/edit/edit_user_profile_bloc.dart';
import 'package:neptune_app/common/user_profile/user_profile_bloc.dart';
import 'package:neptune_app/home_page.dart';
import 'package:neptune_app/moving/notifier/notifier_bloc.dart';
import 'package:neptune_app/moving/rendezvous_tracker_bloc.dart';
import 'package:neptune_app/moving/tracking_page.dart';
import 'package:neptune_app/parking/home_page.dart';
import 'package:neptune_app/parking/location_recorder_bloc.dart';

import 'common/authentication/authentication_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var firebase = await Firebase.initializeApp();
  var firestore = FirebaseFirestore.instanceFor(app: firebase);
  var firebaseAuth = FirebaseAuth.instance;
  var geoflutterfire = Geoflutterfire();

  final userRepository = UserRepository(
      firebaseAuth: firebaseAuth,
      firestore: firestore,
  );

  final vehicleRepository = VehicleRepository(
      firestore: firestore,
      geoflutterfire: geoflutterfire,
  );
  
  final routeRepository = RouteRepository(
      OpenRouteServiceApi(movingRouteServiceApiKey));

  // var authBloc = AuthenticationBloc(userRepository: userRepository)..add(AuthenticationAppStarted());

  // Future.delayed(Duration(seconds: 10)).whenComplete(() => authBloc.add(AuthenticationAppStarted()));

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc(userRepository: userRepository)),
        BlocProvider(
          create: (context) => UserProfileBloc(authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        ),
        BlocProvider(
          create: (context) => EditUserProfileBloc(userRepository: userRepository),
        ),
        BlocProvider(
          create: (context) => LocationRecorderBloc(userRepository: userRepository, vehicleRepository: vehicleRepository),
        ),
        BlocProvider(
          create: (context) => RendezvousTrackerBloc(routeRepository: routeRepository, vehicleRepository: vehicleRepository),
        ),
        BlocProvider(
          create: (context) => NotifierBloc(rendezvousTrackerBloc: BlocProvider.of<RendezvousTrackerBloc>(context)),
        ),
      ],
      child: App(userRepository: userRepository),
    )
  );
}

class App extends StatelessWidget {
  final UserRepository userRepository;

  const App({Key? key, required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       title: 'CARlert',

      routes: {
        '/': (context) => HomePage(),
        '/moving/tracking': (context) => TrackingPage(),
        '/parking': (context) => ParkingHomePage(),
      },
    );
  }
}
