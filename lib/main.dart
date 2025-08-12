import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
  }
  await Singleton.instance.appInit();

  ///await Firebase.initializeApp();
  initializeDependencies();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Future.delayed(Duration(seconds: 2));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tohfa",
      theme: theme().copyWith(),
      debugShowCheckedModeBanner: false,
      initialRoute: _getRout(),
      // home: ReportScreen(),
      routes: AppRoutes.routes,
      navigatorKey: NavigatorService.navigatorKey,
    );
  }
}

SystemUiOverlayStyle _systemOverlay() {
  return SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.backGroundColor,
    systemNavigationBarDividerColor: AppColors.transparent,
    statusBarColor: AppColors.primaryColor,
    statusBarIconBrightness: Brightness.light,
  );
}

String _getRout() {
  // return AppRoutes.validatePhoneScreen;
  // return AppRoutes.loginOptionScreen;
  return AppRoutes.splashScreen;
}
