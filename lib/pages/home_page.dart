import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_list/widget/DailyFocusPanel.dart';
import 'package:spark_list/widget/category_list_item.dart';
import 'package:spark_list/widget/home_header.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/23/21
/// Description:
///
class HomePage extends StatefulWidget {
  AnimationController animationController;
  
  HomePage({Key key, this.title, @required this.animationController}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return _HomeScreen(widget.animationController);
  }
}

class _HomeScreen extends StatefulWidget {
  AnimationController animationController;

  _HomeScreen(this.animationController);
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  
  @override
  void initState() {
    widget.animationController?.forward();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.value = 1.0;
    // if (widget.isSplashPageAnimationFinished) {
    //   // To avoid the animation from running when changing the window size from
    //   // desktop to mobile, we do not animate our widget if the
    //   // splash page animation is finished on initState.
    //   _animationController.value = 1.0;
    // } else {
    //   // Start our animation halfway through the splash page animation.
    //   _launchTimer = Timer(
    //     const Duration(
    //       milliseconds: splashPageAnimationDurationInMilliseconds ~/ 2,
    //     ),
    //         () {
    //       _animationController.forward();
    //     },
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            restorationId: 'home_list_view',
            children: [
              const SizedBox(
                height: 8,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                child: HomeHeader(),
              ),
              DailyFocusPanel(
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / 9) * 1, 1.0,
                            curve: Curves.fastOutSlowIn))),
                animationController: widget.animationController,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                child: _CategoriesHeader(),
              ),
              _AnimatedCategoryItem(
                startDelayFraction: 0.00,
                controller: _animationController,
                child: CategoryListItem(
                    key: const PageStorageKey<String>(
                      'material',
                    ),
                    restorationId: 'home_material_category_list',
                    category: 'material',
                    imageString: 'assets/icons/material/material.png',
                    demos: ['1111', '2222'],
                    initiallyExpanded: false,
                    onTap: (shouldOpenList) {
                    
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _CategoriesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Header(
      color: Theme.of(context).colorScheme.primaryVariant,
      text: '类别',
    );
  }
}

class Header extends StatelessWidget {
  const Header({this.color, this.text});
  
  final Color color;
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 11,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline4.apply(
          color: color,
        ),
      ),
    );
  }
}

class _AnimatedCategoryItem extends StatelessWidget {
  _AnimatedCategoryItem({
    Key key,
    double startDelayFraction,
    @required this.controller,
    @required this.child,
  })  : topPaddingAnimation = Tween(
    begin: 60.0,
    end: 0.0,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.000 + startDelayFraction,
        0.400 + startDelayFraction,
        curve: Curves.ease,
      ),
    ),
  ),
        super(key: key);
  
  final Widget child;
  final AnimationController controller;
  final Animation<double> topPaddingAnimation;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.only(top: topPaddingAnimation.value),
          child: child,
        );
      },
      child: child,
    );
  }
}