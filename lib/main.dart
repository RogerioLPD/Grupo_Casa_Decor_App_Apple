import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grupo_casadecor/mobile/screens/main_navigation.dart';
import 'package:grupo_casadecor/mobile/screens/privacy.dart';
import 'package:grupo_casadecor/mobile/screens/splash_screen.dart';
import 'package:grupo_casadecor/mobile/screens/terms.dart';
import 'package:grupo_casadecor/routes.dart';
import 'package:grupo_casadecor/shared/screens/login.dart';
import 'package:grupo_casadecor/shared/screens/register_especificador.dart';
import 'package:grupo_casadecor/shared/theme/theme.dart';
import 'package:grupo_casadecor/web/home_landing.dart';
import 'package:grupo_casadecor/web/screens/home_page_adm.dart';
import 'package:grupo_casadecor/web/screens/home_page_company.dart';
import 'package:grupo_casadecor/web/screens/rank.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grupo Casa Decor',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: kIsWeb ? Routes.home : Routes.splashscreen,
      onGenerateRoute: (RouteSettings settings) {
        return Routes.fadeThrough(settings, (context) {
          switch (settings.name) {
            case Routes.home:
              return const HomeLandingPage();
            case Routes.splashscreen:
              return const SplashScreen();
            case Routes.main_navigation:
              return const MainNavigation();
            case Routes.login:
              return const LoginScreen();
            case Routes.registerEspecificador:
              return const RegisterEspecificador();
            case Routes.terms:
              return const TermsConditionsPage();
            case Routes.privacy:
              return const PrivacyPolicyPage();
            case Routes.homeAdm:
              return const HomePageAdm();
            case Routes.homeCompany:
              return const HomeScreenCompany();
            case Routes.rank:
              return const ReleasesPage1();
            default:
              return const SizedBox.shrink();
          }
        });
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
