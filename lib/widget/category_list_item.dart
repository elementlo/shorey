import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/8/21
/// Description: 
///

typedef CategoryHeaderTapCallback = Function(bool shouldOpenList);

class CategoryListItem extends StatefulWidget {
	const CategoryListItem({
		Key key,
		this.restorationId,
		this.category,
		this.imageString,
		this.demos = const [''],
		this.initiallyExpanded = false,
		this.onTap,
	})  : assert(initiallyExpanded != null),
				super(key: key);
	
	//final GalleryDemoCategory category;
	final String category;
	final String restorationId;
	final String imageString;
	//final List<GalleryDemo> demos;
	final List<String> demos;
	final bool initiallyExpanded;
	final CategoryHeaderTapCallback onTap;
	
	@override
	_CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem>
		with SingleTickerProviderStateMixin {
	static final Animatable<double> _easeInTween =
	CurveTween(curve: Curves.easeIn);
	static const _expandDuration = Duration(milliseconds: 200);
	AnimationController _controller;
	Animation<double> _childrenHeightFactor;
	Animation<double> _headerChevronOpacity;
	Animation<double> _headerHeight;
	Animation<EdgeInsetsGeometry> _headerMargin;
	Animation<EdgeInsetsGeometry> _headerImagePadding;
	Animation<EdgeInsetsGeometry> _childrenPadding;
	Animation<BorderRadius> _headerBorderRadius;
	
	@override
	void initState() {
		super.initState();
		
		_controller = AnimationController(duration: _expandDuration, vsync: this);
		_controller.addStatusListener((status) {
			setState(() {});
		});
		
		_childrenHeightFactor = _controller.drive(_easeInTween);
		_headerChevronOpacity = _controller.drive(_easeInTween);
		_headerHeight = Tween<double>(
			begin: 55,
			end: 76,
		).animate(_controller);
		_headerMargin = EdgeInsetsGeometryTween(
			begin: const EdgeInsets.fromLTRB(32, 8, 32, 8),
			end: EdgeInsets.zero,
		).animate(_controller);
		_headerImagePadding = EdgeInsetsGeometryTween(
			begin: const EdgeInsets.all(8),
			end: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
		).animate(_controller);
		_childrenPadding = EdgeInsetsGeometryTween(
			begin: const EdgeInsets.symmetric(horizontal: 32),
			end: EdgeInsets.zero,
		).animate(_controller);
		_headerBorderRadius = BorderRadiusTween(
			begin: BorderRadius.circular(10),
			end: BorderRadius.zero,
		).animate(_controller);
		
		if (widget.initiallyExpanded) {
			_controller.value = 1.0;
		}
	}
	
	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}
	
	bool _shouldOpenList() {
		switch (_controller.status) {
			case AnimationStatus.completed:
			case AnimationStatus.forward:
				return false;
			case AnimationStatus.dismissed:
			case AnimationStatus.reverse:
				return true;
		}
		assert(false);
		return null;
	}
	
	void _handleTap() {
		if (_shouldOpenList()) {
			_controller.forward();
			if (widget.onTap != null) {
				widget.onTap(true);
			}
		} else {
			_controller.reverse();
			if (widget.onTap != null) {
				widget.onTap(false);
			}
		}
	}
	
	Widget _buildHeaderWithChildren(BuildContext context, Widget child) {
		return Column(
			mainAxisSize: MainAxisSize.min,
			children: [
				_CategoryHeader(
					margin: _headerMargin.value,
					imagePadding: _headerImagePadding.value,
					borderRadius: _headerBorderRadius.value,
					height: _headerHeight.value,
					chevronOpacity: _headerChevronOpacity.value,
					imageString: widget.imageString,
					category: widget.category,
					onTap: _handleTap,
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
		return AnimatedBuilder(
			animation: _controller.view,
			builder: _buildHeaderWithChildren,
			child: _shouldOpenList()
					? null
					: _ExpandedCategoryDemos(
				category: widget.category,
				demos: widget.demos,
			),
		);
	}
}

class _ExpandedCategoryDemos extends StatelessWidget {
	const _ExpandedCategoryDemos({
		Key key,
		this.category,
		this.demos,
	}) : super(key: key);
	//
	// final GalleryDemoCategory category;
	final String category;
	// final List<GalleryDemo> demos;
	final List<String> demos;
	
	@override
	Widget build(BuildContext context) {
		return Column(
			// Makes integration tests possible.
			key: ValueKey('${category}DemoList'),
			children: [
				for (final demo in demos)
					CategoryDemoItem(
						demo: demo,
					),
				const SizedBox(height: 12), // Extra space below.
			],
		);
	}
}

class _CategoryHeader extends StatelessWidget {
	const _CategoryHeader({
		Key key,
		this.margin,
		this.imagePadding,
		this.borderRadius,
		this.height,
		this.chevronOpacity,
		this.imageString,
		this.category,
		this.onTap,
	}) : super(key: key);
	
	final EdgeInsetsGeometry margin;
	final EdgeInsetsGeometry imagePadding;
	final double height;
	final BorderRadiusGeometry borderRadius;
	final String imageString;
	final String category;
	final double chevronOpacity;
	final GestureTapCallback onTap;
	
	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;
		return Container(
			height: height,
			margin: margin,
			child: Material(
				shape: RoundedRectangleBorder(borderRadius: borderRadius),
				color: colorScheme.onBackground,
				clipBehavior: Clip.antiAlias,
				child: Container(
					width: MediaQuery.of(context).size.width,
					child: InkWell(
						// Makes integration tests possible.
						key: ValueKey('${category}CategoryHeader'),
						onTap: onTap,
						child: Row(
							children: [
								Expanded(
									child: Wrap(
										crossAxisAlignment: WrapCrossAlignment.center,
										children: [
											Padding(
												padding: imagePadding,
												child: ExcludeSemantics(
													child: Image.asset(
														imageString,
														width: 40,
														height: 40,
													),
												),
											),
											Padding(
												padding: const EdgeInsetsDirectional.only(start: 8),
												child: Text(
													category,
													style: Theme.of(context).textTheme.headline5.apply(
														color: colorScheme.onSurface,
													),
												),
											),
										],
									),
								),
								Opacity(
									opacity: chevronOpacity,
									child: chevronOpacity != 0
											? Padding(
										padding: const EdgeInsetsDirectional.only(
											start: 8,
											end: 32,
										),
										child: Icon(
											Icons.keyboard_arrow_up,
											color: colorScheme.onSurface,
										),
									)
											: null,
								),
							],
						),
					),
				),
			),
		);
	}
}

class CategoryDemoItem extends StatelessWidget {
	const CategoryDemoItem({Key key, this.demo}) : super(key: key);
	
	final String demo;
	
	@override
	Widget build(BuildContext context) {
		final textTheme = Theme.of(context).textTheme;
		final colorScheme = Theme.of(context).colorScheme;
		return Material(
			// Makes integration tests possible.
			key: ValueKey(demo),
			color: Theme.of(context).colorScheme.surface,
			child: InkWell(
				onTap: () {
	
				},
				child: Padding(
					padding: EdgeInsetsDirectional.only(
						start: 32,
						top: 20,
						end: 8,
					),
					child: Row(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Icon(
								Icons.build,
								color: colorScheme.primary,
							),
							const SizedBox(width: 40),
							Flexible(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											demo,
											style: textTheme.subtitle1
													.apply(color: colorScheme.onSurface),
										),
										Text(
											demo,
											style: textTheme.overline.apply(
												color: colorScheme.onSurface.withOpacity(0.5),
											),
										),
										const SizedBox(height: 20),
										Divider(
											thickness: 1,
											height: 1,
											color: Theme.of(context).colorScheme.background,
										),
									],
								),
							),
						],
					),
				),
			),
		);
	}
}