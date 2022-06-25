import 'package:e_commerce/firebase_options.dart';
import 'package:e_commerce/screens/login/login.dart';
import 'package:e_commerce/screens/main_screen/components/dashboard/dashboard.dart';
import 'package:e_commerce/screens/main_screen/main_screen.dart';
import 'package:e_commerce/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      // Don't show debug banner in debug builds.
      debugShowCheckedModeBanner: false,
      enableLog: true,
      theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: appPrimaryColor)),
      darkTheme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: appPrimaryColor)),
      getPages: [
        GetPage(name: Login.routeName, page: () => const Login()),
        GetPage(name: MainScreen.routeName, page: () => const MainScreen()),
        GetPage(name: Dashboard.routeName, page: () => const Dashboard()),
      ],
      initialRoute: MainScreen.routeName,
    );
  }
}
