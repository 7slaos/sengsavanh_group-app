import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/check_payment_model.dart';
import 'package:pathana_school_app/models/laoqr_model.dart';
import 'package:pathana_school_app/models/paymentinfo_model.dart';
import 'package:pathana_school_app/pages/payment_success.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/services/service_api.dart';
import 'package:pathana_school_app/states/history_payment_state.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';

class PaymentState extends GetxController {
  final monthYear = TextEditingController();
  Repository rep = Repository();
  ServiceApi serviceApi = ServiceApi();
  LaoQrModel? laoQrModel;
  CheckPaymentModel? checkPaymentModel;
  PaymentInfoModel? paymentInfoModel;
  bool checkLaoQr = false;
  List<dynamic> cartList = [];
  bool check = false;
  bool checkID = false;
  double sumtotal = 0.0;
  clearCart() {
    cartList.clear();
    update();
  }

  addTocart(
      {required int id,
      required String firstname,
      String? lastname,
      required String billerID,
      required String storeID,
      required String terminalID,
      required String ref2,
      required String month,
      required double total}) async {
    checkID = false;
    for (int i = 0; i < cartList.length; i++) {
      if (cartList[i]['id'].toString() == id.toString()) {
        checkID = true;
      }
    }
    if (checkID == false) {
      Map<String, dynamic> map = {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'total': total,
        'billerID': billerID,
        'storeID': storeID,
        'terminalID': terminalID,
        'month': month,
        'ref2': ref2,
      };
      cartList.add(map);
    }
    update();
    sumTotal();
  }

  sumTotal() {
    sumtotal = 0;
    for (int i = 0; i < cartList.length; i++) {
      sumtotal += double.parse(cartList[i]['total'].toString());
    }
    update();
  }

  deleteCart(int id) {
    for (int i = 0; i < cartList.length; i++) {
      if (cartList[i]['id'] == id) {
        cartList.removeAt(i);
        update();
      }
    }
    update();
    sumTotal();
  }

  clearData() {
    laoQrModel = null;
    checkPaymentModel = null;
    paymentInfoModel = null;
    checkList = [];
    cartList = [];
    update();
  }

  List<bool> checkList = [];
  updateCheckBox(int index, bool c) {
    checkList[index] = c;
    update();
  }

  generateLaoQrcode({
    required String feeInvoiceId,
    required double amount,
    required String ref1,
    required String ref2,
    required String billerID,
    required String storeID,
    required String terminalID,
    required String type,
    required String bankId,
    required String totalDebt,
  }) async {
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
      if (res.statusCode == 200) {
        laoQrModel = LaoQrModel.fromJson(jsonDecode(res.body));
      }
      update();
      if (laoQrModel != null) {
        postUpdateTransactionIdPayment(
            id: feeInvoiceId,
            transactionIdPayment: laoQrModel!.transactionId.toString(),
            bankId: bankId,
            type: type,
            totalDebt: totalDebt);
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
  }

  postUpdateTransactionIdPayment({
    required String id,
    required String type,
    required String transactionIdPayment,
    required String bankId,
    required String totalDebt,
  }) async {
    try {
      var res;
      if (type == 'one') {
        res = await rep.post(
            url: '${rep.urlApi}api/update_transactionId_payment',
            body: {
              "id": id,
              'transactionId_payment': transactionIdPayment,
              'bank_id': bankId,
              "type": type,
              'totalDebt': totalDebt
            },
            auth: true);
      } else {
        res = await rep.post(
            url: '${rep.urlApi}api/update_transactionId_payment',
            body: {
              "id": id,
              'transactionId_payment': transactionIdPayment,
              'bank_id': bankId,
              'payment_line': jsonEncode(cartList),
              "type": type,
              'totalDebt': totalDebt
            },
            auth: true);
      }
      if (res.statusCode == 200) {
        checkLaoQr = true;
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
      required String transactionId,
      required String amount,
      required String type,
      required String totalDebt,
      String? note}) async {
    try {
      var res = await rep.post(
          url: serviceApi.checkPayment, body: {"transactionId": transactionId});
      if (res.statusCode == 200) {
        checkPaymentModel = CheckPaymentModel.fromJson(jsonDecode(res.body));
        update();
        if (checkPaymentModel != null) {
          pyamentInfo(
              id: id,
              paymentId: checkPaymentModel!.paymentId!,
              amount: amount,
              note: note,
              type: type,
              totalDebt: totalDebt);
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

  postPayment(
      {required String id,
      required String paymentId,
      required String amount,
      required String type,
      required String totalDebt,
      String? note}) async {
    try {
      var res;
      if (type == 'one') {
        res = await rep.post(
            url: rep.urlApi + rep.updatePayment,
            body: {
              "id": id,
              "amount": amount,
              "paymentId": paymentId,
              "note": note ?? '',
              "type": type,
              "total_debt": totalDebt
            },
            auth: true);
      } else {
        res = await rep.post(
            url: rep.urlApi + rep.updatePayment,
            body: {
              "id": id,
              "amount": amount,
              "paymentId": paymentId,
              "note": note ?? '',
              "type": type,
              "total_debt": totalDebt,
              'payment_line': jsonEncode(cartList)
            },
            auth: true);
      }
      if (res.statusCode == 200) {
        cartList = [];
        checkList = [];
        update();
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green,
          text: '${"Pay_tuition_fees".tr} ${"success".tr}',
        );
        Get.off(
            () => PaymentSuccess(
                paymentId: paymentId, data: paymentInfoModel!, note: note),
            transition: Transition.fadeIn);
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
  }

  pyamentInfo(
      {required String id,
      required String paymentId,
      required String amount,
      required String type,
      required String totalDebt,
      String? note}) async {
    try {
      var res = await rep
          .post(url: serviceApi.paymentInfo, body: {"paymentId": paymentId});
      if (res.statusCode == 200) {
        paymentInfoModel = PaymentInfoModel.fromJson(jsonDecode(res.body));
        update();
        final decodedBody = jsonDecode(res.body);
        if (paymentInfoModel != null && decodedBody['res_desc'] == 'success') {
          laoQrModel = null;
          update();
          postPayment(
              id: id,
              paymentId: paymentId,
              amount: amount,
              note: note,
              type: type,
              totalDebt: totalDebt
              );
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

  postPaymentCash(
      {required String id, required String amount, String? note, required String payType, required String payDate}) async {
    try {
      CustomDialogs().dialogLoading();
      var res = await rep.post(
          url: '${rep.urlApi}api/updatePaymentCash',
          body: {"id": id, "amount": amount, "note": note ?? '','pay_type': payType, 'pay_date': payDate},
          auth: true);
      Get.back();
      if (res.statusCode == 200) {
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green,
          text: '${"Pay_tuition_fees".tr} ${"success".tr}',
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

  //check payment back
  HistoryPaymentState historyPaymentState = Get.put(HistoryPaymentState());
  checkPaymentInfo(
      {required String id,
      required String transactionId,
      required String status}) async {
    try {
      CustomDialogs().dialogLoading();
      var res = await rep.post(
          url: serviceApi.checkPayment, body: {"transactionId": transactionId});
      if (jsonDecode(res.body)['res_code'] == "91") {
        checkPaymentTransaction(
            id: id,
            transactionIdPayment: transactionId,
            paymentId: '',
            type: 'cancel',
            status: status);
      } else if (res.statusCode == 200) {
        checkPaymentModel = CheckPaymentModel.fromJson(jsonDecode(res.body));
        update();
        if (checkPaymentModel != null) {
          checkpyamentInfoSTB(
              id: id,
              transactionId: transactionId,
              paymentId: checkPaymentModel!.paymentId.toString(),
              status: status);
        }
      } else {
        Get.back();
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

  checkpyamentInfoSTB({
    required String id,
    required String paymentId,
    required String transactionId,
    required String status,
  }) async {
    try {
      var res = await rep
          .post(url: serviceApi.paymentInfo, body: {"paymentId": paymentId});
      if (res.statusCode == 200) {
        paymentInfoModel = PaymentInfoModel.fromJson(jsonDecode(res.body));
        update();
        final decodedBody = jsonDecode(res.body);
        if (paymentInfoModel != null && decodedBody['res_desc'] == 'success') {
          checkPaymentTransaction(
              id: id,
              transactionIdPayment: transactionId,
              paymentId: checkPaymentModel!.paymentId.toString(),
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
      var res = await rep.post(
          url: '${rep.urlApi}api/checkPaymentTransaction',
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
          if (paymentInfoModel != null) {
            Get.to(
                () => PaymentSuccess(
                    paymentId: paymentId,
                    data: paymentInfoModel!,
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
