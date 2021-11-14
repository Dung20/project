import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neptune_app/common/util/latlng.dart';

part 'destination_picker_event.dart';
part 'destination_picker_state.dart';

class DestinationPickerBloc extends Bloc<DestinationPickerEvent, DestinationPickerState> {
  DestinationPickerBloc() : super(DestinationPickerInitial());

  @override
  Stream<DestinationPickerState> mapEventToState(
    DestinationPickerEvent event,
  ) async* {
    if (event is DestinationPickerLocationChanged) {
      yield DestinationPickerSelect(location: event.location);
    }
    if (event is DestinationPickerSubmitted) {
      yield DestinationPickerSubmit(location: (state as DestinationPickerSelect).location);
    }
  }
}
