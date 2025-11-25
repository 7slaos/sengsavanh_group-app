import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/models/check_payment_model.dart';
import 'package:multiple_school_app/models/laoqr_model.dart';
import 'package:multiple_school_app/models/paymentinfo_model.dart';
import 'package:multiple_school_app/models/setting_payment_package_model.dart';
import 'package:multiple_school_app/pages/adminschool/payment_package_success.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/services/service_api.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AdminPaymentPackageState extends GetxController {
  Repository rep = Repository();
  ServiceApi serviceApi = ServiceApi();
  LaoQrModel? laoQrModel;
  CheckPaymentModel? checkPaymentModel;
  PaymentInfoModel? paymentInfoModel;
  PaymentInfo? paymentInfo;
  bool checkLaoQr = false;
  String accessTokens = '';
  String ref2s = '';
  String transactionIds = '';
  String xClientTransactionDatetimes = '';
  String digests = '';
  String createds = '';
  String expireses = '';
  String signatures = '';
  SettingPaymentPackageModel? data;
  bool loading = true;
  String payType = 'm';
  num totalPaid = 0.00;
  num discount = 0.00;
  calTotalPaid(num student, num price, num qty, num percent, String type) {
    totalPaid = (student * price) * (type == 'y' ? qty * 12 : qty);
    discount = totalPaid * (percent / 100);
    update();
  }

  updatePayType(String t) {
    payType = t;
    update();
  }

  getData({required String branchId}) async {
    loading = true;
    data = null;
    var res = await rep.post(
        url:
            '${rep.nuXtJsUrlApi}api/Application/AdminSchoolController/get_setting_payment',
        body: {'id': branchId},
        auth: true);
    // print(res.body);
    if (res.statusCode == 200) {
      data = SettingPaymentPackageModel.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes))['data']);
    }
    loading = false;
    update();
  }

  clearData() {
    laoQrModel = null;
    checkPaymentModel = null;
    paymentInfoModel = null;
    update();
  }

  generateLaoQrcode(
      {required double amount,
      required String ref1,
      required String ref2,
      required String billerID,
      required String storeID,
      required String terminalID}) async {
    try {
      checkLaoQr = false;
      var res = await rep.post(url: serviceApi.generateLaoQr, body: {
        "billerCode": "STB",
        "billerID": billerID,
        "ref1": ref1,
        "ref2": ref2,
        "amount": amount.toString(),
        "currencyCode": "LAK",
        "storeID": storeID,
        "terminalID": terminalID,
        "merchantName": "STB"
      });
      // print('99999999999999999999999999999999');
      // print(ref1);
      // print(res.body);
      if (res.statusCode == 200) {
        laoQrModel = LaoQrModel.fromJson(
            jsonDecode(utf8.decode(res.bodyBytes)));
      }
      checkLaoQr = true;
      update();
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text:
            'something_went_wrong', // Message for "Entered amount is too large"
      );
    }
  }

  checkPayment(
      {required String transactionId,
      required String id,
      required String total,
      required String type,
      required String studentCount,
      required String price,
      required String qty,
      String? note}) async {
    try {
      var res = await rep.post(
          url: serviceApi.checkPayment, body: {"transactionId": transactionId});
      if (res.statusCode == 200) {
        checkPaymentModel = CheckPaymentModel.fromJson(
            jsonDecode(utf8.decode(res.bodyBytes)));
        update();
        if (checkPaymentModel != null) {
          pyamentInfo(
              id: id,
              total: total,
              paymentId: checkPaymentModel!.paymentId!,
              price: price,
              studentCount: studentCount,
              type: type,
              note: note,
              qty: qty);
        }
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text:
            'something_went_wrong', // Message for "Entered amount is too large"
      );
    }
  }

  postPayment(
      {required String id,
      required String paymentId,
      required String total,
      required String type,
      required String studentCount,
      required String price,
      required String qty,
      String? note}) async {
    try {
      var res = await rep.post(
          url: '${rep.nuXtJsUrlApi}api/Application/AdminSchoolController/admin_payment_package',
          body: {
            "id": id,
            "total": total,
            "ref_payment": paymentId,
            'type': type,
            'student_count': studentCount,
            'price': price,
            'qty': qty,
            'note': note ?? ''
          },
          auth: true);
      if (res.statusCode == 200) {
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green,
          text: 'success', // Message for "Entered amount is too large"
        );
        Get.back();
        Get.back();
        Get.off(
            () => PaymentPackageSuccess(
                paymentId: paymentId, data: paymentInfoModel!, note: note),
            transition: Transition.fadeIn);
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text:
            'something_went_wrong', // Message for "Entered amount is too large"
      );
    }
  }

  pyamentInfo(
      {required String id,
      required String paymentId,
      required String total,
      required String price,
      required String studentCount,
      required String type,
      required String qty,
      String? note}) async {
    try {
      var res = await rep
          .post(url: serviceApi.paymentInfo, body: {"paymentId": paymentId});
      if (res.statusCode == 200) {
        paymentInfoModel = PaymentInfoModel.fromJson(
            jsonDecode(utf8.decode(res.bodyBytes)));
        update();
        final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
        if (paymentInfoModel != null && decodedBody['res_desc'] == 'success') {
          laoQrModel = null;
          update();
          postPayment(
              id: id,
              paymentId: paymentId,
              total: total,
              price: price,
              studentCount: studentCount,
              type: type,
              qty: qty,
              note: note);
        }
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text:
            'something_went_wrong', // Message for "Entered amount is too large"
      );
    }
  }

  Future<void> fetchAuthToken(
      {required String clientId,
      required String clientSecret,
      required double amount,
      required String merchantId,
      required String partnerId,
      required String signatureSecret,
      required String phone}) async {
    final String authUri =
        "${serviceApi.ldbApi}/vbox-oauth2/v2/authorise/token";
    try {
      checkLaoQr = false;
      laoQrModel = null;
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';
      final response = await http.post(
        Uri.parse(authUri),
        headers: {
          'Authorization': basicAuth,
          'Content-Type':
              'application/x-www-form-urlencoded', // Important for form-data
        },
        body: {
          'grant_type': 'client_credentials', // Form-data field
        },
      );
      if (response.statusCode == 200) {
        accessTokens =
            jsonDecode(utf8.decode(response.bodyBytes))['access_token'];
        initiateQRPayment(
            amount: amount,
            merchantId: merchantId,
            accessToken: accessTokens,
            partnerId: partnerId,
            signatureSecret: signatureSecret,
            phone: phone);
      }
      // } else {
      //   print("Error: ${response.statusCode}, ${response.body}");
      // }
    } catch (e) {
      print("Exception: $e");
    }
  }

  String getClientTransactionDateTime() {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final millisecond = now.millisecond.toString().padLeft(3, '0');
    final timeZoneOffset = now.timeZoneOffset;
    final hours = timeZoneOffset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (timeZoneOffset.inMinutes % 60).toString().padLeft(2, '0');
    final sign = timeZoneOffset.isNegative ? '-' : '+';
    return '$year-$month-${day}T$hour:$minute:$second.$millisecond$sign$hours$minutes';
  }

  String createDigestHeader(String requestBody) {
    // 1. Compute SHA-256 hash of the request body
    final bytes = utf8.encode(requestBody);
    final digest = sha256.convert(bytes);
    // 2. Convert to Base64
    final base64Digest = base64.encode(digest.bytes);
    // 3. Format as digest header
    return 'SHA-256=$base64Digest';
  }

  String generateMatchingHmacSha256({
    required String digest,
    required String created,
    required String transactionId,
    required String secret,
  }) {
    final message = "digest: $digest\n"
        "(request-target): post /vboxConsumers/api/v1/qrpayment/initiate.service\n"
        "(created): $created\n"
        "x-client-transaction-id: $transactionId";
    final hmac = Hmac(sha256, utf8.encode(secret));
    final digestBytes = hmac.convert(utf8.encode(message));
    return base64.encode(digestBytes.bytes);
  }

  int generateSixDigitNumber() {
    final random = Random();
    return 100000 + random.nextInt(900000);
  }

  Future<void> initiateQRPayment(
      {required double amount,
      required String merchantId,
      required String accessToken,
      required String partnerId,
      required String signatureSecret,
      required String phone}) async {
    final String qrPayUri =
        "${serviceApi.ldbApi}/vboxConsumers/api/v1/qrpayment/initiate.service";
    var uuid = Uuid();
    transactionIds = uuid.v4();
    xClientTransactionDatetimes = getClientTransactionDateTime();
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    createds = currentTimestamp.toString();
    int expiryTimestamp = currentTimestamp + 3600;
    expireses = expiryTimestamp.toString();
    String ref1 = "CIT-${generateSixDigitNumber()}";
    ref2s = "CITREF-${generateSixDigitNumber()}";
    //ref2 = billCode;
    String ref3 = "CIT-${DateTime.now().year}";
    final requestBody = {
      "qrType": "LAO_QR",
      "platformType": "BROWSER",
      "merchantId": merchantId,
      "terminalId": null,
      "promotionCode": null,
      "expiryTime": "60",
      "makeTxnTime": "1",
      "amount": amount,
      "currency": "LAK",
      "ref1": ref1,
      "ref2": ref2s,
      "ref3": ref3,
      "mobileNum": phone,
      "deeplinkMetaData": {
        "deeplink": "Y",
        "switchBackURL": "https://your-deeplink.la?transaction=$ref2s",
        "switchBackInfo": "CIT Schools"
      },
      "metadata": "PAYMENT"
    };
    final bodyString = jsonEncode(requestBody);
    digests = createDigestHeader(bodyString);
    signatures = generateMatchingHmacSha256(
        digest: digests,
        transactionId: transactionIds,
        created: createds,
        secret: signatureSecret);
    try {
      final response = await http.post(Uri.parse(qrPayUri),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'x-client-transaction-id': transactionIds,
            'x-client-Transaction-datetime': xClientTransactionDatetimes,
            'partnerId': partnerId,
            'digest': digests,
            'signature':
                'keyId="key1",algorithm="hs2019",created=$createds,expires=$expireses,headers="digest (request-target) (created) x-client-transaction-id",signature="$signatures"',
            'Content-Type': 'application/json',
          },
          body: bodyString);
      // print('transactionId :$transactionIds');
      // print('datetime :$xClientTransactionDatetimes');
      // print('partnerId :$partnerId');
      // print('digest :$digests');
      // print('created :$createds');
      // print('expires :$expireses');
      // print('signature :$signatures');
      // print('ref2 :$ref2s');
      // print('taken :$accessToken');
      // print(response.body);
      if (response.statusCode == 200) {
        laoQrModel = LaoQrModel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes))['dataResponse']);
      }
      checkLaoQr = true;
      update();
    } catch (e) {
      //print("Exception: $e");
    }
  }

  checkPaymentLDB(
      {required String id,
      required String accessToken,
      required String transactionId,
      required String xClientTransactionDatetime,
      required String partnerId,
      required String digest,
      required String created,
      required String expires,
      required String signature,
      required String reference2,
      required String amount,
      String? note,
      required String type,
      required String price,
      required String qty,
      required String studentCount}) async {
    var res = await http.get(
        Uri.parse(
            'https://velab.ldblao.la/vboxConsumers/api/v1/qrpayment/$transactionId/inquiry.service?reference2=$reference2'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-client-transaction-id': transactionId,
          'x-client-Transaction-datetime': xClientTransactionDatetime,
          'partnerId': partnerId,
          'digest': digest,
          'signature':
              'keyId="key1",algorithm="hs2019",created=$created,expires=$expires,headers="digest (request-target) (created) x-client-transaction-id",signature="$signature"',
          'Content-Type': 'application/json',
        });
    // print('check payment 111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      var decodedJson = jsonDecode(utf8.decode(res.bodyBytes));
      String paymentRef = decodedJson['dataResponse']['txnItem'][0]
              ['paymentReference']
          .toString();
      paymentInfo =
          PaymentInfo.fromJson(decodedJson['dataResponse']['txnItem'][0]);
      update();
      postPayment(
          id: id,
          paymentId: paymentRef,
          total: amount,
          type: type,
          studentCount: studentCount,
          price: price,
          qty: qty);
    }
  }
}
