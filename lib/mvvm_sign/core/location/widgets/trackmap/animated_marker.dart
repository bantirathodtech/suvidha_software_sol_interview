// lib/location/widgets/animated_marker.dart
import 'package:flutter/material.dart';

class AnimatedMarker extends StatelessWidget {
  final double size;
  final Color color;
  final bool isAnimated;
  final Widget? child;

  const AnimatedMarker({
    super.key,
    this.size = 40.0,
    this.color = Colors.blue,
    this.isAnimated = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
          width: isAnimated ? size * 0.6 : size * 0.8,
          height: isAnimated ? size * 0.6 : size * 0.8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
