import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Row(
        children: [
          Text('城市'),
          Text('城市'),
          Text('城市'),
        ],
      ),
    );
  }
}

