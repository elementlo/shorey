import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
	
	
  @override
  Widget build(BuildContext context) {
    return Container(
	    child: TextField(
		    onSubmitted: (String finalInput){
			    print('onsubmit: ${finalInput}');
			
		    },
		    decoration: InputDecoration(
				    labelText: 'Main Focus Today...',
				    border: UnderlineInputBorder(
						    borderSide: BorderSide(
								    color: Colors.grey
						    )
				    )
		    ),
	    ),
    );
  }
}