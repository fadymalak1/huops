import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:huops/constants/app_theme.dart';
import 'package:huops/services/app.service.dart';
import 'package:huops/views/pages/splash.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'constants/app_strings.dart';
import 'package:huops/services/router.service.dart' as router;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AdaptiveTheme(
      light: AppTheme().darkTheme(),
      dark: AppTheme().darkTheme(),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) {
        return MaterialApp(
          navigatorKey: AppService().navigatorKey,
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          onGenerateRoute: router.generateRoute,
          onUnknownRoute: (RouteSettings settings) {
            return router.generateRoute(settings);
          },
          localizationsDelegates: translator.delegates,
          locale: translator.activeLocale,
          supportedLocales: translator.locals(),
          builder: (context, child) => Stack(
            children: [child!, DropdownAlert()],
          ),
          home: SplashPage(),
          theme: theme,
        );
      },
    );
  }
}
