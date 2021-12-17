import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///

class ProviderWidget<T extends ChangeNotifier?> extends StatefulWidget {
  late T model;
  final Widget? child;
  final void Function(T model)? onModelReady;
  final bool autoDispose;

  ProviderWidget(
      {Key? key,
      required this.model,
      this.child,
      this.onModelReady,
      this.autoDispose = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier?>
    extends State<ProviderWidget<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    //if (widget.autoDispose == true) model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => model,
      child: widget.child,
    );
  }
}

class ProviderWidget2<A extends ChangeNotifier?, B extends ChangeNotifier?>
    extends StatefulWidget {
  late A model1;
  late B model2;
  final Widget? child;
  final void Function(A? model1, B? model2)? onModelReady;
  final bool? autoDispose;

  ProviderWidget2(
      @required this.model1,
      @required this.model2,
      {Key? key,
      this.child,
      this.onModelReady,
      this.autoDispose})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProviderWidgetState2<A, B>();
}

class _ProviderWidgetState2<A extends ChangeNotifier?,
    B extends ChangeNotifier?> extends State<ProviderWidget2<A, B>> {
  late A model1;
  late B model2;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;
    widget.onModelReady?.call(model1, model2);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose == true) {
      model1!.dispose();
      model2!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => model1,
        ),
        ChangeNotifierProvider(
          create: (_) => model2,
        ),
      ],
      child: widget.child,
    );
  }
}
