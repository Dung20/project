part of 'notifier_bloc.dart';

abstract class NotifierState extends Equatable {
  const NotifierState();

  @override
  List<Object> get props => [];
}

class NotifierIdle extends NotifierState {}

class NotifierOnApproach extends NotifierState {
  final double distance;
  final double seconds;

  const NotifierOnApproach({required this.distance, required this.seconds});

  @override
  List<Object> get props => [distance, seconds];
}
