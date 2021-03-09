import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 3/9/21
/// Description: 
///

class PanelTextField extends StatelessWidget {
	const PanelTextField();
	
	@override
	Widget build(BuildContext context) {
		
		return Container(
				child: TextField(
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