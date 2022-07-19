import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/services/google_sign_in_services.dart';
import 'package:jutta_ghar/views/splash_screen.dart';
import 'package:jutta_ghar/utils/utils.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {});
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvieder(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: Utils.messangerKey,
        title: 'Jutta Ghar',
        theme: ThemeData(),
        home: const SplashScreen(),
      ),
    );
  }
}
