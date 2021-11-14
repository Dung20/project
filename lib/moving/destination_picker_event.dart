part of 'destination_picker_bloc.dart';

abstract class DestinationPickerEvent extends Equatable {
  const DestinationPickerEvent();

  @override
  List<Object> get props => [];
}

class DestinationPickerLocationChanged extends DestinationPickerEvent {
  final LatLng location;

  DestinationPickerLocationChanged({required this.location});

  @override
  List<Object> get props => [location];
}

class DestinationPickerSubmitted extends DestinationPickerEvent {}
