import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/view_model/home_view_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 3/9/21
/// Description:
///

class PanelTextField extends StatefulWidget {
  const PanelTextField({Key key}) : super(key: key);

  @override
  _PanelTextFieldState createState() => _PanelTextFieldState();
}

class _PanelTextFieldState extends State<PanelTextField> {
  var finished = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Container(
      child: viewModel.hasMainFocus
          ? _buildMainFocusRow(context)
          : TextField(
              onSubmitted: (String finalInput) async {
                print('onsubmit: ${finalInput}');
                if (finalInput.isNotEmpty) {
                  await viewModel.saveMainFocus(finalInput);
                }
              },
              decoration: InputDecoration(
                  labelText: 'Main Focus Today...',
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
            ),
    );
  }

  Widget _buildMainFocusRow(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        setState(() {
          finished = !finished;
          viewModel.updateMainFocusStatus(finished ? 0 : 1);
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Main Focus Today:',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      finished
                          ? Icons.check_circle_outline
                          : Icons.brightness_1_outlined,
                      color: colorScheme.onSecondary,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${viewModel.mainFocus}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          height: 1,
                          decoration:
                              finished ? TextDecoration.lineThrough : null),
                    ),
                  ],
                ),
              ),
              Container(
                width: 18,
                height: 18,
                child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.edit),
                    iconSize: 16,
                    onPressed: () {
                      setState(() {
                        viewModel.hasMainFocus = false;
                      });
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
