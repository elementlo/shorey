import 'package:dio/dio.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/13
/// Description: 
///

var dio = Dio();

extension ResponseExt on Response{

  bool get success => this.statusCode == 200;
}