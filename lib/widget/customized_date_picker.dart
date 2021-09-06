import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/8/25
/// Description: 
///

class CustomizedDatePicker extends StatefulWidget{
  final List<DateTime> specialDates;
  final Function(DateTime selection) onSelectionChanged;

  CustomizedDatePicker(this.specialDates, this.onSelectionChanged);

  @override
  State<StatefulWidget> createState() {
    return CustomizedDatePickerState();
  }

}

class CustomizedDatePickerState extends State<CustomizedDatePicker>{
  @override
  Widget build(BuildContext context) {
    final bool isDark = false;
    final colorScheme = Theme.of(context).colorScheme;
    final Color monthCellBackground =
    isDark ? const Color(0xFF232731) : Colors.white;
    final Color indicatorColor =
    isDark ? const Color(0xFF5CFFB7) :  Color(0xFFffe1a8);
    final Color highlightColor =
    isDark ? const Color(0xFF5CFFB7) : colorScheme.onSecondary;
    final Color cellTextColor =
    isDark ? const Color(0xFFDFD4FF) : const Color(0xFF130438);
    return SfDateRangePicker(
      selectionShape: DateRangePickerSelectionShape.rectangle,
      selectionColor: highlightColor,
      onSelectionChanged: (selection){
        print(selection.value);
        widget.onSelectionChanged(selection.value);
      },
      selectionTextStyle:
      TextStyle(color: isDark ? Colors.black : Colors.white, fontSize: 14),
      minDate: DateTime.now().add(const Duration(days: 0)),
      maxDate: DateTime.now().add(const Duration(days: 500)),
      headerStyle: DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontSize: 18,
            color: cellTextColor,
          )),
      monthCellStyle: DateRangePickerMonthCellStyle(
          cellDecoration: _MonthCellDecoration(
              borderColor: null,
              backgroundColor: monthCellBackground,
              showIndicator: false,
              indicatorColor: indicatorColor),
          todayCellDecoration: _MonthCellDecoration(
              borderColor: highlightColor,
              backgroundColor: monthCellBackground,
              showIndicator: false,
              indicatorColor: indicatorColor),
          specialDatesDecoration: _MonthCellDecoration(
              borderColor: null,
              backgroundColor: monthCellBackground,
              showIndicator: true,
              indicatorColor: indicatorColor),
          disabledDatesTextStyle: TextStyle(
            color: isDark ? const Color(0xFF666479) : const Color(0xffe2d7fe),
          ),
          weekendTextStyle: TextStyle(
            color: highlightColor,
          ),
          textStyle: TextStyle(color: cellTextColor, fontSize: 14),
          specialDatesTextStyle: TextStyle(color: cellTextColor, fontSize: 14),
          todayTextStyle: TextStyle(color: highlightColor, fontSize: 14)),
      yearCellStyle: DateRangePickerYearCellStyle(
        todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
        textStyle: TextStyle(color: cellTextColor, fontSize: 14),
        disabledDatesTextStyle: TextStyle(
            color: isDark ? const Color(0xFF666479) : const Color(0xffe2d7fe)),
        leadingDatesTextStyle:
        TextStyle(color: cellTextColor.withOpacity(0.5), fontSize: 14),
      ),
      showNavigationArrow: true,
      todayHighlightColor: highlightColor,
      monthViewSettings: DateRangePickerMonthViewSettings(
        firstDayOfWeek: 1,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
            textStyle: TextStyle(
                fontSize: 10,
                color: cellTextColor,
                fontWeight: FontWeight.w600)),
        dayFormat: 'EEE',
        showTrailingAndLeadingDates: false,
        specialDates: widget.specialDates,
      ),
    );
  }

}

class _MonthCellDecoration extends Decoration {
  const _MonthCellDecoration(
      {this.borderColor,
        this.backgroundColor,
        required this.showIndicator,
        this.indicatorColor});

  final Color? borderColor;
  final Color? backgroundColor;
  final bool showIndicator;
  final Color? indicatorColor;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MonthCellDecorationPainter(
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        showIndicator: showIndicator,
        indicatorColor: indicatorColor);
  }
}

class _MonthCellDecorationPainter extends BoxPainter {
  _MonthCellDecorationPainter(
      {this.borderColor,
        this.backgroundColor,
        required this.showIndicator,
        this.indicatorColor});

  final Color? borderColor;
  final Color? backgroundColor;
  final bool showIndicator;
  final Color? indicatorColor;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & configuration.size!;
    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    final Paint paint = Paint()..color = backgroundColor!;
    canvas.drawRRect(
        RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    if (borderColor != null) {
      paint.color = borderColor!;
      canvas.drawRRect(
          RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    }

    if (showIndicator) {
      paint.color = indicatorColor!;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bounds.right - 6, bounds.top + 6), 2.5, paint);
    }
  }
}