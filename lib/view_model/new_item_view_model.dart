import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shorey/resource/http_provider.dart';

import '../base/view_state_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/12/21
/// Description:
///
class NewItemViewModel extends ViewStateModel {
  Future uploadImage(ByteData? byteData) async{
    if(byteData == null){
      return Future.value(0);
    }
    var formData = FormData.fromMap({'file': [MultipartFile.fromBytes(byteData.buffer.asUint8List())]});

    return dio.post(
        'https://imgkr.com/api/files/upload',
        data: formData,);
  }
}
