import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/main.dart';
import 'package:pathana_school_app/states/call_student_state.dart';

class InitListenNoti extends GetxController {
  CallStudentState callStudentState = Get.put(CallStudentState());
  final NotificationDetails _platformChannelSpecifics = NotificationDetails(
    android: AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      channelDescription: androidNotificationChannel.description,
      importance: Importance.max,
      color: AppColor().mainColor,
      // ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
    ),
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  getInit() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Detailed log for foreground notifications
      try {
        print('[InitListenNoti] onMessage: '
            'title=${message.notification?.title}, '
            'body=${message.notification?.body}, '
            'data=${message.data}');
      } catch (_) {}

      RemoteNotification notification = message.notification!;
      await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          (notification.title ?? '').tr,
          (notification.body ?? '').tr,
          _platformChannelSpecifics);
      try {
        print('[InitListenNoti] ✅ Local notification displayed (foreground).');
      } catch (_) {}
      if (Get.currentRoute == '/TakeChildrenPage') {
        callStudentState.getData('1', 'noti');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      try {
        print('[InitListenNoti] onMessageOpenedApp: data=${message.data}');
      } catch (_) {}

      RemoteNotification notification = message.notification!;
      await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          (notification.title ?? '').tr,
          (notification.body ?? '').tr,
          _platformChannelSpecifics);
    });
  }
}
