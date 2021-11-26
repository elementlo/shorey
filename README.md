<h1 align="center">
  <img src="https://user-images.githubusercontent.com/10020581/142364992-fd8ff10f-cae3-4a51-ba21-e7d03cf265f0.png" alt="Shorey" width="200">
  <div></>
  <br>
  Shorey
  <br>
</h1>
这是一款开源笔记应用, 支持Android/iOS双平台, 使用Flutter 2开发, 体验Flutter的同时也希望做一个能成为个人知识中转站的应用,  任重道远 :)

Shorey is a simple note app which is built with Flutter 2 and supports both Android/iOS platforms. It provides me full experience of interacting with Flutter and in the meantime I hope it can be your knowledge/memory transition tool, and yes, there still much work to do.

**特点:**
* Google Material UI风格
* 每日回顾, 快速知识归档
* 简洁的记事操作
* 设置自己的格言, 每天都有仪式感
* 设置当天主要目标, 集中精力
* 热力图记录完成事项
* 更多功能开发中…

## 分享
[个人笔记软件Shorey开源(一) - 软件介绍/产品理念](https://mp.weixin.qq.com/s/W-3AhgCHSIQWLomPuyIPwA)

## 马上开始
**应用运行要求:**
1. Android 5.0 +
2. iOS 10+

**项目编译要求:**
1. Android SDK 28/Xcode 13
2. Flutter SDK 2.5.3

## 应用展示
UI部分大量参考了Flutter官方的Gallery应用. 另外还在关于页埋了个小彩蛋, 希望喜欢.

![1636005007174126](https://user-images.githubusercontent.com/10020581/140265074-430bc04c-0157-4c8c-931c-abcc6e92e922.gif) ![1636005007174127](https://user-images.githubusercontent.com/10020581/140265167-a41c6e05-cde1-4fe1-bb01-68688e036b8a.gif) ![1636005007174128](https://user-images.githubusercontent.com/10020581/140265292-11729260-45a8-4b98-b62f-a93f8f1f29b8.gif) ![1636005007174129](https://user-images.githubusercontent.com/10020581/140265890-d16730ee-8230-4215-b0db-b63cb074bce4.gif)


## 体验
Android: 可直接在Release板块下载apk体验.或使用下方二维码下载.

![lqHI](https://user-images.githubusercontent.com/10020581/140268740-ff2558a8-c8d3-4ae6-ac08-8b9bec2a1c10.png)


iOS: 可下载源码使用 flutter run --release 编译体验, 后期考虑上testflight.


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

## 反馈
时间仓促, 可能会有各种问题, 欢迎提issue或者邮件联系我, 海涵.

## 捐赠
欢迎对项目感兴趣的朋友捐赠一杯咖啡☕️

<img height="300" alt="wechat" src="https://user-images.githubusercontent.com/10020581/140245829-abf071cb-a268-4f0f-a0c6-0e83f240d81f.png"><img height="300" alt="alipay" src="https://user-images.githubusercontent.com/10020581/140245821-75e1b840-b1f4-4af4-ae9c-cf2fc75219ca.png">








