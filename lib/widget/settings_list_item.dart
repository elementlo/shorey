import 'dart:collection';

import 'package:flutter/material.dart';

final settingItemBorderRadius = BorderRadius.circular(10);
const settingItemHeaderMargin = EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8);

class DisplayOption {
  final String title;
  final String? subtitle;

  DisplayOption(this.title, {this.subtitle});
}

class SettingsListItem<T> extends StatefulWidget {
  SettingsListItem({
    Key? key,
    required this.optionsMap,
    required this.title,
    required this.selectedOption,
    required this.onOptionChanged,
    required this.onTapSetting,
    required this.isExpanded,
    required this.child,
    this.showHeaderInfoButton = false,
    this.onToggleInfo,
  }) : super(key: key);

  final LinkedHashMap<T, DisplayOption> optionsMap;
  final String title;
  final T selectedOption;
  final ValueChanged<T> onOptionChanged;
  final Function onTapSetting;
  final bool isExpanded;
  final Widget child;
  final bool showHeaderInfoButton;
  final void Function(bool toggleState)? onToggleInfo;

  @override
  _SettingsListItemState createState() => _SettingsListItemState<T>();
}

class _SettingsListItemState<T> extends State<SettingsListItem<T>>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static const _expandDuration = Duration(milliseconds: 150);
  late AnimationController _controller;
  late Animation<double> _childrenHeightFactor;
  late Animation<double> _headerChevronRotation;
  late Animation<double> _headerSubtitleHeight;
  late Animation<EdgeInsetsGeometry> _headerMargin;
  late Animation<EdgeInsetsGeometry> _headerPadding;
  late Animation<EdgeInsetsGeometry> _childrenPadding;
  late Animation<BorderRadius?> _headerBorderRadius;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _expandDuration, vsync: this);
    _childrenHeightFactor = _controller.drive(_easeInTween);
    _headerChevronRotation =
        Tween<double>(begin: 0, end: 0.5).animate(_controller);
    _headerMargin = EdgeInsetsGeometryTween(
      begin: settingItemHeaderMargin,
      end: EdgeInsets.zero,
    ).animate(_controller);
    _headerPadding = EdgeInsetsGeometryTween(
      begin: const EdgeInsetsDirectional.fromSTEB(16, 10, 0, 10),
      end: const EdgeInsetsDirectional.fromSTEB(32, 18, 32, 20),
    ).animate(_controller);
    _headerSubtitleHeight =
        _controller.drive(Tween<double>(begin: 1.0, end: 0.0));
    _childrenPadding = EdgeInsetsGeometryTween(
      begin: const EdgeInsets.symmetric(horizontal: 32),
      end: EdgeInsets.zero,
    ).animate(_controller);
    _headerBorderRadius = BorderRadiusTween(
      begin: settingItemBorderRadius,
      end: BorderRadius.zero,
    ).animate(_controller);

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleExpansion() {
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse().then<void>((value) {
        if (!mounted) {
          return;
        }
      });
    }
  }

  Widget _buildHeaderWithChildren(BuildContext context, Widget? child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CategoryHeader(
          margin: _headerMargin.value,
          padding: _headerPadding.value,
          borderRadius: _headerBorderRadius.value ?? BorderRadius.circular(8),
          subtitleHeight: _headerSubtitleHeight,
          chevronRotation: _headerChevronRotation,
          title: widget.title,
          subtitle: widget.optionsMap[widget.selectedOption]?.title ?? '',
          showInfoButton: widget.showHeaderInfoButton,
          onToggleInfo: widget.onToggleInfo,
          onTap: () => widget.onTapSetting(),
        ),
        Padding(
          padding: _childrenPadding.value,
          child: ClipRect(
            child: Align(
              heightFactor: _childrenHeightFactor.value,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _handleExpansion();
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildHeaderWithChildren,
      child: Container(
          constraints: const BoxConstraints(maxHeight: 460),
          color: colorScheme.secondaryVariant,
          margin: const EdgeInsetsDirectional.only(bottom: 40),
          padding:
              const EdgeInsetsDirectional.only(start: 24, end: 24, bottom: 0),
          child: widget.child
          //CustomizedDatePicker([])
          ),
    );
  }
}

class _CategoryHeader extends StatefulWidget {
   _CategoryHeader({
    Key? key,
    this.margin,
    required this.padding,
    required this.borderRadius,
    required this.subtitleHeight,
    required this.chevronRotation,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showInfoButton = false,
    this.onToggleInfo,
  }) : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final String title;
  final String? subtitle;
  final Animation<double> subtitleHeight;
  final Animation<double> chevronRotation;
  final GestureTapCallback? onTap;
  final bool showInfoButton;
  final void Function(bool toggleState)? onToggleInfo;

  @override
  State<_CategoryHeader> createState() => _CategoryHeaderState();
}

class _CategoryHeaderState extends State<_CategoryHeader> {
  var _toggledState = false;
  var _showInfoButton = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: widget.margin,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: widget.borderRadius),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: (){
            _showInfoButton = !_showInfoButton;
            setState(() {});
            widget.onTap?.call();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: widget.padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      SizeTransition(
                        sizeFactor: widget.subtitleHeight,
                        child: Text(
                          widget.subtitle ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.overline?.apply(
                            color: colorScheme.primaryVariant,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 8,
                  end: 24,
                ),
                child: Row(
                  children: [
                    if (widget.showInfoButton&&_showInfoButton)
                      IconButton(
                        onPressed: () {
                          _toggledState = !_toggledState;
                          setState(() {});
                          widget.onToggleInfo?.call(_toggledState);
                        },
                        icon: Icon(Icons.info_rounded,
                            size: 20,
                            color: !_toggledState
                                ? colorScheme.onSurface
                                : colorScheme.onSecondary),
                      ),
                    RotationTransition(
                      turns: widget.chevronRotation,
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimateSettingsListItems extends StatelessWidget {
  const AnimateSettingsListItems({
    Key? key,
    required this.animation,
    required this.children,
  }) : super(key: key);

  final Animation<double> animation;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final dividingPadding = 4.0;
    final topPaddingTween = Tween<double>(
      begin: 0,
      end: children.length * dividingPadding,
    );
    final dividerTween = Tween<double>(
      begin: 0,
      end: dividingPadding,
    );

    return Padding(
      padding: EdgeInsets.only(top: topPaddingTween.animate(animation).value),
      child: Column(
        children: [
          for (Widget child in children)
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: dividerTween.animate(animation).value,
                  ),
                  child: child,
                );
              },
              child: child,
            ),
        ],
      ),
    );
  }
}