import 'package:e_commerce/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51MzCaWSGodUMKXcxltotmpwHSMxqWdOqYuVZ1nIXAISaHsevioN1yvnRHiIOV9dTNuKJLfvRIGuI3af7sFrVk6zE00mHT7XHqv";
  await Stripe.instance.applySettings();

  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then(
    (value) => debugPrint(
      "firebase initialize successfully",
    ),
  );
  AppNotificationHandler.firebaseNotificationSetup();
  AppNotificationHandler.getInitialMsg();
  AppNotificationHandler.showMsgHandler();
  AppNotificationHandler.onMsgOpen();
  runApp(
    const ThemeDataDemo(),
  );
}

class ThemeDataDemo extends StatelessWidget {
  const ThemeDataDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: Splash(),
    );
  }
}
