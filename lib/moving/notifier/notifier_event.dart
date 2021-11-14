part of 'notifier_bloc.dart';

abstract class NotifierEvent extends Equatable {
  const NotifierEvent();

  @override
  List<Object> get props => [];
}

class NotifierPassed extends NotifierEvent {}

class NotifierApproachNotified extends NotifierEvent {
  final double distance;
  final double seconds;

  const NotifierApproachNotified({required this.distance, required this.seconds});

  @override
  List<Object> get props => [distance, seconds];
}
