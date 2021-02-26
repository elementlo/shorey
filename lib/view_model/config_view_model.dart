import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spark_list/base/view_state_model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description: 
///

class ConfigViewModel extends ViewStateModel{
	static ThemeMode themeMode = ThemeMode.system;
	
	bool isSettingsOpenNotifier = false;
	
	void set settingsOpenNotifier(bool open){
		isSettingsOpenNotifier = open;
		notifyListeners();
	}
	
	static SystemUiOverlayStyle resolvedSystemUiOverlayStyle() {
		Brightness brightness;
		switch (themeMode) {
			case ThemeMode.light:
				brightness = Brightness.light;
				break;
			case ThemeMode.dark:
				brightness = Brightness.dark;
				break;
			default:
				brightness = WidgetsBinding.instance.window.platformBrightness;
		}
		
		final overlayStyle = brightness == Brightness.dark
				? SystemUiOverlayStyle.light
				: SystemUiOverlayStyle.dark;
		
		return overlayStyle;
	}
}