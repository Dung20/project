import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neptune_app/common/constants.dart';
import 'package:neptune_app/moving/rendezvous_tracker_bloc.dart';

part 'notifier_event.dart';
part 'notifier_state.dart';

class NotifierBloc extends Bloc<NotifierEvent, NotifierState> {
  final RendezvousTrackerBloc rendezvousTrackerBloc;
  late final StreamSubscription<RendezvousTrackerState> _sub;
  Timer? _timer;

  NotifierBloc({required this.rendezvousTrackerBloc}) : super(NotifierIdle()) {
    _sub = rendezvousTrackerBloc.stream.listen((state) => _trackerHandler(state));
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }

  @override
  Stream<NotifierState> mapEventToState(
    NotifierEvent event,
  ) async* {
    if (event is NotifierPassed) {
      _timer?.cancel();
      yield NotifierIdle();
    }
    if (event is NotifierApproachNotified) {
      _timer?.cancel();

      if (event.seconds > movingNotifierRefreshPeriod) {
        // TODO: more accurate timing
        _timer = Timer(
            Duration(
              milliseconds: (movingNotifierRefreshPeriod * 1000).toInt(),
            ), () =>
            add(NotifierApproachNotified(
              distance: event.distance,
              seconds: event.seconds - movingNotifierRefreshPeriod,
            ))
        );
      }

      yield NotifierOnApproach(
        distance: event.distance,
        seconds: event.seconds,
      );
    }
  }

  void _trackerHandler(RendezvousTrackerState state) {
    if (state is RendezvousTrackerTracking) {
      var potentials = state.vehicles.where((v) => v.time <= movingMaximumTimeBeforeAlertDefault).toList(); // TODO: move const to UserProfile
      if (potentials.isEmpty) {
        add(NotifierPassed());
        return;
      }

      potentials.sort((a, b) => -a.time.compareTo(b.time));
      var min = potentials.first;
      add(NotifierApproachNotified(
          distance: min.distance,
          seconds: min.time,
      ));
    }
  }
}
