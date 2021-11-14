import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:neptune_app/common/authentication/authentication_bloc.dart';
import 'package:neptune_app/common/util/location_info.dart';
import 'package:neptune_app/common/util/location_util.dart';
import 'package:neptune_app/parking/location_recorder_bloc.dart';

class ParkingHomePage extends StatefulWidget {
  ParkingHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ParkingHomeState();
  }
}

class _ParkingHomeState extends State<StatefulWidget> {
  Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<LocationInfo>? _locationSub;
  LocationInfo? _locationInfo;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _locationSub = LocationUtil.getLocationInfoStream().listen((l) async {
      _locationInfo = l;

      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId('user'),
        position: l.location.toGoogleMapsType(),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));

      var controller = await _controller.future;
      controller.moveCamera(CameraUpdate.newLatLng(l.location.toGoogleMapsType()));

      setState(() {});
    });
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'CARlert',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                BlocProvider.of<LocationRecorderBloc>(context).add(LocationRecorderDisabled());
                BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<LocationRecorderBloc, LocationRecorderState>(
        builder: (context, state) {
          return Container(
            child: Column(
              children: [
                if (state is LocationRecorderUntracked) ElevatedButton(
                    onPressed: () => BlocProvider.of<LocationRecorderBloc>(context).add(LocationRecorderStarted()),
                    child: Text('Start'),
                ) else ElevatedButton(
                    onPressed: () => BlocProvider.of<LocationRecorderBloc>(context).add(LocationRecorderDisabled()),
                    child: Text('Stop'),
                ),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LocationUtil.kmuttLatLng.toGoogleMapsType(),
                      zoom: 16.0,
                    ),
                    onMapCreated: (controller) => _controller.complete(controller),
                    markers: _markers,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
