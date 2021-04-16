import 'package:flutter/material.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/14/21
/// Description:
///

class SparkAppBar extends AppBar {
  SparkAppBar(
      {@required BuildContext context, String title, List<Widget> actions})
      : assert(context != null),
        super(
            title: Text('${title}'),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
            actions: [if (actions != null) ...actions]);
}
