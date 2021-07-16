import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/24/21
/// Description:
///
class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Header(
      color: Theme.of(context).colorScheme.primaryVariant,
      text: 'Spark',
    );
  }
}

class Header extends StatelessWidget {
  const Header({this.color, this.text});

  final Color? color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 11,
      ),
      child: Text(
        text!,
        style: Theme.of(context).textTheme.headline4!.apply(
              color: color,
              fontSizeDelta: 0,
            ),
      ),
    );
  }
}
