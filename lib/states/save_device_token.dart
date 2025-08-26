import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/appverification.dart';

class SaveDeviceTokenState extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Repository rep = Repository();
  AppVerification appVerification = Get.put(AppVerification());

  postSaveDeviceToken() async {
    await _firebaseMessaging.getToken().then((token) async {
      var res = await rep.post(
          url: rep.urlApi + rep.saveDeviceToken,
          auth: true,
          body: {'device_token': token ?? ''});
      // print('1111111111111111111111111111111111111111111111111111111111111111');
      // print(res.body);
      // print(token);
      if (kDebugMode) {
        if (res.statusCode == 200) {
          print('save token success');
        } else {
          print('save token failed');
        }
      }
    });
  }
}
