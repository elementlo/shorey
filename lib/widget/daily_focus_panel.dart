import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark_list/config/config.dart';
import 'package:spark_list/config/theme_data.dart';
import 'package:spark_list/widget/panel_text_field.dart';
import 'package:sqflite/sqflite.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 3/1/21
/// Description:
///

class DailyFocusPanel extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;

  const DailyFocusPanel({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _DailyFocusPanelState createState() => _DailyFocusPanelState();
}

class _DailyFocusPanelState extends State<DailyFocusPanel> {
  String mantra = '';
  Database? db;

  void initMantra() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mantra =
          prefs.getString('mantra') ?? Mantra.mantraList[Random().nextInt(3)];
      print('mantra: $mantra');
    });
  }

  @override
  void initState() {
    super.initState();
    initMantra();
  }

  @override
  void didUpdateWidget(covariant DailyFocusPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    initMantra();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        final percent = DateTime.now().hour / 24 * 100;
        return FadeTransition(
          opacity: widget.animation as Animation<double>,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //       color: Colors.grey.withOpacity(0.2),
                  //       offset: Offset(1.1, 1.1),
                  //       blurRadius: 2.0),
                  // ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 12, right: 12),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 4),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 48,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryVariant
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 2),
                                              child: Text(
                                                'Mantra',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  200,
                                              child: Text(
                                                '${mantra}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                      border: new Border.all(
                                          width: 3,
                                          color: Color(0xFFe26d5c)
                                              .withOpacity(0.4)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '${(percent * widget.animation!.value).toInt()}%',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 24,
                                            letterSpacing: 0.0,
                                            color: AppThemeData.lightColorScheme
                                                .primaryVariant,
                                          ),
                                        ),
                                        Text(
                                          'Today',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CustomPaint(
                                    painter: CurvePainter(
                                        colors: [
                                          Color(0xFFe26d5c),
                                          Color(0xFFe26d5c),
                                          // Color(0x8A98E8),
                                          // Color(0x8A98E8)
                                          //Colors.white
                                        ],
                                        angle: 140 +
                                            (360 - 140) *
                                                (1.0 - widget.animation!.value)),
                                    child: SizedBox(
                                      width: 108,
                                      height: 108,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      indent: 16,
                      endIndent: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: PanelTextField(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color>? colorsList = <Color>[];
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    // final shdowPaint = new Paint()
    //   ..color = Colors.black.withOpacity(0.4)
    //   ..strokeCap = StrokeCap.round
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 14;
    // final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    // final shdowPaintRadius =
    //     math.min(size.width / 2, size.height / 2) - (14 / 2);
    // canvas.drawArc(
    //     new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
    //     degreeToRadians(278),
    //     degreeToRadians(360 - (365 - angle)),
    //     false,
    //     shdowPaint);
    //
    // shdowPaint.color = Colors.grey.withOpacity(0.3);
    // shdowPaint.strokeWidth = 16;
    // canvas.drawArc(
    //     new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
    //     degreeToRadians(278),
    //     degreeToRadians(360 - (365 - angle)),
    //     false,
    //     shdowPaint);
    //
    // shdowPaint.color = Colors.grey.withOpacity(0.2);
    // shdowPaint.strokeWidth = 20;
    // canvas.drawArc(
    //     new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
    //     degreeToRadians(278),
    //     degreeToRadians(360 - (365 - angle)),
    //     false,
    //     shdowPaint);
    //
    // shdowPaint.color = Colors.grey.withOpacity(0.1);
    // shdowPaint.strokeWidth = 22;
    // canvas.drawArc(
    //     new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
    //     degreeToRadians(278),
    //     degreeToRadians(360 - (365 - angle)),
    //     false,
    //     shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList!,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (10 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 10 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 10 / 2);
    canvas.drawCircle(new Offset(0, 0), 10 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
