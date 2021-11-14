import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neptune_app/common/constants.dart';
import 'package:neptune_app/common/repositories/user_repository.dart';
import 'package:neptune_app/common/repositories/vehicle_repository.dart';
import 'package:neptune_app/common/util/location_info.dart';
import 'package:neptune_app/common/util/location_util.dart';

part 'location_recorder_event.dart';
part 'location_recorder_state.dart';

class LocationRecorderBloc extends Bloc<LocationRecorderEvent, LocationRecorderState> {
  final VehicleRepository vehicleRepository;
  final UserRepository userRepository;
  StreamSubscription<LocationInfo>? _locationSub;
  StreamSubscription<void>? _timerSub;

  LocationRecorderBloc({
    required this.vehicleRepository,
    required this.userRepository
  }) : super(LocationRecorderUntracked()) {

  }

  @override
  Future<void> close() {
    _locationSub?.cancel();
    _timerSub?.cancel();
    return super.close();
  }

  @override
  Stream<LocationRecorderState> mapEventToState(
    LocationRecorderEvent event,
  ) async* {
    if (event is LocationRecorderStarted) {
      _locationSub = LocationUtil.getLocationInfoStream().listen((l) =>
          add(LocationRecorderUpdated(location: l)));
      _timerSub = Stream.periodic(parkingRefreshRate).listen((_) {
        if (state is LocationRecorderParked) {
          vehicleRepository.updateParkedVehicle(
            user: userRepository.currentUser()!,
            location: (state as LocationRecorderParked).locationInfo.location,
          );
        }
      });
    }
    if (event is LocationRecorderUpdated) {
      var locationInfo = event.location;
      if (locationInfo.speed < parkingMinimumStationarySpeed) {
        yield LocationRecorderParked(locationInfo: locationInfo);
      } else {
        _cancelTimerAndStale();
        yield LocationRecorderMoving(locationInfo: locationInfo);
      }
    }
    if (event is LocationRecorderDisabled) {
      _locationSub?.cancel();
      _cancelTimerAndStale();
      yield LocationRecorderUntracked();
    }
  }

  Future<void> _cancelTimerAndStale() async {
    _timerSub?.cancel();
    _timerSub = null;
    await vehicleRepository.removeVehicle(
      user: userRepository.currentUser()!,
    );
  }
}
