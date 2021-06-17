import 'package:flipper/app_view_model.dart';
import 'package:flipper/flipper_options.dart';
import 'package:flipper/routes.logger.dart';
import 'package:flipper/routes.router.dart';
import 'package:flipper_login/flipper_theme_data.dart';
import 'package:flipper_models/setting.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_gen/gen_l10n/flipper_localizations.dart'; // Add this line.
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:stacked/stacked.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;
final isWeb = UniversalPlatform.isWeb;

class FlipperApp extends StatefulWidget {
  @override
  State<FlipperApp> createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp> {
  final log = getLogger('FlipperApp');
  @override
  Widget build(BuildContext context) {
    if (!isWindows && !isMacOs) {
      final FirebaseAnalytics analytics = FirebaseAnalytics();
      final FirebaseAnalyticsObserver observer =
          FirebaseAnalyticsObserver(analytics: analytics);

      return ViewModelBuilder<AppViewModel>.reactive(
          viewModelBuilder: () => AppViewModel(),
          onModelReady: (model) async {
            String? defaultLanguage = await model.getSetting();
            final locale = defaultLanguage == null
                ? Locale('be')
                : Locale(defaultLanguage);
            model.setLocale(locale);
          },
          builder: (context, model, child) {
            return MaterialApp(
              themeMode: ThemeMode.system,
              // theme: FlipperThemeData.lightThemeData
              //     .copyWith(platform: TargetPlatform.android),
              theme: ThemeData(
                // This changes font for the entire app using the Google Fonts package
                // from pub.dev : https://pub.dev/packages/google_fonts
                textTheme: GoogleFonts.nunitoSansTextTheme(
                  Theme.of(context).textTheme,
                ),
                // You can change theme colors to directly change colors for the whole
                // app.
                primaryColor: Color(0xff5B428F),
                // canvasColor: Colors.transparent,
                // set canvasColor to transparent when working on dark mode.
                // canvasColor: Colors.transparent,
                // accentColor: Color(0xffF56D58),
                primaryColorDark: Color(0xff262833),
                primaryColorLight: Color(0xffFCF9F5),
              ),
              darkTheme: FlipperThemeData.darkThemeData
                  .copyWith(platform: TargetPlatform.android),
              debugShowCheckedModeBanner: false,
              title: 'flipper',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              // supportedLocales: FlipperLocalizations.supportedLocales,
              // locale: FlipperOptions.of(context).locale,
              locale: model.locale, //belalus == rwanda language in our app
              localeResolutionCallback: (locale, supportedLocales) {
                deviceLocale = locale!;
                return locale;
              },
              navigatorKey: StackedService.navigatorKey,
              navigatorObservers: <NavigatorObserver>[observer],
              onGenerateRoute: StackedRouter().onGenerateRoute,
            );
          });
    } else {
      return ViewModelBuilder<AppViewModel>.reactive(
        viewModelBuilder: () => AppViewModel(),
        onModelReady: (model) async {
          String? defaultLanguage = await model.getSetting();
          final locale =
              defaultLanguage == null ? Locale('be') : Locale(defaultLanguage);
          model.setLocale(locale);
        },
        builder: (context, model, child) {
          return MaterialApp(
            themeMode: ThemeMode.system,
            theme: ThemeData(
              // This changes font for the entire app using the Google Fonts package
              // from pub.dev : https://pub.dev/packages/google_fonts
              textTheme: GoogleFonts.nunitoSansTextTheme(
                Theme.of(context).textTheme,
              ),
              // You can change theme colors to directly change colors for the whole
              // app.
              primaryColor: Color(0xff5B428F),
              // set canvasColor to transparent when working on dark mode.
              // canvasColor: Colors.transparent,
              primaryColorDark: Color(0xff262833),
              primaryColorLight: Color(0xffFCF9F5),
            ),
            // theme: FlipperThemeData.lightThemeData
            //     .copyWith(platform: TargetPlatform.android),
            darkTheme: FlipperThemeData.darkThemeData
                .copyWith(platform: TargetPlatform.android),
            debugShowCheckedModeBanner: false,
            title: 'flipper',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // supportedLocales: FlipperLocalizations.supportedLocales,
            // locale: FlipperOptions.of(context).locale,
            locale: model.locale, //belalus == rwanda language in our app
            localeResolutionCallback: (locale, supportedLocales) {
              deviceLocale = locale!;
              return locale;
            },
            navigatorKey: StackedService.navigatorKey,
            onGenerateRoute: StackedRouter().onGenerateRoute,
          );
        },
      );
    }
    // be is what we use as kinyarwanda
  }
}
