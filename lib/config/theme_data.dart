import 'package:flutter/material.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/24/21
/// Description: 
///
class AppThemeData {
	static const _lightFillColor = Colors.black;
	static const _darkFillColor = Colors.white;
	
	static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
	static final Color _darkFocusColor = Colors.white.withOpacity(0.12);
	
	static ThemeData lightThemeData =
	themeData(lightColorScheme, _lightFocusColor);
	static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);
	
	static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
		return ThemeData(
			useMaterial3: true,
			colorScheme: colorScheme,
			// Matches manifest.json colors and background color.
			primaryColor: const Color(0xFFF7F8FA),
			textTheme: _textTheme,
			appBarTheme: AppBarTheme(
				color: colorScheme.background,
				elevation: 0,
				iconTheme: IconThemeData(color: colorScheme.primary),
			),
			iconTheme: IconThemeData(color: colorScheme.onPrimary),
			canvasColor: colorScheme.background,
			scaffoldBackgroundColor: Color(0xFFF5F5F5),
			highlightColor: Colors.transparent,
			focusColor: focusColor,
			snackBarTheme: SnackBarThemeData(
				behavior: SnackBarBehavior.floating,
				backgroundColor: Color.alphaBlend(
					_lightFillColor.withOpacity(0.80),
					_darkFillColor,
				),
				contentTextStyle: _textTheme.subtitle1!.apply(color: _darkFillColor),
			),
		);
	}
	
	static const ColorScheme lightColorScheme = ColorScheme(
		primary: Color(0xe26d5c),
		primaryContainer: Color(0xFF117378),
		secondary: Color(0xFFe26d5c),
		secondaryContainer: Color(0xFFFAFBFB),
		background: Color(0xFFE6EBEB),
		surface: Color(0xFFFAFBFB),
		onBackground: Colors.white,
		error: _lightFillColor,
		onError: _lightFillColor,
		onPrimary: _lightFillColor,
		onSecondary: Color(0xFFe26d5c),
		onSurface: Color(0xFF241E30),
		brightness: Brightness.light,
	);
	
	static const ColorScheme darkColorScheme = ColorScheme(
		primary: Color(0xFFFF8383),
		primaryContainer: Color(0xFF1CDEC9),
		secondary: Color(0xFF4D1F7C),
		secondaryContainer: Color(0xFF451B6F),
		background: Color(0xFF241E30),
		surface: Color(0xFF1F1929),
		onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
		error: _darkFillColor,
		onError: _darkFillColor,
		onPrimary: _darkFillColor,
		onSecondary: _darkFillColor,
		onSurface: _darkFillColor,
		brightness: Brightness.dark,
	);
	
	static const _regular = FontWeight.w400;
	static const _medium = FontWeight.w500;
	static const _semiBold = FontWeight.w600;
	static const _bold = FontWeight.w700;

	static final TextTheme _textTheme = TextTheme(
		headline4: TextStyle(fontWeight: _bold, fontSize: 20.0),
		caption: TextStyle(fontWeight: _semiBold, fontSize: 16.0),
		headline5: TextStyle(fontWeight: _medium, fontSize: 16.0),
		subtitle1: TextStyle(fontWeight: _medium, fontSize: 16.0),
		overline: TextStyle(fontWeight: _medium, fontSize: 12.0),
		bodyText1: TextStyle(fontWeight: _regular, fontSize: 14.0),
		subtitle2: TextStyle(fontWeight: _medium, fontSize: 14.0),
		bodyText2: TextStyle(fontWeight: _regular, fontSize: 16.0),
		headline6: TextStyle(fontWeight: _bold, fontSize: 16.0),
		button: TextStyle(fontWeight: _semiBold, fontSize: 14.0),
	);
}