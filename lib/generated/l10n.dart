// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Mantra`
  String get mantra {
    return Intl.message(
      'Mantra',
      name: 'mantra',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: 'Today',
      args: [],
    );
  }

  /// `Main Focus Today`
  String get mainFocusToday {
    return Intl.message(
      'Main Focus Today',
      name: 'mainFocusToday',
      desc: 'Main Focus Today',
      args: [],
    );
  }

  /// `Category`
  String get mainCategory {
    return Intl.message(
      'Category',
      name: 'mainCategory',
      desc: 'Main Category',
      args: [],
    );
  }

  /// `Shorey moment`
  String get shoreyMomment {
    return Intl.message(
      'Shorey moment',
      name: 'shoreyMomment',
      desc: 'Shorey moment',
      args: [],
    );
  }

  /// `Archived less`
  String get archivedLess {
    return Intl.message(
      'Archived less',
      name: 'archivedLess',
      desc: 'Archived less',
      args: [],
    );
  }

  /// `More`
  String get archivedMore {
    return Intl.message(
      'More',
      name: 'archivedMore',
      desc: 'More',
      args: [],
    );
  }

  /// `History`
  String get actionHistory {
    return Intl.message(
      'History',
      name: 'actionHistory',
      desc: 'Action history',
      args: [],
    );
  }

  /// `Archived`
  String get archivedList {
    return Intl.message(
      'Archived',
      name: 'archivedList',
      desc: 'Archived list',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: 'Settings',
      args: [],
    );
  }

  /// `About Shorey`
  String get aboutShorey {
    return Intl.message(
      'About Shorey',
      name: 'aboutShorey',
      desc: 'About Shorey',
      args: [],
    );
  }

  /// `Actions History`
  String get actionHistoryTitle {
    return Intl.message(
      'Actions History',
      name: 'actionHistoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Added`
  String get actionAdd {
    return Intl.message(
      'Added',
      name: 'actionAdd',
      desc: '',
      args: [],
    );
  }

  /// `Archived`
  String get actionArchived {
    return Intl.message(
      'Archived',
      name: 'actionArchived',
      desc: '',
      args: [],
    );
  }

  /// `Updated to`
  String get actionUpdate {
    return Intl.message(
      'Updated to',
      name: 'actionUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Edit Mantra`
  String get editMantra {
    return Intl.message(
      'Edit Mantra',
      name: 'editMantra',
      desc: '',
      args: [],
    );
  }

  /// `Retrospect`
  String get retrospect {
    return Intl.message(
      'Retrospect',
      name: 'retrospect',
      desc: '',
      args: [],
    );
  }

  /// `Frequency`
  String get frequency {
    return Intl.message(
      'Frequency',
      name: 'frequency',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get categoryList {
    return Intl.message(
      'Category',
      name: 'categoryList',
      desc: '',
      args: [],
    );
  }

  /// `Every day`
  String get everyday {
    return Intl.message(
      'Every day',
      name: 'everyday',
      desc: '',
      args: [],
    );
  }

  /// `Every Monday`
  String get everyMonday {
    return Intl.message(
      'Every Monday',
      name: 'everyMonday',
      desc: '',
      args: [],
    );
  }

  /// `Every Tuesday`
  String get everyTuesday {
    return Intl.message(
      'Every Tuesday',
      name: 'everyTuesday',
      desc: '',
      args: [],
    );
  }

  /// `Every Wednesday`
  String get everyWednesday {
    return Intl.message(
      'Every Wednesday',
      name: 'everyWednesday',
      desc: '',
      args: [],
    );
  }

  /// `Every Thursday`
  String get everyThursday {
    return Intl.message(
      'Every Thursday',
      name: 'everyThursday',
      desc: '',
      args: [],
    );
  }

  /// `Every Friday`
  String get everyFriday {
    return Intl.message(
      'Every Friday',
      name: 'everyFriday',
      desc: '',
      args: [],
    );
  }

  /// `Every Saturday`
  String get everySaturday {
    return Intl.message(
      'Every Saturday',
      name: 'everySaturday',
      desc: '',
      args: [],
    );
  }

  /// `Every Sunday`
  String get everySunday {
    return Intl.message(
      'Every Sunday',
      name: 'everySunday',
      desc: '',
      args: [],
    );
  }

  /// `No alert`
  String get noAlert {
    return Intl.message(
      'No alert',
      name: 'noAlert',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
