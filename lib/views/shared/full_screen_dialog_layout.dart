import 'package:flutter/material.dart';

class FullScreenDialogLayout extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;
  final Color backgroundColor;

  const FullScreenDialogLayout({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(24.0),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          ),
        ),
      ),
    );
  }
}
