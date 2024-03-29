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

  /// `Food Source`
  String get title {
    return Intl.message(
      'Food Source',
      name: 'title',
      desc: 'Title for the Food Source Application',
      args: [],
    );
  }

  /// `Healthy body start with healthy food`
  String get tagline {
    return Intl.message(
      'Healthy body start with healthy food',
      name: 'tagline',
      desc: '',
      args: [],
    );
  }

  /// `Add Recipe`
  String get addFood {
    return Intl.message(
      'Add Recipe',
      name: 'addFood',
      desc: '',
      args: [],
    );
  }

  /// `Edit Recipe`
  String get editFood {
    return Intl.message(
      'Edit Recipe',
      name: 'editFood',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get recipeName {
    return Intl.message(
      'Name',
      name: 'recipeName',
      desc: 'Capitalise recipe Name',
      args: [],
    );
  }

  /// `Ingredients`
  String get recipeIngr {
    return Intl.message(
      'Ingredients',
      name: 'recipeIngr',
      desc: 'Capitalise recipe Ingredients',
      args: [],
    );
  }

  /// `Description`
  String get recipeDesc {
    return Intl.message(
      'Description',
      name: 'recipeDesc',
      desc: 'Capitalise recipe Description',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Please enter some text`
  String get requiredText {
    return Intl.message(
      'Please enter some text',
      name: 'requiredText',
      desc: 'Validation text',
      args: [],
    );
  }

  /// `Are you sure to delete?`
  String get deleteWarning {
    return Intl.message(
      'Are you sure to delete?',
      name: 'deleteWarning',
      desc: 'Confirmation to delete',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
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
