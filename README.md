# Shorey
这是一款开源笔记应用, 支持Android/iOS双平台, 使用Flutter 2开发, 体验Flutter的同时也希望做一个能成为个人知识中转站的应用,  任重道远 :)

**特点:**
* Google Material UI风格
* 每日回顾, 快速知识归档
* 简洁的记事操作
* 设置自己的格言, 每天都有仪式感
* 设置当天主要目标, 集中精力
* 热力图记录完成事项
* 更多功能开发中…

## 马上开始
**应用运行要求:**
1. Android 5.0 +
2. iOS 10+

**项目编译要求:**
1. Android SDK 28/Xcode 13
2. Flutter SDK 2.5.3

## 应用展示
UI部分大量参考了Flutter官方的Gallery应用. 另外还在关于页埋了个小彩蛋, 希望喜欢.

![1635993576753196](https://user-images.githubusercontent.com/10020581/140248837-eedb8d40-c163-4971-b935-336ca6dcf7db.gif) ![1635993576753197](https://user-images.githubusercontent.com/10020581/140249070-e82979ab-8a6b-45e7-969a-1c7cdec95013.gif) ![1635993576753198](https://user-images.githubusercontent.com/10020581/140249271-78f3c6f3-235a-4c1a-8aec-48f1f2ec63e1.gif) ![1635993576753199](https://user-images.githubusercontent.com/10020581/140249546-98a5ce01-d005-4e2e-bbca-d95a5778bc36.gif)





## 技术架构

* 关于Flutter

  由于想要体验完全的跨平台能力, 所以APP主体是纯Dart开发的, 保证安卓和iOS的UI是一套代码完成的. Flutter作为一套跨平台的UI框架在轻业务重UI场景有很大的潜力, 用来快速搭建UI是比原生要快的.
  Google现在在Android也开始推广Compose, 以后声明式UI可能也会成为一种选择.
* 关于MVVM

  因为Flutter本身是声明式框架, UI由数据驱动, 所以使用MVVM架构有天然的优势, 这里使用简单封装的Provider插件将数据/逻辑/UI进行分离. 

## 感谢
Flutter Gallery
Flutter 插件:
* Provider
* pull_to_refresh
* google_fonts
* shared_preferences
* fluttertoast
* sqflite
* synchronized
* animated_text_kit
* flutter_local_notifications
* cupertino_icons
* syncfusion_flutter_datepicker
* day_night_time_picker
* flutter_native_timezone
* intl
* package_info_plus
* lottie
* flutter_easyloading
* url_launcher

## 关于我
作者是一名前端开发, 对大前端技术都很有兴趣. 欢迎对Flutter/前端有同样兴趣或者技术问题的邮件联系.
邮箱: lawliet.zhan@outlook.com

## 捐赠
欢迎对项目感兴趣的朋友捐赠一杯咖啡☕️

<img height="300" alt="wechat" src="https://user-images.githubusercontent.com/10020581/140245829-abf071cb-a268-4f0f-a0c6-0e83f240d81f.png"><img height="300" alt="alipay" src="https://user-images.githubusercontent.com/10020581/140245821-75e1b840-b1f4-4af4-ae9c-cf2fc75219ca.png">








