import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:neptune_app/common/util/latlng.dart';
import 'package:neptune_app/common/util/location_util.dart';
import 'package:neptune_app/moving/notifier/color_notifier_box.dart';
import 'package:neptune_app/moving/rendezvous_tracker_bloc.dart';


class TrackingPage extends StatefulWidget {
  TrackingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TrackingPageState();
  }
}

class _TrackingPageState extends State<StatefulWidget> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  double _speed = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RendezvousTrackerBloc, RendezvousTrackerState>(
      listener: (context, state) async {
        if (state is RendezvousTrackerTracking) {
          _speed = state.speed;

          _markers.clear();
          _polylines.clear();

          _markers.add(Marker(
            markerId: MarkerId('user'),
            position: state.route.first.toGoogleMapsType(),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ));

          _markers.add(Marker(
            markerId: MarkerId('dest'),
            position: state.route.last.toGoogleMapsType(),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ));

          for (var i = 0; i < state.vehicles.length; i++) {
            var v = state.vehicles[i];
            _markers.add(Marker(
              markerId: MarkerId('vehicle_$i'),
              position: v.location.toGoogleMapsType(),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
            ));
          }

          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: state.route.toGoogleMapsType(),
            color: Colors.blue,
            width: 5,
          ));

          var controller = await _controller.future;
          controller.moveCamera(CameraUpdate.newLatLng(state.route.first.toGoogleMapsType()));

          setState(() {});
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Vehicles Map'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                ColorNotifierBox(
                    colorSafe: Colors.green,
                    colorOnApproach: Colors.red
                ),
                Expanded(
                  child: Text(
                    'Speed: ${_speed * 18 ~/ 5} km/h',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LocationUtil.kmuttLatLng.toGoogleMapsType(),
                  zoom: 16.0,
                ),
                onMapCreated: (controller) => _controller.complete(controller),
                markers: _markers,
                polylines: _polylines,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
