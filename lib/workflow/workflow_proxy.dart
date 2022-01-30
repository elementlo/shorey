import 'package:flutter/material.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/28
/// Description: 
///

enum WorkFlow{notionWorkFlow,}

class WorkFlowProxy with ChangeNotifier{
  final WorkFlow workFlow;

  WorkFlowProxy(this.workFlow);

}
