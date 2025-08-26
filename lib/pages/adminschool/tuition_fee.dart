import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/format_price.dart';
import 'package:pathana_school_app/models/history_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/adminschool/admin_tuition_fee_state.dart';
import 'package:pathana_school_app/states/payment_ldb_state.dart';
import 'package:pathana_school_app/states/payment_state.dart';
import 'package:pathana_school_app/states/superadmin/super_admin_state.dart';
import 'package:pathana_school_app/widgets/button_widget.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/shimmer_listview.dart';
import 'package:pathana_school_app/widgets/text_field_widget.dart';

import '../../functions/check_lang.dart';
import '../generate_qrcode_payment.dart';
import '../generate_qrcode_payment_ldb.dart';

class TuitionFee extends StatefulWidget {
  const TuitionFee({super.key, required this.type, required this.branchId});
  final String type;
  final String branchId;
  @override
  State<TuitionFee> createState() => _TuitionFeeState();
}

class _TuitionFeeState extends State<TuitionFee> {
  AdminTuitionFeeState adminTuitionFeeState = Get.put(AdminTuitionFeeState());
  PaymentState paymentState = Get.put(PaymentState());
  PaymentLdbState paymentLdbState = Get.put(PaymentLdbState());
  final amountT = TextEditingController();
  final note = TextEditingController();
  final searchT = TextEditingController();
  AppColor appColor = AppColor();
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    //superAdminState.setCurrentDate();
    Future.delayed(Duration(seconds: 5));
    adminTuitionFeeState.getData('', '',
        type: widget.type, branchId: widget.branchId);
  }

  SuperAdminState superAdminState = Get.put(SuperAdminState());
  void showBottomDialog() {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.grey[200],
      builder: (context) {
        return GetBuilder<SuperAdminState>(builder: (getSale) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                height: size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomText(
                        text: 'start_date',
                        fontSize: fixSize(0.0185, context),
                      ),
                      TextField(
                        controller: superAdminState.startDate,
                        readOnly: true,
                        onChanged: (value) {
                          Future.delayed(Duration(seconds: 3));
                          // adminExpenseState.getData(
                          //     superAdminState.startDate.text,
                          //     superAdminState.endDate.text);
                        },
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () {
                                superAdminState.selectDate(context, 'start');
                              }),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomText(
                        text: 'end_date',
                        fontSize: fixSize(0.0185, context),
                      ),
                      TextField(
                        controller: superAdminState.endDate,
                        readOnly: true,
                        onChanged: (value) {
                          Future.delayed(Duration(seconds: 3));
                          adminTuitionFeeState.getData(
                              superAdminState.startDate.text,
                              superAdminState.endDate.text,
                              type: widget.type,
                              branchId: widget.branchId);
                        },
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () {
                                superAdminState.selectDate(context, 'end');
                              }),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Expanded(child: Container()),
                      ButtonWidget(
                          height: size.height * 0.08,
                          borderRadius: 10,
                          backgroundColor: appColor.mainColor,
                          onPressed: () async {
                            if (superAdminState.startDate.text != '' &&
                                superAdminState.endDate.text != '') {
                              adminTuitionFeeState.getData(
                                  superAdminState.startDate.text,
                                  superAdminState.endDate.text,
                                  type: widget.type,
                                  branchId: widget.branchId);
                            }
                            Get.back();
                          },
                          fontSize: fixSize(0.0165, context),
                          text: 'search'),
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
        });
      },
    );
  }

  void showPaymentDialog(HistoryModel data) {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.grey[200],
      builder: (context) {
        return GetBuilder<AdminTuitionFeeState>(builder: (getState) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                height: size.height * 0.95,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: size.height * 0.04,
                              width: 4,
                              color: appColor.mainColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText(
                              text: 'Pay_tuition_fees',
                              fontSize: fixSize(0.02, context),
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                      ),
                      CustomText(
                        text: 'date',
                        fontSize: fixSize(0.0165, context),
                      ),
                      TextField(
                        controller: superAdminState.payDate,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () {
                                superAdminState.selectDate(context, 'pay');
                              }),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                      CustomText(
                          fontSize: fixSize(0.0165, context),
                          text:
                              '${data.firstname ?? ""} ${data.lastname ?? ""}'),
                      CustomText(
                          fontSize: fixSize(0.0165, context),
                          text: '${"class".tr}: ${data.myClass ?? ""}',
                          color: appColor.grey),
                      CustomText(
                          fontSize: fixSize(0.0165, context),
                          text: DateFormat('MM/yyyy')
                              .format(DateFormat('d/MM/yyyy')
                                  .parse(data.issueDate.toString()))
                              .toString(),
                          color: appColor.grey),
                      if (paymentLdbState.totalDebt > 0) ...[
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
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 'c',
                                groupValue: adminTuitionFeeState.paymentType,
                                onChanged: (v) {
                                  adminTuitionFeeState.updatePaymentType(v!);
                                },
                                activeColor: appColor.mainColor,
                              ),
                              CustomText(
                                text: 'cash',
                                color: appColor.mainColor,
                                fontSize: fixSize(0.0165, context),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 't',
                                groupValue: adminTuitionFeeState.paymentType,
                                onChanged: (v) {
                                  setState(() {
                                    amountT.text = '';
                                  });
                                  adminTuitionFeeState.updatePaymentType(v!);
                                },
                                activeColor: appColor.mainColor,
                              ),
                              CustomText(
                                text: 'transfer',
                                color: appColor.mainColor,
                                fontSize: fixSize(0.0165, context),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: CustomText(
                          text:
                              '${FormatPrice(price: num.parse(data.totalDebt.toString()) + paymentLdbState.totalDebt)} LAK',
                          fontSize: fixSize(0.0225, context),
                          color: appColor.red,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFielWidget(
                        width: size.width,
                        height: size.height * 0.08,
                        icon: Icons.person,
                        hintText: 'amount'.tr,
                        fixSize: fixSize(1, context),
                        appColor: appColor,
                        controller: amountT,
                        borderRaduis: 5.0,
                        margin: 0,
                        contentPadding: EdgeInsets.only(left: 8),
                        textInputType: TextInputType.number,
                        onChanged: (v) {
                          if (num.parse(v.toString()) >
                              (num.parse(data.totalDebt.toString()) +
                                  paymentLdbState.totalDebt)) {
                            setState(() {
                              amountT.text =
                                  (num.parse(data.totalDebt.toString()) +
                                          paymentLdbState.totalDebt)
                                      .toString();
                            });
                          }
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFielWidget(
                        width: size.width,
                        height: size.height * 0.08,
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
                      if (adminTuitionFeeState.paymentType != 'c') ...[
                        SizedBox(height: size.height * 0.02),
                        GetBuilder<PaymentLdbState>(builder: (bankPayment) {
                          if (bankPayment.bankPaymentList.isEmpty) {
                            return const SizedBox();
                          }
                          return Expanded(
                              child: ListView.builder(
                                  itemCount: bankPayment.bankPaymentList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          if (amountT.text.trim() == '') {
                                            CustomDialogs().showToast(
                                              // ignore: deprecated_member_use
                                              backgroundColor: AppColor()
                                                  .red
                                                  .withOpacity(0.8),
                                              text:
                                                  'please_enter_all', // Message for "Entered amount is too large"
                                            );
                                            return;
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
                                            Get.back();
                                            Get.to(
                                                () => GenerateQrcodePaymentLdb(
                                                      type: 'one',
                                                      billCode: '',
                                                      id: data.id.toString(),
                                                      bankId: bankPayment
                                                          .bankPaymentList[
                                                              index]
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
                                                      amount: (num.parse(amountT
                                                              .text
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
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: size.width * 0.1,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${Repository().urlApi}${bankPayment.bankPaymentList[index].logo}",
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(
                                                        color:
                                                            appColor.mainColor,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                                    fontSize: fixSize(
                                                        0.01650, context),
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
                        })
                      ],
                      if (adminTuitionFeeState.paymentType == 'c') ...[
                        Expanded(child: Container()),
                        ButtonWidget(
                            height: size.height * 0.08,
                            borderRadius: 10,
                            backgroundColor: appColor.mainColor,
                            onPressed: () async {
                              if (amountT.text.trim() == '') {
                                CustomDialogs().showToast(
                                  // ignore: deprecated_member_use
                                  backgroundColor:
                                      AppColor().red.withOpacity(0.8),
                                  text:
                                      'please_enter_all', // Message for "Entered amount is too large"
                                );
                                return;
                              }
                              Get.back();
                              paymentState.postPaymentCash(
                                  id: data.id.toString(),
                                  amount: amountT.text.toString(),
                                  payType:
                                      adminTuitionFeeState.paymentType == 'c'
                                          ? '1'
                                          : '2',
                                  payDate: superAdminState.payDate.text);
                            },
                            fontSize: fixSize(0.0165, context),
                            text: 'confirm')
                      ],
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
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CustomText(
            text: widget.type == 'debt'
                ? 'outstanding_tuition_fees'
                : widget.type,
            color: appColor.mainColor),
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
        actions: [
          IconButton(
              onPressed: () {
                showBottomDialog();
              },
              icon: Icon(
                Icons.calendar_month,
                color: appColor.mainColor,
              ))
        ],
      ),
      body: GetBuilder<AdminTuitionFeeState>(builder: (getD) {
        if (getD.data == null && getD.loading == true) {
          return ShimmerListview();
        }
        if (getD.data == null && getD.loading == false) {
          return Column(
            children: [
              Expanded(
                child: Center(
                    child: CustomText(
                  text: 'not_found_data',
                  color: appColor.grey,
                  fontSize: fixSize(0.0185, context),
                )),
              ),
            ],
          );
        }
        var value = getD.data!.items!
            .where((e) =>
                (e.firstname ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()) ||
                (e.lastname ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()) ||
                (e.myClass ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()))
            .toList();
        return Column(
          children: [
            GetBuilder<SuperAdminState>(builder: (getDate) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: 4,
                      color: appColor.mainColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      text:
                          '${"start_date".tr}: ${getDate.startDate.text} - ${getDate.endDate.text}',
                      fontSize: fixSize(0.0165, context),
                      color: appColor.grey,
                    )
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchT, // Attach the controller
                onChanged: (value) {
                  adminTuitionFeeState.update();
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  labelText: 'search'.tr,
                  // ignore: deprecated_member_use
                  fillColor: appColor.white.withOpacity(0.98),
                  filled: true,

                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: appColor.grey),
                  ),

                  // Customize the focused border
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.5, // Customize width
                      color: appColor
                          .mainColor, // Change this to your desired color
                    ),
                  ),
                  // Optionally, you can also change the enabled border
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.5,
                      color: appColor.grey,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: appColor.mainColor,
                onRefresh: () async {
                  superAdminState.clearData();
                  getData();
                },
                child: ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final item = value[index];
                    final amount = num.parse((widget.type == 'debt'
                            ? item.totalDebt
                            : widget.type == 'all'
                                ? item.total
                                : item.totalPaid)
                        .toString());
                    return InkWell(
                      onTap: () async {
                        // setState(() {
                        //   amountT.text = value[index].totalDebt.toString();
                        // });
                        var res = await paymentLdbState.getbankPayments(
                            id: value[index].id.toString(),
                            type: 'one',
                            cartList: []);
                        if (res.statusCode == 200) {
                          superAdminState.setCurrentDate();
                          showPaymentDialog(value[index]);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(color: appColor.white),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(5.0),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.type == 'paid') ...[
                                CustomText(
                                    text:
                                        '${item.firstname ?? ""} ${item.lastname ?? ""}'),
                                CustomText(
                                    text:
                                        '${"class".tr}: ${item.myClass ?? ""}',
                                    color: appColor.grey),
                                CustomText(
                                    text: DateFormat('MM/yyyy')
                                        .format(DateFormat('d/MM/yyyy')
                                            .parse(item.issueDate.toString()))
                                        .toString(),
                                    color: appColor.grey),
                              ],
                              if (widget.type != 'paid') ...[
                                CustomText(
                                    text:
                                        '${item.firstname ?? ""} ${item.lastname ?? ""}'),
                                CustomText(
                                    text:
                                        '${"class".tr}: ${item.myClass ?? ""}',
                                    color: appColor.grey),
                                CustomText(
                                    text: DateFormat('MM/yyyy')
                                        .format(DateFormat('d/MM/yyyy')
                                            .parse(item.issueDate.toString()))
                                        .toString(),
                                    color: appColor.grey),
                              ],
                            ],
                          ),
                          trailing: widget.type != 'paid'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        text:
                                            '${FormatPrice(price: num.parse(item.total.toString()))}',
                                        color: appColor.darkBlue,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomText(
                                        text:
                                            '${FormatPrice(price: num.parse(item.totalPaid.toString()))}',
                                        color: appColor.green,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomText(
                                        text:
                                            '${FormatPrice(price: num.parse(item.totalDebt.toString()))}',
                                        color: appColor.red,
                                      ),
                                    ),
                                  ],
                                )
                              : CustomText(
                                  text: '${FormatPrice(price: amount)}',
                                  fontSize: fixSize(0.0145, context),
                                  color: appColor.green),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        );
      }),
      bottomNavigationBar: GetBuilder<AdminTuitionFeeState>(builder: (getData) {
        if (getData.data == null) {
          return const SizedBox();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: appColor.white, boxShadow: [
                BoxShadow(
                    blurRadius: fixSize(0.0025, context),
                    offset: const Offset(0, 1),
                    color: appColor.grey)
              ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: '${"all".tr}:',
                          fontSize: fixSize(0.0185, context),
                          color: appColor.mainColor),
                      CustomText(
                          text:
                              '${FormatPrice(price: num.parse(getData.data!.items!.length.toString()))} ${"items".tr}',
                          fontSize: fixSize(0.0185, context),
                          color: appColor.mainColor),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: '${"total".tr}:',
                          fontSize: fixSize(0.0185, context),
                          color: appColor.mainColor),
                      CustomText(
                          text:
                              '${FormatPrice(price: num.parse(getData.data?.total ?? '0'))} ₭',
                          fontSize: fixSize(0.0185, context),
                          color: appColor.mainColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
