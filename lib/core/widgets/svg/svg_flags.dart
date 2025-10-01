import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgFlag extends StatelessWidget {
  final String assetPath;
  final double radius;

  const SvgFlag({
    super.key,
    required this.assetPath,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: SvgPicture.asset(
        assetPath,
        width: radius,
        height: radius,
      ),
    );
  }
}
