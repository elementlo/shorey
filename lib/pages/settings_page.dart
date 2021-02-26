import 'package:flutter/material.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/24/21
/// Description:
///
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.secondaryVariant,
      child: Container(),
    );
  }
}
