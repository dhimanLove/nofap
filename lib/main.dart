import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nofap/routes/routes.dart';
import 'package:nofap/screens/Pages/Home/homescreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
   Get.put(HomeController());

  // Set full-screen immersive mode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky, // better than just immersive
  );

  // Force portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, 
      systemNavigationBarColor: Colors.transparent, // navigation bar transparent
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NoFap Tracker',
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.gnav,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
