import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shorey/widget/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2021/9/24
/// Description:
///

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {
  String _version = '';
  AnimationController? controller;
  bool offStage = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 1000), value: 1, vsync: this);
    PackageInfo.fromPlatform().then((value) {
      _version = value.version;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: SparkAppBar(
            context: context,
            title: 'Shorey',
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: ListView(
              children: [
                InkWell(
                    onLongPress: () {
                      offStage = false;
                      setState(() {});
                      controller?.reset();
                      controller?.forward();
                    },
                    child: Image.asset('assets/images/ic_logo.png', width: 90, height: 90),),
                _textView('理念'),
                _textView('Shorey希望能成为一个个人的知识/记忆中转站，信息载体在这里短暂停留，'
                    '之后就流向它该被归档的地方，可以是你的备忘录或者Notion等笔记软件。你需要尽可能地让信息尽快离开Shorey，这可以有两种途径：'),
                _textView('''
1. 记住它们！
2. 知识归档-你的笔记软件'''),
                _textView(
                    '所以默认Shorey会每天回顾一次还未归档的信息，以防遗忘。后期Shorey会考虑接Notion API。'),
                SizedBox(
                  height: 25,
                ),
                _textView('百分比钟/Percent clock'),
                _textView('标识今天已经度过了百分之几。'),
                SizedBox(
                  height: 25,
                ),
                _textView('Shorey moment'),
                _textView(
                    '一个热力图，颜色越深代表当日处理信息越多。行代表周数，列代表星期几。热力图会记录过去13周的热度。努力填满空格吧！'),
                SizedBox(
                  height: 25,
                ),
                _textView('Why Shorey'),
                _textView('Memory + Shore = Shorey'),
                Divider(
                  height: 45,
                ),
                _textView('Version: $_version'),
                _textView('反馈: https://github.com/elementlo/shorey/issues', onTap: (){
                  launch('https://github.com/elementlo/shorey/issues');
                }),
                _textView('捐赠: https://github.com/elementlo/shorey', onTap: (){
                  launch('https://github.com/elementlo/shorey');
                }),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: offStage,
          child: _secretMask(),
        ),
      ],
    );
  }

  Widget _textView(String text,{VoidCallback? onTap}) {
    return InkWell(
        onTap: onTap,
        child: Text('$text', style: TextStyle(color: Colors.grey)));
  }

  Widget _secretMask() {
    final colorScheme = Theme.of(context).colorScheme;
    return FadeTransition(
      opacity: controller!,
      child: GestureDetector(
        onTap: () {
          offStage = true;
          controller?.reset();
          setState(() {});
        },
        child: Scaffold(
          body: Container(
            color: colorScheme.primaryContainer,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  Image.asset('assets/images/ic_logo.png', width: 90, height: 90),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const SizedBox(width: 30.0, height: 100.0),
                        DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 40.0,
                            fontFamily: 'Horizon',
                          ),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              RotateAnimatedText('Be',
                                  duration: Duration(milliseconds: 3000),
                                  rotateOut: false),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20.0, height: 100.0),
                        DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 40.0,
                            fontFamily: 'Horizon',
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              FadeAnimatedText('',
                                  duration: Duration(milliseconds: 3400)),
                              RotateAnimatedText('SHARP'),
                              RotateAnimatedText('OPTIMISTIC'),
                              RotateAnimatedText('MAVERICK', rotateOut: false),
                            ],
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Lottie.asset('assets/anim/68349-cat-tail-wag.json',
                      width: 250),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
