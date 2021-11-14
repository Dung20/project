import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifier_bloc.dart';

class ColorNotifierBox extends StatelessWidget {
  final Color colorSafe;
  final Color colorOnApproach;

  ColorNotifierBox({
    required this.colorSafe,
    required this.colorOnApproach,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotifierBloc, NotifierState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: state is NotifierOnApproach ? colorOnApproach : colorSafe,
          ),
          width: 150,
          height: 80,
          child: state is NotifierOnApproach ? _buildTimeText(context, state.seconds) : null,
        );
      },
    );
  }

  Widget _buildTimeText(BuildContext context, double seconds) {
    return Center(
      child: Text(
        '${seconds.toInt()}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }
}