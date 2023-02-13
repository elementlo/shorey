import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
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

    //var formData = FormData.fromMap({'reqtype':'fileupload','fileToUpload': [MultipartFile.fromBytes(byteData.buffer.asUint8List())]});
    final directory = await getApplicationDocumentsDirectory();
    File file = new File('${directory.path}/cache.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    var formData = FormData.fromMap({'reqtype':'fileupload','fileToUpload': await MultipartFile.fromFile(file.path)});

    return dio.post(
        'https://catbox.moe/user/api.php',
        data: formData,);
  }
}
