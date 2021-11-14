import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Color(0xBB000000),
    ),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
