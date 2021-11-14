import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neptune_app/common/authentication/authentication_bloc.dart';
import 'package:neptune_app/common/constants.dart';
import 'package:neptune_app/common/util/latlng.dart';
import 'package:neptune_app/moving/rendezvous_tracker_bloc.dart';
import 'package:neptune_app/parking/location_recorder_bloc.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

class MovingHomePage extends StatefulWidget {
  MovingHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MovingHomeState();
  }
}

class _MovingHomeState extends State<StatefulWidget> {
  LocationResult? _selectedDest;

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: ElevatedButton(
                    child: Text('Choose or change destination'),
                    onPressed: () async {
                      var result = await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              PlacePicker(googleMapsApiKey)));
                      if (result != null && result is LocationResult) {
                        setState(() {
                          _selectedDest = result;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_selectedDest != null) _buildDestinationInfo(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDestinationInfo() {
    return Column(
      children: [
        Text(
          'Selected destination: ${_selectedDest!.name}',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          child: Text('Start monitoring'),
          onPressed: () {
            BlocProvider.of<RendezvousTrackerBloc>(context).add(RendezvousTrackerDestinationChose(
              destination: _selectedDest!.latLng!.toCommonType(),
            ));
            Navigator.pushNamed(context, '/moving/tracking').whenComplete(() =>
                BlocProvider.of<RendezvousTrackerBloc>(context).add(RendezvousTrackerStop()));
          },
        ),
      ],
    );
  }
}
