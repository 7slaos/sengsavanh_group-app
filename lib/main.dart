import 'dart:convert';
import 'dart:io';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/parent_recordes/take_children_page.dart';
import 'package:pathana_school_app/pages/splash_page.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/translate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pathana_school_app/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

const AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel(
  'flutter_id', // Keep it lowercase
  'Notification Messages',
  description: 'Channel for Firebase notifications',
  importance: Importance.high,
);

Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
}

//Initialize local notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void handleMessage(RemoteMessage message) {
  var keyData = jsonDecode(message.data['key']);
  if(keyData['key'] == 'call_student'){
      Get.to(() => TakeChildrenPage(), transition: Transition.fadeIn);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  Get.put(LocaleState());
  Get.put(AppVerification());

  HttpOverrides.global = MyHttpOverrides(); // Support for Android 12+

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for iOS notifications
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }
  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, sound: true, badge: true);
  }

  // Ensure notifications show in foreground
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  const DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: iosInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle click on notification when app is foregrounded
      RemoteMessage? message = response.payload != null
          ? RemoteMessage.fromMap({
              "data": {"type": response.payload}
            })
          : null;

      if (message != null) {
        handleMessage(message);
      }
    },
  );

  // **Foreground Notification Handling**
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidNotificationChannel.id,
            androidNotificationChannel.name,
            channelDescription: androidNotificationChannel.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: message.data['type'],
      );
    }
  });

  // **Background Message Handling**
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  // **Handle Notification Clicks**
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

  // **Handle Notification Click When App is Terminated**
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    handleMessage(initialMessage);
  }

  runApp(const MyApp());
}

// Support for Android 12+ HTTP Requests
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
//for main
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pathana School',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor().white),
        useMaterial3: true,
        fontFamily: "Noto Sans Lao",
      ),
      locale: const Locale('la', 'LA'),
      translations: Translate(),
      home: const SplashPage(),
    );
  }
}
