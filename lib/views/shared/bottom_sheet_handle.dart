import 'package:flutter/material.dart';

class BottomSheetHandle extends StatelessWidget {
  final double width;
  final double height;

  const BottomSheetHandle({
    super.key,
    this.width = 40,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
