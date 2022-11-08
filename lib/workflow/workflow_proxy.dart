import 'package:flutter/material.dart';
import 'package:shorey/config/api.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/28
/// Description: 
///

enum WorkFlowSelections{notionWorkFlow,}

class WorkFlowProxy with ChangeNotifier{
  final WorkFlowSelections workFlow;

  WorkFlowProxy(this.workFlow);


  Future initWorkflow() async{
    switch(workFlow){
      case WorkFlowSelections.notionWorkFlow:

        break;
    }
  }

}
