import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_list/base/provider_widget.dart';
import 'package:spark_list/view_model/home_view_model.dart';
import 'package:spark_list/widget/DailyFocusPanel.dart';
import 'package:spark_list/widget/home_header.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/23/21
/// Description: 
///
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  
  final String title;
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return _HomeScreen();
  }
}

class _HomeScreen extends StatefulWidget {
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> with TickerProviderStateMixin  {
  AnimationController _animationController;
  
  @override
  void initState(){
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _animationController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            restorationId: 'home_list_view',
            children: [
              const SizedBox(height: 8,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                child: HomeHeader(),
              ),
              DailyFocusPanel(
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: _animationController,
                    curve:
                    Interval((1 / 9) * 1, 1.0, curve: Curves.fastOutSlowIn))),
                animationController: _animationController,
              )
            ],
          )
        ],
      ),
    );
  }
}

