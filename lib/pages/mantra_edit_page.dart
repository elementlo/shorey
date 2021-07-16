import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_list/widget/app_bar.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 4/16/21
/// Description:
///

class MantraEditPage extends StatefulWidget {
  @override
  _MantraEditPageState createState() => _MantraEditPageState();
}

class _MantraEditPageState extends State<MantraEditPage> {
  TextEditingController _controller = TextEditingController();
  String mantra = '';

  void _fetchMantra() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mantra = prefs.getString('mantra') ?? '';
      _controller.text = mantra;
    });
  }

  void _saveMantra(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mantra', text);
  }

  @override
  void initState() {
    super.initState();
    _fetchMantra();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: SparkAppBar(
        context: context,
        title: '编辑Mantra',
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
                color: colorScheme.onSecondary,
              ),
              onPressed: () async{
              	mantra = _controller.text;
                if (mantra.isEmpty) {
                  Fluttertoast.showToast(msg: '请输入Mantra内容');
                  return;
                } else {
	                await _saveMantra(_controller.text);
	                Navigator.of(context).pop();
                }
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.edit),
          ),
        ),
      ),
    );
  }
}