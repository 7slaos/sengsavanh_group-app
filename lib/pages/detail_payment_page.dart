import 'package:cached_network_image/cached_network_image.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/check_lang.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/models/history_model.dart';
import 'package:multiple_school_app/pages/generate_qrcode_payment.dart';
import 'package:multiple_school_app/pages/generate_qrcode_payment_ldb.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/states/appverification.dart';
import 'package:multiple_school_app/states/date_picker_state.dart';
import 'package:multiple_school_app/states/detail_payment_state.dart';
import 'package:multiple_school_app/states/history_payment_state.dart';
import 'package:multiple_school_app/states/home_state.dart';
import 'package:multiple_school_app/states/payment_ldb_state.dart';
import 'package:multiple_school_app/states/payment_state.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/widgets/print_bill_widget.dart';

// ignore: must_be_immutable
class DetailPaymentPage extends StatefulWidget {
  DetailPaymentPage({super.key, required this.data});
  HistoryModel? data;

  @override
  State<DetailPaymentPage> createState() => _DetailPaymentPageState();
}

class _DetailPaymentPageState extends State<DetailPaymentPage> {
  LocaleState localeState = Get.put(LocaleState());
  PaymentState paymentState = Get.put(PaymentState());
  PaymentLdbState paymentLdbState = Get.put(PaymentLdbState());
  DatePickerState datePickerState = Get.put(DatePickerState());
  DetailPaymentState detailPaymentState = Get.put(DetailPaymentState());
  HomeState homeState = Get.put(HomeState());
  AppVerification appVerification  =  Get.put(AppVerification());
  HistoryPaymentState historyPaymentState = Get.put(HistoryPaymentState());
  final amountMoneyController = TextEditingController();
  final note = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Pay_tuition_fees',
          fontSize: fSize * 0.0185,
          // color: appColor.white,
        ),
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.white,
        centerTitle: true,
      ),
      backgroundColor: appColor.mainColor,
      body: Container(
        height: size.height * 1,
        width: size.width,
        decoration: BoxDecoration(
          color: appColor.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height, // Ensures the content fills the height
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text:
                        '${'bill_no'.tr}:', // Ensure this is properly translated
                    fontSize: fixSize(
                        0.0165, context), // Ensure this returns a valid size
                    fontWeight: FontWeight.w500,
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data!.name ??
                        '', // Ensure this is properly translated
                    fontSize: fixSize(0.0165, context),
                    fontWeight: FontWeight.w500,
                  ),
                  const Divider(),
                  CustomText(
                      text:
                          '${'student'.tr}:', // Ensure this is properly translated
                      fontSize: fixSize(
                          0.0165, context), // Ensure this returns a valid size
                      fontWeight: FontWeight.w500,
                      color: appColor.grey),
                  CustomText(
                    text:
                        '${widget.data!.firstname ?? ''} ${widget.data!.lastname ?? ''}', // Ensure this is properly translated
                    fontSize: fixSize(0.0165, context),
                    fontWeight:
                        FontWeight.w500, // Ensure this returns a valid size
                  ),
                  const Divider(),
                  CustomText(
                      text:
                          '${'total'.tr}:', // Ensure this is properly translated
                      fontSize: fixSize(
                          0.0165, context), // Ensure this returns a valid size
                      fontWeight: FontWeight.w500,
                      color: appColor.grey),
                  CustomText(
                    text: FormatPrice(
                      price: num.parse(
                        widget.data!.total != null
                            ? widget.data!.total.toString()
                            : '0',
                      ),
                    ).toString(), // Ensure this is properly translated
                    fontSize: fixSize(
                        0.0165, context), // Ensure this returns a valid size
                    color: appColor.blueLight,
                    fontWeight: FontWeight.w600,
                  ),
                  const Divider(),
                  CustomText(
                      text:
                          '${'discount'.tr}:', // Ensure this is properly translated
                      fontSize: fixSize(
                          0.0165, context), // Ensure this returns a valid size
                      fontWeight: FontWeight.w500,
                      color: appColor.grey),
                  CustomText(
                    text: "- ${FormatPrice(
                      price: num.parse(widget.data!.discount != null
                          ? widget.data!.discount.toString()
                          : '0'),
                    ).toString()}", // Ensure this is properly translated
                    fontSize: fixSize(
                        0.0165, context), // Ensure this returns a valid size
                    fontWeight: FontWeight.bold,
                    // ignore: deprecated_member_use
                    color: appColor.orange,
                  ),
                  const Divider(),
                  CustomText(
                      text:
                          '${'special_discount'.tr}:', // Ensure this is properly translated
                      fontSize: fixSize(
                          0.0165, context), // Ensure this returns a valid size
                      fontWeight: FontWeight.w500,
                      color: appColor.grey),
                  CustomText(
                      text:
                          "- ${FormatPrice(price: num.parse(widget.data!.discountPhiset != null ? widget.data!.discountPhiset.toString() : '0')).toString()}", // Ensure this is properly translated
                      fontSize: fixSize(0.0165, context),
                      fontWeight: FontWeight.bold,
                      color: appColor.orange),
                  if (widget.data?.discountLines != null &&
                      widget.data!.discountLines!.isNotEmpty) ...[
                    const Divider(),
                    CustomText(
                      text: '${"Get_discount_policy".tr}:',
                      fontSize: fixSize(0.0165, context),
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 100, // Adjust height as needed
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics:
                            NeverScrollableScrollPhysics(), // Prevents scrolling inside another scrollable widget
                        itemCount: widget.data!.discountLines!.length,
                        itemBuilder: (context, index) {
                          var d = widget.data!.discountLines![index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: d.name ?? '',
                                fontSize: fixSize(0.0165, context),
                                fontWeight: FontWeight.w500,
                                color: appColor.grey,
                              ),
                              CustomText(
                                text: "- ${FormatPrice(
                                  price: num.tryParse(
                                          d.discount?.toString() ?? '0') ??
                                      0,
                                ).toString()}",
                                fontSize: fixSize(0.0165, context),
                                fontWeight: FontWeight.bold,
                                color: appColor.orange,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  const Divider(),
                  CustomText(
                      text:
                          '${'total_paid'.tr}:', // Ensure this is properly translated
                      fontSize: fixSize(
                          0.0165, context), // Ensure this returns a valid size
                      fontWeight: FontWeight.w500,
                      color: appColor.grey),
                  CustomText(
                    text: FormatPrice(
                      price: num.parse(widget.data!.totalPaid != null
                          ? widget.data!.totalPaid.toString()
                          : '0'),
                    ).toString(), // Ensure this is properly translated
                    fontSize: fixSize(
                        0.0165, context), // Ensure this returns a valid size
                    fontWeight: FontWeight.bold,
                    color: appColor.green,
                  ),
                  const Divider(),
                  CustomText(
                    text:
                        '${'total_debt'.tr}:', // Ensure this is properly translated
                    fontSize: fixSize(
                        0.0165, context), // Ensure this returns a valid size
                    fontWeight: FontWeight.w500,
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: FormatPrice(
                      price: num.parse(widget.data!.totalDebt.toString()),
                    ).toString(), // Ensure this is properly translated
                    fontSize: fixSize(
                        0.0165, context), // Ensure this returns a valid size
                    fontWeight: FontWeight.bold,
                    color: appColor.red,
                  ),
                  if ((widget.data!.paymentLine?.isNotEmpty ?? false)) ...[
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: fixSize(0.03, context)),
                        CustomText(
                          text: 'payment_history',
                          fontSize: fixSize(0.0160,
                              context), // Ensure this returns a valid size
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    ListView.builder(
                      shrinkWrap:
                          true, // Important to avoid infinite height issue
                      physics:
                          NeverScrollableScrollPhysics(), // Prevents ListView from scrolling separately
                      itemCount: widget.data!.paymentLine!.length,
                      itemBuilder: (context, i) {
                        var payment = widget.data!.paymentLine![i];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                                top:
                                    BorderSide(width: 1, color: appColor.grey)),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: '${"date".tr} ${payment.billDated ?? ''}',
                                fontSize: fixSize(0.0165, context),
                                color: appColor.mainColor,
                                fontWeight: FontWeight.w500,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: FormatPrice(
                                            price: num.tryParse(
                                                    payment.subtotal ?? '0') ??
                                                0)
                                        .toString(),
                                    fontSize: fixSize(0.0165, context),
                                    fontWeight: FontWeight.w500,
                                    color: appColor.red,
                                  ),
                                  payment.payType == 1
                                      ? CustomText(
                                          text: 'cash',
                                          fontSize: fixSize(0.0165, context),
                                          fontWeight: FontWeight.w500,
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            CustomText(
                                              text: 'transfer',
                                              fontSize:
                                                  fixSize(0.0165, context),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            CustomText(
                                              text: payment.billNumber ?? '',
                                              fontSize:
                                                  fixSize(0.0140, context),
                                              fontWeight: FontWeight.w500,
                                              color: appColor.grey,
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                  const Divider(),
                  SizedBox(height: size.height * 0.02),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: num.parse(widget.data?.totalDebt ?? '0') > 0
          ? FloatingActionButton(
              backgroundColor: appColor.mainColor,
              shape: CircleBorder(),
              onPressed: () async {
                try {
                  var res = await paymentLdbState.getbankPayments(
                    id: widget.data!.id.toString(),
                    type: 'one',
                    cartList: [],
                  );
                  if (res.statusCode == 200) {
                    showBottomDialog();
                  } else if (res.statusCode == 402) {
                    Get.back();
                    CustomDialogs().showToast(
                      // ignore: deprecated_member_use
                      backgroundColor: AppColor().red.withOpacity(0.8),
                      text:
                          '${"Please_pay_the_tuition_fee".tr} ${"month".tr} ${jsonDecode(res.body)['message']}',
                    );
                  }
                  // ignore: empty_catches
                } catch (e) {}
              },
              child: Icon(
                Icons.add,
                color: appColor.white,
              ),
            )
          : const SizedBox()
    );
  }

  void showBottomDialog() {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            SizedBox(
              height: size.height * 0.85,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: '${"Payment_amount".tr}:',
                          fontSize: fixSize(0.0185, context),
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 8),
                        CustomText(
                          text: FormatPrice(
                                  price: (num.parse(
                                          widget.data?.totalDebt.toString() ??
                                              '0') +
                                      paymentLdbState.totalDebt))
                              .toString(),
                          fontSize: fixSize(0.0185, context),
                          color: appColor.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    CustomText(
                      text: '${"Tuition_fees".tr}:',
                      fontSize: fixSize(0.01650, context),
                    ),
                    CustomText(
                      text: FormatPrice(
                              price: num.parse(
                                  widget.data?.totalDebt.toString() ?? '0'))
                          .toString(),
                      fontSize: fixSize(0.01650, context),
                      fontWeight: FontWeight.bold,
                      color: appColor.red,
                    ),
                    CustomText(
                      text: '${"Adjust".tr}:',
                      fontSize: fixSize(0.01650, context),
                    ),
                    CustomText(
                      text: FormatPrice(
                              price: num.parse(
                                  paymentLdbState.totalDebt.toString()))
                          .toString(),
                      fontSize: fixSize(0.01650, context),
                      fontWeight: FontWeight.bold,
                      color: appColor.red,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    TextField(
                      controller: note,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: appColor.mainColor)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'note'.tr,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    GetBuilder<PaymentLdbState>(builder: (bankPayment) {
                      if (bankPayment.bankPaymentList.isEmpty) {
                        return const SizedBox();
                      }
                      return Expanded(
                          child: ListView.builder(
                              itemCount: bankPayment.bankPaymentList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      Get.back();
                                      if (bankPayment
                                              .bankPaymentList[index].bankId ==
                                          1) {
                                        Get.to(
                                            () => GenerateQrcodePayment(
                                                  type: 'one',
                                                  id: widget.data!.id
                                                      .toString(),
                                                  bankId: bankPayment
                                                      .bankPaymentList[index]
                                                      .bankId
                                                      .toString(),
                                                  billerID: bankPayment
                                                      .bankPaymentList[index]
                                                      .billerID,
                                                  storeID: bankPayment
                                                      .bankPaymentList[index]
                                                      .storeID,
                                                  terminalID: bankPayment
                                                      .bankPaymentList[index]
                                                      .terminalID,
                                                  ref2: bankPayment
                                                      .bankPaymentList[index]
                                                      .ref2,
                                                  amount: (num.parse(widget
                                                          .data!.totalDebt
                                                          .toString()))
                                                      .toString(),
                                                  note: note.text,
                                                  totalDebt: paymentLdbState
                                                      .totalDebt
                                                      .toString(),
                                                ),
                                            transition: Transition.fadeIn);
                                      } else if (bankPayment
                                                  .bankPaymentList[index]
                                                  .bankId ==
                                              2 &&
                                          bankPayment.bankPaymentList[index]
                                                  .mERCHANTID !=
                                              '' &&
                                          bankPayment.bankPaymentList[index]
                                                  .clientId !=
                                              '' &&
                                          bankPayment.bankPaymentList[index]
                                                  .clientSecret !=
                                              '' &&
                                          bankPayment.bankPaymentList[index]
                                                  .partnerId !=
                                              '' &&
                                          bankPayment.bankPaymentList[index]
                                                  .signatureSecretKey !=
                                              '') {
                                        Get.to(
                                            () => GenerateQrcodePaymentLdb(
                                                  type: 'one',
                                                  billCode: '',
                                                  id: widget.data!.id
                                                      .toString(),
                                                  bankId: bankPayment
                                                      .bankPaymentList[index]
                                                      .bankId
                                                      .toString(),
                                                  clientId: bankPayment
                                                          .bankPaymentList[
                                                              index]
                                                          .clientId ??
                                                      '',
                                                  clientSecret: bankPayment
                                                          .bankPaymentList[
                                                              index]
                                                          .clientSecret ??
                                                      '',
                                                  merchantId: bankPayment
                                                          .bankPaymentList[
                                                              index]
                                                          .mERCHANTID ??
                                                      '',
                                                  parnetId: bankPayment
                                                          .bankPaymentList[
                                                              index]
                                                          .partnerId ??
                                                      '',
                                                  amount: (num.parse(widget
                                                          .data!.totalDebt
                                                          .toString()))
                                                      .toString(),
                                                  note: note.text,
                                                  signatureSecret: bankPayment
                                                          .bankPaymentList[
                                                              index]
                                                          .signatureSecretKey ??
                                                      '',
                                                  phone: bankPayment
                                                          .bankPaymentList[
                                                              index]
                                                          .phone ??
                                                      '',
                                                  cartList: [],
                                                  totalDebt: paymentLdbState
                                                      .totalDebt
                                                      .toString(),
                                                ),
                                            transition: Transition.fadeIn);
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          decoration: BoxDecoration(
                                              color: appColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: size.width * 0.1,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${Repository().nuXtJsUrlApi}${bankPayment.bankPaymentList[index].logo}",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(
                                                    color: appColor.mainColor,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/logo.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              CustomText(
                                                text: CheckLang(
                                                        nameLa: bankPayment
                                                                .bankPaymentList[
                                                                    index]
                                                                .nameLa ??
                                                            '',
                                                        nameEn: bankPayment
                                                                .bankPaymentList[
                                                                    index]
                                                                .nameEn ??
                                                            '',
                                                        nameCn: bankPayment
                                                                .bankPaymentList[
                                                                    index]
                                                                .nameEn ??
                                                            '')
                                                    .toString(),
                                                fontSize:
                                                    fixSize(0.01650, context),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: appColor.grey,
                                          size: fixSize(0.0135, context),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }));
                    }),
                  ],
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Get.back();
              },
              child: CircleAvatar(
                backgroundColor: appColor.mainColor,
                child: Icon(
                  Icons.close,
                  color: appColor.white,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
