import 'package:get/get.dart';
import 'package:nofap/Components/gnav.dart';
import 'package:nofap/screens/Pages/Onboarding.dart';
import 'package:nofap/screens/Pages/Home/homescreen.dart';
import 'package:nofap/screens/Rewards/rewards.dart';
import 'package:nofap/screens/errorscreen.dart';

class AppRoutes {
  static const String home = '/';
  static const String gnav = '/gnav';
  static const String onboarding = '/onboarding';
  static const String error = '/error';
  static const String game = '/game';

  static final List<GetPage> pages = [
    GetPage(name: home,transition:Transition.cupertinoDialog, page: () => const HomeScreen()),
    GetPage(name: onboarding, page: () => const Onboarding()),
    GetPage(name: error, page: () => const ErrorScreen()),
    GetPage(name: gnav, page: () => const BottomNavBar()),
    GetPage(name: game, page: () =>  SimpleAudioScreen())
  ];
}
