import 'dart:math';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/bank_payment_model.dart';
import 'package:pathana_school_app/models/paymentinfo_model.dart';
import 'package:pathana_school_app/models/qrcode_ldb_model.dart';
import 'package:pathana_school_app/pages/payment_success.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pathana_school_app/services/service_api.dart';
import 'package:pathana_school_app/states/history_payment_state.dart';
import 'package:pathana_school_app/states/payment_state.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/print_bill_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

class PaymentLdbState extends GetxController {
  ServiceApi serviceApi = ServiceApi();
  Repository repository = Repository();
  List<BankPaymentModel> bankPaymentList = [];
  PaymentState paymentState = Get.put(PaymentState());
  bool checkQrcode = false;
  QrcodeLDBModel? qrcodeLDBModel;
  PaymentInfo? paymentInfo;
  String accessTokens = '';
  String ref2s = '';
  String transactionIds = '';
  String xClientTransactionDatetimes = '';
  String digests = '';
  String createds = '';
  String expireses = '';
  String signatures = '';
  num totalDebt = 0;
  updateTotalDebt(num t){
   totalDebt = t;
   update();
  }
  Future<http.Response> getbankPayments({
    required String id,
    required String type,
    required List<dynamic> cartList,
  }) async {
    bankPaymentList = [];
    var res = await repository
        .post(url: '${repository.urlApi}api/bankPayments', auth: true, body: {
      "id": id,
      'payment_line': jsonEncode(cartList),
      "type": type,
    });
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        bankPaymentList.add(BankPaymentModel.fromJson(item));
      }
      totalDebt = num.parse(jsonDecode(res.body)['total_debt'].toString());
      update();
      return res;
    } else {
      return res;
    }
  }

  Future<void> fetchAuthToken(
      {required String clientId,
      required String clientSecret,
      required String billCode,
      required double amount,
      required String merchantId,
      required String partnerId,
      required String signatureSecret,
      required String phone,
      required String id,
      required String type,
      required String totalDebt,
      required List<dynamic> cartList,
      required String bankId}) async {
    final String authUri =
        "${serviceApi.ldbApi}/vbox-oauth2/v2/authorise/token";
    try {
      checkQrcode = false;
      qrcodeLDBModel = null;
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
        accessTokens = jsonDecode(response.body)['access_token'];
        initiateQRPayment(
            billCode: billCode,
            amount: amount,
            merchantId: merchantId,
            accessToken: accessTokens,
            partnerId: partnerId,
            signatureSecret: signatureSecret,
            phone: phone,
            id: id,
            cartList: cartList,
            bankId: bankId,
            type: type,
            totalDebt: totalDebt);
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
      {required String billCode,
      required String id,
      required List<dynamic> cartList,
      required String bankId,
      required double amount,
      required String merchantId,
      required String accessToken,
      required String partnerId,
      required String signatureSecret,
      required String phone,
      required String type,
      required String totalDebt}) async {
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
        qrcodeLDBModel =
            QrcodeLDBModel.fromJson(jsonDecode(response.body)['dataResponse']);
        postUpdateTransactionIdPayment(
            id: id,
            type: type,
            transactionIdPayment: transactionIds,
            bankId: bankId,
            cartList: cartList,
            accessToken: accessToken,
            xClientTransactionDatetime: xClientTransactionDatetimes,
            partnerId: partnerId,
            digest: digests,
            created: createds,
            expires: expireses,
            signature: signatures,
            reference2: ref2s,
            totalDebt: totalDebt);
      }
    } catch (e) {
      //print("Exception: $e");
    }
  }

  postUpdateTransactionIdPayment({
    required String id,
    required String type,
    required String transactionIdPayment,
    required String bankId,
    required List<dynamic> cartList,
    required String accessToken,
    required String xClientTransactionDatetime,
    required String partnerId,
    required String digest,
    required String created,
    required String expires,
    required String signature,
    required String reference2,
    required String totalDebt,
  }) async {
    try {
      var res;
      if (type == 'one') {
        res = await repository.post(
            url: '${repository.urlApi}api/update_transactionId_payment',
            body: {
              "id": id,
              'transactionId_payment': transactionIdPayment,
              'bank_id': bankId,
              "type": type,
              'accessToken': accessToken,
              'xClientTransactionDatetime': xClientTransactionDatetime,
              'partnerId': partnerId,
              'digest': digest,
              'qr_created': created,
              'qr_expires': expires,
              'signature': signature,
              'reference2': reference2,
              'totalDebt': totalDebt
            },
            auth: true);
      } else {
        res = await repository.post(
            url: '${repository.urlApi}api/update_transactionId_payment',
            body: {
              "id": id,
              'transactionId_payment': transactionIdPayment,
              'bank_id': bankId,
              'payment_line': jsonEncode(cartList),
              "type": type,
              'accessToken': accessToken,
              'xClientTransactionDatetime': xClientTransactionDatetime,
              'partnerId': partnerId,
              'digest': digest,
              'qr_created': created,
              'qr_expires': expires,
              'signature': signature,
              'reference2': reference2,
              'totalDebt': totalDebt
            },
            auth: true);
      }
      if (res.statusCode == 200) {
        checkQrcode = true;
        update();
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
  }

  checkPayment(
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
      required List<dynamic> cartList}) async {
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
      var decodedJson = jsonDecode(res.body);
      String paymentRef = decodedJson['dataResponse']['txnItem'][0]
              ['paymentReference']
          .toString();
      paymentInfo =
          PaymentInfo.fromJson(decodedJson['dataResponse']['txnItem'][0]);
      update();
      postPayment(
          id: id,
          paymentId: paymentRef,
          amount: amount,
          type: type,
          cartList: cartList);
    }
  }

  postPayment(
      {required String id,
      required String paymentId,
      required String amount,
      required String type,
      String? note,
      required List<dynamic> cartList}) async {
    try {
      var res;
      if (type == 'one') {
        res = await repository.post(
            url: repository.urlApi + repository.updatePayment,
            body: {
              "id": id,
              "amount": amount,
              "paymentId": paymentId,
              "note": note ?? '',
              "type": type
            },
            auth: true);
      } else {
        res = await repository.post(
            url: repository.urlApi + repository.updatePayment,
            body: {
              "id": id,
              "amount": amount,
              "paymentId": paymentId,
              "note": note ?? '',
              "type": type,
              'payment_line': jsonEncode(cartList)
            },
            auth: true);
      }
      if (res.statusCode == 200) {
        if (type == 'many') {
          paymentState.clearData();
        }
        checkQrcode = false;
        qrcodeLDBModel = null;
        update();
        CustomDialogs().showToast(
          // ignore: deprecated_member_usev
          backgroundColor: AppColor().green,
          text: '${"Pay_tuition_fees".tr} ${"success".tr}',
        );
        if (res.body['data'].toString() != '[]') {
           await Get.off(() => PrintBillWidget(data: res.body['data']));
        }else {
          Get.off(
                  () =>
                  PaymentSuccess(
                      paymentId: paymentId,
                      paymentInfo: paymentInfo,
                      note: note),
              transition: Transition.fadeIn);
        }
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
  }

  //check payment back
  HistoryPaymentState historyPaymentState = Get.put(HistoryPaymentState());
  checkPaymentInfo({
    required String id,
    required String transactionId,
    required String accessToken,
    required String xClientTransactionDatetime,
    required String partnerId,
    required String digest,
    required String created,
    required String expires,
    required String signature,
    required String reference2,
    required String status,
  }) async {
    try {
      CustomDialogs().dialogLoading();
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
      // print('6666666666666');
      // print(res.body);
      Get.back();
      if (res.statusCode == 401 || jsonDecode(res.body)['status'] == "05") {
        checkPaymentTransaction(
            id: id,
            transactionIdPayment: transactionId,
            paymentId: '',
            type: 'cancel',
            status: status);
      } else if (res.statusCode == 200) {
        var decodedJson = jsonDecode(res.body);
        paymentInfo =
            PaymentInfo.fromJson(decodedJson['dataResponse']['txnItem'][0]);
        update();
        if (paymentInfo != null) {
          checkPaymentTransaction(
              id: id,
              transactionIdPayment: transactionId,
              paymentId: paymentInfo!.paymentReference.toString(),
              type: 'ok',
              status: status);
        }
      } else {
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().red.withOpacity(0.8),
          text: 'something_went_wrong',
        );
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
  }

  checkPaymentTransaction({
    required String id,
    required String transactionIdPayment,
    required String paymentId,
    required String type,
    required String status,
  }) async {
    try {
      var res = await repository.post(
          url: '${repository.urlApi}api/checkPaymentTransaction',
          body: {
            "id": id,
            "transactionId_payment": transactionIdPayment,
            'paymentId': paymentId,
            'type': type
          },
          auth: true);
      Get.back();
      if (res.statusCode == 200) {
        if (type == 'ok') {
          CustomDialogs().showToast(
            // ignore: deprecated_member_use
            backgroundColor: AppColor().green,
            text: '${"Pay_tuition_fees".tr} ${"success".tr}',
          );
          if (paymentInfo != null) {
            Get.to(
                () => PaymentSuccess(
                    paymentId: paymentId,
                    paymentInfo: paymentInfo!,
                    note: 'Pay_tuition_fees'),
                transition: Transition.fadeIn);
          }
        } else {
          await historyPaymentState.getListStudents(type: status);
          CustomDialogs().showToast(
            backgroundColor: AppColor().red,
            text: 'This_bill_has_not_been_paid_yet',
          );
        }
      } else {
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().red.withOpacity(0.8),
          text: 'something_went_wrong',
        );
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
  }
  // end
}
