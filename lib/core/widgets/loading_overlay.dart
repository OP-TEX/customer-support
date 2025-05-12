import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingIndicatorOverlay extends StatelessWidget {
  final bool inAsyncCall;

  final double opacity;

  final Color color;

  final Offset? offset;

  final bool dismissible;

  final Widget child;

  final double blur;

  const LoadingIndicatorOverlay({
    super.key,
    required this.inAsyncCall,
    this.opacity = 0.1,
    this.color = Colors.grey,
    this.offset,
    this.dismissible = false,
    required this.child,
    this.blur = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget layOutProgressIndicator;
    if (offset == null) {
      layOutProgressIndicator = Center(child: CircularProgressIndicator());
    } else {
      layOutProgressIndicator = Positioned(
        left: offset!.dx,
        top: offset!.dy,
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        child,
        if (inAsyncCall) ...[
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Opacity(
              opacity: opacity,
              child: ModalBarrier(dismissible: dismissible, color: color),
            ),
          ),
          layOutProgressIndicator,
        ],
      ],
    );
  }
}
