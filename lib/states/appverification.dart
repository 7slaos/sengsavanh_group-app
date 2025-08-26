import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class AppVerification extends GetxController {
  GetStorage storage = GetStorage();
  String role = "";
  String token = "";
  String nUxtToken = "";
  Map<String, dynamic> mapOTP = {};
  setInitToken() {
    token = storage.read('token') ?? "";
    role = storage.read('role') ?? "";
    nUxtToken = storage.read('nUxtToken') ?? "";
    update();
  }

  setNewToken({required String text, required String role, String? nUxtToken}) async {
    await storage.write('token', text);
    await storage.write('role', role);
    token = storage.read('token') ?? "";
    role = storage.read('role') ?? "";
    update();
  }

  setNewNUxtToken({required String token}) async {
    await storage.write('nUxtToken', token);
    nUxtToken = storage.read('nUxtToken') ?? "";
    update();
  }

  removeToken() async {
    await storage.write('token', "");
    await storage.write('role', "");
    await storage.write('nUxtToken', "");
    token = "";
    role = "";
    nUxtToken = "";
    update();
  }

  getAmountToUseOTP() async {
    mapOTP = storage.read('otpamount') ?? {};

    if (mapOTP['time'] is String) {
      if (DateTime.now().difference(DateTime.parse(mapOTP['time'])).inHours >=
          24) {
        await removeAmountOTP();
      }
    }

    //customPrint("this Otp Amounts2 is  $mapOTP");
    update();
  }

  addAmountOTP({required Map<String, dynamic> value}) async {
    if (mapOTP['count'] != 5) {
      await storage.write('otpamount', {
        'count': value['count'] + (mapOTP['count'] ?? 0),
        'time': DateTime.now().toString()
      });
      getAmountToUseOTP();
    }

    update();
  }

  removeAmountOTP() async {
    //customPrint('remove OTP');
    await storage.write('otpamount', {});
    mapOTP = {};
    update();
  }
}
