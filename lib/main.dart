import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_source/routes.dart';
import 'package:food_source/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(initialRoute: '/index'),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key, this.home, this.initialRoute}) : super(key: key);

  final Widget? home;
  final String? initialRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        theme: lightTheme(),
        debugShowCheckedModeBanner: kDebugMode,
        home: home,
        initialRoute: initialRoute,
        localizationsDelegates: const [
          AppLocalizations.delegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
        ],
        routes: foodRoutes);
  }
}
