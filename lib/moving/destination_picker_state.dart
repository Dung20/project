part of 'destination_picker_bloc.dart';

abstract class DestinationPickerState extends Equatable {
  const DestinationPickerState();

  @override
  List<Object> get props => [];
}

class DestinationPickerInitial extends DestinationPickerState {}

class DestinationPickerSelect extends DestinationPickerState {
  final LatLng location;

  DestinationPickerSelect({required this.location});

  @override
  List<Object> get props => [location];
}

class DestinationPickerSubmit extends DestinationPickerState {
  final LatLng location;

  DestinationPickerSubmit({required this.location});

  @override
  List<Object> get props => [location];
}
