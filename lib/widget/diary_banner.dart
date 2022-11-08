import 'dart:async';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/config_view_model.dart';
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
  Map<String, Object>? _locationResult;

  StreamSubscription<Map<String, Object>>? _locationListener;

  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();
  bool _hasLocationPermission = false;
  String _city = '';
  String _street = '';

  final TextStyle _fontStyle = TextStyle(fontSize: 12, color: Colors.grey);

  @override
  void initState() {
    super.initState();
    context.read<ConfigViewModel>().requestLocationPermission().then((value) {
      _hasLocationPermission = value;
      _locationListener = _locationPlugin.onLocationChanged().listen((Map<String, Object> result) {
          _locationResult = result;
          if(_locationResult!=null && _locationResult!['locationType'] != 0){
            _city = _locationResult!['city'] == null ? '' : _locationResult!['city'] as String;
            _street = _locationResult!['street'] == null ? '' : _locationResult!['street'] as String;
            setState(() {

            });
          }
      });
      _startLocation();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (null != _locationListener) {
      _locationListener?.cancel();
    }
    _locationPlugin.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$_city',
            style: _fontStyle,
          ),
          SizedBox(width: 3,),
          Text(
            '$_street',
            style: _fontStyle,
          ),
          SizedBox(width: 5,),
          Text(
            '29℃',
            style: _fontStyle,
          ),
          SizedBox(width: 3,),
          Icon(
            QWeather.m100,
            size: 14,
            color: Colors.grey,
          ),
          SizedBox(width: 3,),
          Text(
            'Cloudy',
            style: _fontStyle,
          ),
        ],
      ),
    );
  }

  void _setLocationOption() {
    AMapLocationOption locationOption = new AMapLocationOption();
    locationOption.onceLocation = true;
    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";
    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;
    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;
    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  void _startLocation() {
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  void _stopLocation() {
    _locationPlugin.stopLocation();
  }
}
