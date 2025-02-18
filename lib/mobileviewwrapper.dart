import 'package:flutter/material.dart';

class MobileViewWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MobileViewWrapper({
    Key? key,
    required this.child,
    this.maxWidth = 400, // กำหนดค่า default ให้ 400px
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
