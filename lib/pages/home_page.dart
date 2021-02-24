import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spark_list/base/provider_widget.dart';
import 'package:spark_list/view_model/home_view_model.dart';
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
    return ProviderWidget<HomeViewModel>(
      onModelReady: (viewModel){
      
      },
      model: HomeViewModel(),
      child: Scaffold(
        body: _HomeScreen(),
      ),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          restorationId: 'home_list_view',
          children: [
            const SizedBox(height: 8,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: HomeHeader(),
            )
          ],
        )
      ],
    );
  }
}

