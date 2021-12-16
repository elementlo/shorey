import 'package:flutter/material.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/12/15
/// Description:
///

class RoundCornerRectangle extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  RoundCornerRectangle(
      {Key? key,
      required this.child,
      this.width,
      this.height,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: child,
      padding: padding,
      margin: margin,
    );
  }
}
