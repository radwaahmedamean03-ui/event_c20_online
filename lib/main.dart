import 'package:evently_c20_online/core/app_provider/app_provider.dart';
import 'package:evently_c20_online/core/theme/app_theme.dart';
import 'package:evently_c20_online/modules/auth/screens/forget_password_screen.dart';
import 'package:evently_c20_online/modules/auth/screens/login_screen.dart';
import 'package:evently_c20_online/modules/auth/screens/resgister_screen.dart';
import 'package:evently_c20_online/modules/splash/screens/splash_screen.dart';
import 'package:evently_c20_online/modules/start/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'modules/add_event/manager/event_manager.dart';
import 'modules/add_event/screens/add_event_screen.dart';
import 'modules/layout/screens/layout_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:  (context )=>AppProvider() ),
        ChangeNotifierProvider(create:  (context )=>EventProvider() ),
      ],
      child:
     Builder(
        builder: (context) {
          var provider = Provider.of<AppProvider>(context);
          return MaterialApp(
            routes: {
              SplashScreen.routeName : (_) => SplashScreen(),
              StartScreen.routeName : (_) => StartScreen(),
              LoginScreen.routeName : (_) => LoginScreen(),
              RegisterScreen.routeName : (_) => RegisterScreen(),
              ForgetPasswordScreen.routeName : (_) => ForgetPasswordScreen(),
              LayoutScreen.routeName : (_) => LayoutScreen(),
              AddEventScreen.routeName : (_) => AddEventScreen(),
            },
            initialRoute:SplashScreen.routeName,
            locale: Locale(provider.locale),
            localizationsDelegates: [
              AppLocalizations.delegate, // Add this line
              ...GlobalMaterialLocalizations.delegates,
            ],          supportedLocales: [
              Locale('en'), // English
              Locale('ar'), // Arabic
            ],
            themeMode: provider.themeMode,
            // light theme
            theme: AppTheme.lightTheme,
            // dark theme
            darkTheme: AppTheme.darkTheme,
            title: 'Flutter Demo',
          );
        },
      ),
    ) ;
  }
}
