import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotificationHandler {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings("@drawable/ic_notification"),
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  /// FIREBASE NOTIFICATION SETUP
  static Future<void> firebaseNotificationSetup() async {
    ///local notification...
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
/*
    ///IOS Setup
    DarwinInitializationSettings initializationSettings =
        const DarwinInitializationSettings(
            requestAlertPermission: true,
            requestSoundPermission: true,
            requestBadgePermission: true);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );*/

    // Update the iOS foreground notification presentation options to allow
    // heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    ///Get FCM Token..
    await getFcmToken();
  }

  ///background notification handler..
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    // debugPrint('Handling a background message ${message.messageId}');
  }

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "high_importance_channel", // id
      'high_importance_channel', // title
      description: "high_importance_channel", // description
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'));

  ///get fcm token
  static Future<void> getFcmToken() async {
    debugPrint("=========fcm- Error :");
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    try {
      String? token = await firebaseMessaging.getToken();

      debugPrint("fcm-token :  $token");
    } catch (e) {
      debugPrint("=========fcm- Error :$e");
      return;
    }
  }

  ///call when app in fore ground
  static Future<void> showMsgHandler() async {
    // debugPrint('showMsgHandler...');
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;

        // AndroidNotification? android = message.notification?.android;

        // debugPrint("-=-=-=-=-$message");
        // debugPrint("-=-=-=-=-${message.data}");

        // log('Notification Call :$android  ${notification?.apple}title---- ${notification!.title} body--- ${notification.body}');
        if (notification != null) {
          showMsg(notification, message.data);
        }
      },
      onDone: () {
        // debugPrint("remort on tap ++++++++++++++");
      },
      onError: (s, o) {
        // debugPrint("remort on tap errr+++++++++++++ $o   $s   $o");
      },
    ).onError((e) {
      // debugPrint('Error Notification : ....$e');
    });
  }

  /// handle notification when app in fore ground..
  static void getInitialMsg() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      // debugPrint(
      //     'tap on noti fication =========  $message  =======================');
    });
  }

  ///show notification msg
  static void showMsg(
      RemoteNotification notification, Map<String, dynamic> time) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "high_importance_channel", // id
          'high_importance_channel', // title
          // "high_importance_channel",
          // description
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          playSound: true,
          //    sound: RawResourceAndroidNotificationSound('notification_sound')
        ),
      ),
    );
  }

  ///call when click on notification
  static onMsgOpen() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (
        RemoteMessage message,
      ) async {
        debugPrint("-=-=-1=-=-$message");
        // debugPrint("-=-=-1=-=-${message.notification!.title}");
        // debugPrint("-=-=-1=-=-${message.notification!.body}");
        debugPrint("-=-=-1=-=-${message.data}");

        // var dir = await DownloadsPathProvider.downloadsDirectory;

        // OpenFile.open("$dir");

        // // debugPrint("========  OnTap  =======");
        // if (message.data.toString() != "{}" ||
        //     message.data['type'] == "pay") {
        //   setRoute(message: message);
        // }
      },
      onDone: () {
        // debugPrint("remort on tap");
      },
      onError: (s, o) {
        // debugPrint("remort on tap errro   $s   $o");
      },
    );
  }
}
