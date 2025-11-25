import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/check_lang.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/models/admin_school_dashboard.dart';
import 'package:multiple_school_app/models/bank_payment_model.dart';
import 'package:multiple_school_app/pages/adminschool/generate_qrcode_payment_package.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/states/adminschool/admin_payment_package_state.dart';
import 'package:multiple_school_app/states/payment_ldb_state.dart';
import 'package:multiple_school_app/widgets/custom_circle_load.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:multiple_school_app/widgets/text_field_widget.dart';

class AdminPaymentPackage extends StatefulWidget {
  const AdminPaymentPackage(
      {super.key, required this.data, required this.index});
  final AdminDashboardModel data;
  final int index;
  @override
  State<AdminPaymentPackage> createState() => _AdminPaymentPackageState();
}

class _AdminPaymentPackageState extends State<AdminPaymentPackage> {
  final monthQty = TextEditingController();
  final note = TextEditingController();
  AdminPaymentPackageState adminPaymentPackageState =
      Get.put(AdminPaymentPackageState());
  PaymentLdbState paymentLdbState = Get.put(PaymentLdbState());
  final searchT = TextEditingController();
  AppColor appColor = AppColor();
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    adminPaymentPackageState.getData(
        branchId: widget.data.packages![widget.index].id.toString());
    paymentLdbState.getbankPayments(id: '0', type: '', cartList: []);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CustomText(text: 'payment', color: appColor.mainColor),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: appColor.mainColor,
            )),
        centerTitle: true,
        elevation: 4,
        surfaceTintColor: appColor.white,
      ),
      body: GetBuilder<AdminPaymentPackageState>(builder: (getD) {
        if (getD.loading == true) {
          return Column(
            children: [
              Expanded(child: Center(child: CircleLoad())),
            ],
          );
        }
        if (getD.data == null) {
          return Column(
            children: [
              Expanded(
                  child: Center(
                      child: CustomText(
                text: 'not_found_data',
                color: appColor.grey,
                fontSize: fixSize(0.02, context),
              ))),
            ],
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appColor.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: CheckLang(
                                nameLa: widget
                                        .data.packages![widget.index].nameLa ??
                                    '',
                                nameEn: widget
                                        .data.packages![widget.index].nameEn ??
                                    '')
                            .toString(),
                        color: appColor.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: fixSize(0.0185, context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: '${"student".tr}${"all".tr}: ',
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                          CustomText(
                            text:
                                '${FormatPrice(price: num.parse(getD.data!.studentCount.toString()))} ${"people".tr}',
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 'm',
                                groupValue: adminPaymentPackageState.payType,
                                onChanged: (v) {
                                  adminPaymentPackageState.updatePayType(v!);
                                  adminPaymentPackageState.calTotalPaid(
                                      num.parse(
                                          getD.data?.studentCount.toString() ??
                                              '0'),
                                      num.parse(
                                          getD.data?.pricePerStudent ?? '0'),
                                      num.parse(monthQty.text.toString()),
                                      num.parse(
                                          getD.data?.packageDiscount ?? '0'),
                                      adminPaymentPackageState.payType);
                                },
                                activeColor: appColor.mainColor,
                              ),
                              CustomText(
                                text: 'month',
                                color: appColor.mainColor,
                                fontSize: fixSize(0.0165, context),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 'y',
                                groupValue: adminPaymentPackageState.payType,
                                onChanged: (v) {
                                  adminPaymentPackageState.updatePayType(v!);
                                  adminPaymentPackageState.calTotalPaid(
                                      num.parse(
                                          getD.data?.studentCount.toString() ??
                                              '0'),
                                      num.parse(
                                          getD.data?.pricePerStudent ?? '0'),
                                      num.parse(monthQty.text.toString()),
                                      num.parse(
                                          getD.data?.packageDiscount ?? '0'),
                                      adminPaymentPackageState.payType);
                                },
                                activeColor: appColor.mainColor,
                              ),
                              CustomText(
                                text: 'year',
                                color: appColor.mainColor,
                                fontSize: fixSize(0.0165, context),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextFielWidget(
                        width: size.width,
                        height: fixSize(0.05, context),
                        icon: Icons.person,
                        hintText: 'qty'.tr,
                        fixSize: fixSize(1, context),
                        appColor: appColor,
                        controller: monthQty,
                        borderRaduis: 5.0,
                        margin: 0,
                        contentPadding: EdgeInsets.only(left: 8),
                        textInputType: TextInputType.number,
                        onChanged: (v) {
                          adminPaymentPackageState.calTotalPaid(
                              num.parse(
                                  getD.data?.studentCount.toString() ?? '0'),
                              num.parse(getD.data?.pricePerStudent ?? '0'),
                              num.parse(v),
                              num.parse(getD.data?.packageDiscount ?? '0'),
                              adminPaymentPackageState.payType);
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomText(
                        text:
                            '${"price".tr}: ${FormatPrice(price: num.parse(getD.data?.pricePerStudent ?? '0'))} ₭/ຄົນ',
                        color: appColor.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: fixSize(0.0165, context),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appColor.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'grand_total',
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                          CustomText(
                            text:
                                '${FormatPrice(price: num.parse(adminPaymentPackageState.totalPaid.toString())).toString()} LAK',
                            color: appColor.blueLight,
                            fontSize: fixSize(0.0165, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text:
                                '${"discount".tr}(${FormatPrice(price: num.parse(getD.data?.packageDiscount ?? '0'))}%)',
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                          CustomText(
                            text:
                                '${FormatPrice(price: num.parse(adminPaymentPackageState.discount.toString())).toString()} LAK',
                            color: appColor.red,
                            fontSize: fixSize(0.0165, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "total",
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                          CustomText(
                            text:
                                '${FormatPrice(price: num.parse((adminPaymentPackageState.totalPaid - adminPaymentPackageState.discount).toString())).toString()} LAK',
                            color: appColor.green,
                            fontSize: fixSize(0.0165, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextFielWidget(
                  width: size.width,
                  height: fixSize(0.05, context),
                  icon: Icons.person,
                  hintText: 'note'.tr,
                  fixSize: fixSize(1, context),
                  appColor: appColor,
                  controller: note,
                  borderRaduis: 5.0,
                  margin: 0,
                  contentPadding: EdgeInsets.only(left: 8),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: size.height * 0.02),
                GetBuilder<PaymentLdbState>(builder: (bankPayment) {
                  if (bankPayment.bankPaymentList.isEmpty) {
                    return const SizedBox();
                  }
                  return ListView.builder(
                      itemCount: bankPayment.bankPaymentList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              if (monthQty.text.isEmpty) {
                                CustomDialogs().showToast(
                                  backgroundColor:
                                      // ignore: deprecated_member_use
                                      AppColor().red.withOpacity(0.8),
                                  text: 'please_enter_all',
                                );
                              } else {
                                final bankItem =
                                    bankPayment.bankPaymentList[index];

                                // Validate based on bankId
                                if (bankItem.bankId == 1) {
                                  if (_hasBank1Fields(bankItem)) {
                                    _showErrorToast();
                                    return;
                                  }
                                } else if (bankItem.bankId == 2) {
                                  if (_hasBank2Fields(bankItem)) {
                                    _showErrorToast();
                                    return;
                                  }
                                }

                                // Navigate to GenerateQrcodePaymentPackage
                                Get.to(() => GenerateQrcodePaymentPackage(
                                      id: widget.data.packages![widget.index].id
                                          .toString(),
                                      bankId: bankItem.bankId.toString(),
                                      type: adminPaymentPackageState.payType,
                                      data: adminPaymentPackageState.data!,
                                      qty: monthQty.text,
                                      note: note.text,
                                      billerID: bankItem.billerID ?? '',
                                      storeID: bankItem.storeID ?? '',
                                      terminalID: bankItem.terminalID ?? '',
                                      ref2: bankItem.ref2 ?? '',
                                      amount: _formatAmount(
                                          adminPaymentPackageState),
                                      clientId: bankItem.clientId ?? '',
                                      clientSecret: bankItem.clientSecret ?? '',
                                      merchantId: bankItem.mERCHANTID ?? '',
                                      partnerId: bankItem.partnerId ?? '',
                                      signatureSecret:
                                          bankItem.signatureSecretKey ?? '',
                                      phone: bankItem.phone ?? '',
                                    ));
                              }
                            },
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: appColor.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: size.width * 0.1,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${Repository().nuXtJsUrlApi}${bankPayment.bankPaymentList[index].logo}",
                                          imageBuilder:
                                              (context, imageProvider) =>
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
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  decoration: BoxDecoration(
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
                                                        .bankPaymentList[index]
                                                        .nameLa ??
                                                    '',
                                                nameEn: bankPayment
                                                        .bankPaymentList[index]
                                                        .nameEn ??
                                                    '',
                                                nameCn: bankPayment
                                                        .bankPaymentList[index]
                                                        .nameEn ??
                                                    '')
                                            .toString(),
                                        fontSize: fixSize(0.01650, context),
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
                      });
                })
              ],
            ),
          ),
        );
      }),
      // bottomNavigationBar:
      //     GetBuilder<AdminPaymentPackageState>(builder: (check) {
      //   if (check.data == null) {
      //     return const SizedBox();
      //   }
      //   return ButtonWidget(
      //       height: fixSize(0.05, context),
      //       width: fixSize(0.05, context),
      //       color: appColor.white,
      //       // ignore: deprecated_member_use
      //       backgroundColor: appColor.mainColor.withOpacity(0.8),
      //       fontSize: fixSize(0.0185, context),
      //       fontWeight: FontWeight.bold,
      //       borderRadius: 0,
      //       onPressed: () async {
      //         if (monthQty.text.isEmpty) {
      //           CustomDialogs().showToast(
      //             // ignore: deprecated_member_use
      //             backgroundColor: AppColor().red.withOpacity(0.8),
      //             text:
      //                 'please_enter_all', // Message for "Entered amount is too large"
      //           );
      //         } else {
      //           Get.to(() => GenerateQrcodePaymentPackage(
      //               id: widget.data.packages![widget.index].id.toString(),
      //               type: adminPaymentPackageState.payType,
      //               data: adminPaymentPackageState.data!,
      //               qty: monthQty.text,
      //               note: note.text,
      //               amount: FormatPrice(
      //                       price: num.parse(
      //                           (adminPaymentPackageState.totalPaid -
      //                                   adminPaymentPackageState.discount)
      //                               .toString()))
      //                   .toString()
      //                   .replaceAll(',', '.')));
      //         }
      //       },
      //       text: 'next');
      // }),
    );
  }

  // Helper methods
  bool _hasBank1Fields(BankPaymentModel item) {
    return item.billerID == '' ||
        item.storeID == '' ||
        item.terminalID == '' ||
        item.ref2 == '';
  }

  bool _hasBank2Fields(BankPaymentModel item) {
    return item.clientId == '' ||
        item.clientSecret == '' ||
        item.mERCHANTID == '' ||
        item.partnerId == '' ||
        item.signatureSecretKey == '' ||
        item.phone == '';
  }

  void _showErrorToast() {
    CustomDialogs().showToast(
      // ignore: deprecated_member_use
      backgroundColor: AppColor().red.withOpacity(0.8),
      text: 'something_went_wrong',
    );
  }

  String _formatAmount(AdminPaymentPackageState state) {
    return FormatPrice(
            price: num.parse((state.totalPaid - state.discount).toString()))
        .toString()
        .replaceAll(',', '');
  }
}
