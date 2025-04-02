import 'package:salahmaskan/pages/forgotpassword.dart';
import 'package:salahmaskan/pages/home.dart';
import 'package:salahmaskan/pages/login.dart';
import 'package:salahmaskan/pages/privacypolicy.dart';
import 'package:salahmaskan/pages/registration.dart';
import 'package:salahmaskan/pages/secureadmin.dart';
import 'package:salahmaskan/pages/securehome.dart';
import 'package:salahmaskan/utils/routes.dart';
import 'package:salahmaskan/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:salahmaskan/models/SigninResponse.dart';

const SERVER_IP = 'https://masjidlocators.com';
const baseURL = 'http://masjidlocators.com/';
const storage = FlutterSecureStorage();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masjid Locator',
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: MyRoutes.homeRoute,
      debugShowCheckedModeBanner: false,
      routes: {
        MyRoutes.homeRoute: (context) => const HomePage(),
        MyRoutes.loginRoute: (context) => const LoginPage(),
        MyRoutes.registrationRoute: (context) => const Registration(),
        MyRoutes.secureHomeRoute: (context) => SecureHome(entity: Entity()),
        MyRoutes.secureAdminHomeRoute: (context) => const SecureAdmin(),
        MyRoutes.forgotpasswordRoute: (context) => const ForgotPassword(),
        MyRoutes.PrivacyPolicyRoute: (context) => const PrivacyPolicy()
      },
    );
  }
}
