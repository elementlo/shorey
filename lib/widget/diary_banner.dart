import 'package:flutter/material.dart';

import 'icons.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/11/1
/// Description: 
///
class DiaryBanner extends StatefulWidget {
  const DiaryBanner({Key? key}) : super(key: key);

  @override
  State<DiaryBanner> createState() => _DiaryBannerState();
}

class _DiaryBannerState extends State<DiaryBanner> {

  final TextStyle _fontStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child:Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('城市', style: _fontStyle,),
          Text('城市',style: _fontStyle,),
          Text('城市',style: _fontStyle,),
          Text('29℃',style: _fontStyle,),
          Icon(QWeather.m100, size: 14, color: Colors.grey,),
          Text('Cloudy',style: _fontStyle,),
        ],
      ),
    );
  }
}

