import 'package:flutter/material.dart';

class Glow extends StatelessWidget {
   Glow({required this.child,Key? key}) : super(key: key);
   Widget child;
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Colors.white,
          child: child,
        ));
  }
}
