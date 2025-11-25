import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/check_lang.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/pages/detail_payment_page.dart';
import 'package:multiple_school_app/pages/generate_qrcode_payment.dart';
import 'package:multiple_school_app/pages/generate_qrcode_payment_ldb.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/states/home_state.dart';
import 'package:multiple_school_app/states/payment_ldb_state.dart';
import 'package:multiple_school_app/states/payment_state.dart';
import 'package:multiple_school_app/states/history_payment_state.dart';
import 'package:multiple_school_app/widgets/custom_app_bar.dart';
import 'package:multiple_school_app/widgets/custom_circle_load.dart';
import 'package:multiple_school_app/widgets/custom_date_widget.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryPaymentPage extends StatefulWidget {
  const HistoryPaymentPage({super.key, this.id, required this.type});
  final String type;
  final String? id;
  @override
  State<HistoryPaymentPage> createState() => _HistoryPaymentPageState();
}

class _HistoryPaymentPageState extends State<HistoryPaymentPage> {
  final searchT = TextEditingController();
  LocaleState localeState = Get.put(LocaleState());
  PaymentState paymentState = Get.put(PaymentState());
  PaymentLdbState paymentLdbState = Get.put(PaymentLdbState());
  HistoryPaymentState historyPaymentState = Get.put(HistoryPaymentState());
  CustomDateWidgetPickerState dateWidgetPickerState =
      Get.put(CustomDateWidgetPickerState());
  HomeState homeState = Get.put(HomeState());
  String type = 'all';
  final note = TextEditingController();
  updateIndex(String i) {
    setState(() {
      type = i;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    Future.delayed(Duration.zero);
    paymentState.clearData();
    await historyPaymentState.getListStudents(
        id: widget.id.toString(), type: 'all');
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();

    return Scaffold(
      backgroundColor: appColor.white,
      appBar: CustomAppBar(
        leading: IconButton(
            onPressed: () {
              if (widget.type == 't') {
                Get.back();
              } else {
                homeState.setCurrentPage(0);
              }
            },
            icon: Icon(Icons.arrow_back, color: appColor.white)),
        orientation: orientation,
        height: size.height,
        color: appColor.white,
        title: "Tuition_fees",
        centerTitle: true,
        actions: [
          GetBuilder<PaymentState>(builder: (getCart) {
            if (getCart.cartList.isEmpty) {
              return const SizedBox();
            }
            return Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                  child: IconButton(
                      onPressed: () async {
                        try {
                          var res = await paymentLdbState.getbankPayments(
                            id: '0',
                            type: 'many',
                            cartList: paymentState.cartList,
                          );
                          if (res.statusCode == 200) {
                            showPayment();
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
                      icon: Icon(
                        Icons.shopping_cart,
                        color: appColor.white,
                      )),
                ),
                getCart.cartList.isEmpty
                    ? const SizedBox()
                    : InkWell(
                      splashColor: Colors.transparent,
                      onTap: ()async {
                         try {
                          var res = await paymentLdbState.getbankPayments(
                            id: '0',
                            type: 'many',
                            cartList: paymentState.cartList,
                          );
                          if (res.statusCode == 200) {
                            showPayment();
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
                      child: Container(
                          alignment: Alignment.center,
                          height: fixSize(0.02, context),
                          width: fixSize(0.02, context),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            borderRadius: BorderRadius.circular(
                              fixSize(1, context),
                            ),
                          ),
                          child: FittedBox(
                              child: CustomText(
                            text: paymentState.cartList.length.toString(),
                            color: appColor.white,
                          )),
                        ),
                    )
              ],
            );
          }),
          IconButton(
              onPressed: () {
                showBottomDialog();
              },
              icon: Icon(
                Icons.calendar_month,
                color: appColor.white,
              ))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.07, // Match the height for proper layout
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      updateIndex('all');
                      paymentState.clearData();
                      historyPaymentState.clearData();
                      await historyPaymentState.getListStudents(
                          id: widget.id.toString(), type: 'all');
                    },
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: appColor.white,
                          border: Border(
                              bottom: type == 'all'
                                  ? BorderSide(
                                      width: 2, color: appColor.mainColor)
                                  : BorderSide.none)),
                      child: Center(
                        child: CustomText(
                          text: 'all',
                          color: type == 'all'
                              ? appColor.mainColor
                              : appColor.grey,
                          fontSize: fixSize(0.0185, context),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      updateIndex('debt');
                      paymentState.clearData();
                      historyPaymentState.clearData();
                      await historyPaymentState.getListStudents(
                          id: widget.id.toString(), type: 'debt');
                    },
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: appColor.white,
                          border: Border(
                              bottom: type == 'debt'
                                  ? BorderSide(
                                      width: 2, color: appColor.mainColor)
                                  : BorderSide.none)),
                      child: Center(
                        child: CustomText(
                          text: 'outstanding_tuition_fees',
                          color: type == 'debt'
                              ? appColor.mainColor
                              : appColor.grey,
                          fontSize: fixSize(0.0185, context),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      updateIndex('paid');
                      paymentState.clearData();
                      historyPaymentState.clearData();
                      await historyPaymentState.getListStudents(
                          id: widget.id.toString(), type: 'paid');
                    },
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: appColor.white,
                          border: Border(
                              bottom: type == 'paid'
                                  ? BorderSide(
                                      width: 2, color: appColor.mainColor)
                                  : BorderSide.none)),
                      child: Center(
                        child: CustomText(
                          text: 'paid',
                          color: type == 'paid'
                              ? appColor.mainColor
                              : appColor.grey,
                          fontSize: fixSize(0.0185, context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: GetBuilder<HistoryPaymentState>(
              builder: (getSelect) {
                return Column(
                  children: [
                    if (getSelect.data.isNotEmpty)
                      TextFormField(
                        controller: searchT, // Attach the controller
                        onChanged: (value) => {historyPaymentState.update()},
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          labelText: 'search'.tr,
                          // ignore: deprecated_member_use
                          fillColor: appColor.white.withOpacity(0.98),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.5, color: appColor.grey),
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
                  ],
                );
              },
            ),
          ),
          GetBuilder<HistoryPaymentState>(
            builder: (getDataList) {
              if (getDataList.check == false) {
                return SizedBox(
                  height: fSize * 0.4,
                  child: Center(
                    child: CircleLoad(),
                  ),
                );
              } else if (getDataList.data.isEmpty) {
                return SizedBox(
                  height: fSize * 0.4,
                  child: Center(
                    child: CustomText(
                      text: "not_found_data",
                      fontSize: fixSize(0.0185, context),
                      color: appColor.grey,
                    ),
                  ),
                );
              }
              var value = getDataList.data
                  .where((e) =>
                      (e.name ?? '')
                          .toLowerCase()
                          .contains(searchT.text.toLowerCase()) ||
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
              paymentState.checkList = List.filled(value.length, false);
              return Expanded(
                child: RefreshIndicator(
                  color: appColor.mainColor,
                  onRefresh: () async {
                    paymentState.clearData();
                    historyPaymentState.clearData();
                    await historyPaymentState.getListStudents(
                        id: widget.id.toString(), type: type);
                  },
                  child: ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(
                              () => DetailPaymentPage(
                                    data: value[index],
                                  ),
                              transition: Transition.fadeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 2.0, right: 2.0, bottom: 2.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Card(
                                elevation: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: appColor.white,
                                    borderRadius:
                                        BorderRadius.circular(fSize * 0.01),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                        color: Color.fromRGBO(213, 213, 213, 1),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        CustomText(
                                          text:
                                              '${value[index].issueDate} - ${value[index].dueDate}',
                                          color: appColor.grey,
                                          fontSize: fSize * 0.0145,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: '${'code_bill'.tr}:',
                                              fontSize: fSize * 0.0145,
                                              fontWeight: FontWeight.w500,
                                              color: appColor.black,
                                            ),
                                            SizedBox(width: fSize * 0.005),
                                            CustomText(
                                              text: '${value[index].name}',
                                              color: appColor.mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: fSize * 0.0145,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                text: '${'student'.tr}:',
                                                fontSize: fSize * 0.0145,
                                              ),
                                              Flexible(
                                                child: CustomText(
                                                  text:
                                                      '${value[index].firstname ?? ''} ${value[index].lastname ?? ''}',
                                                  fontSize: fSize * 0.0145,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (value[index].myClass != null &&
                                            value[index].myClass != '')
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                text: '${'class'.tr}:',
                                                fontSize: fSize * 0.0145,
                                              ),
                                              CustomText(
                                                text:
                                                    value[index].myClass ?? '',
                                                fontSize: fSize * 0.0145,
                                              ),
                                            ],
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: '${'total'.tr}:',
                                              fontSize: fSize * 0.0145,
                                            ),
                                            CustomText(
                                              text:
                                                  '${FormatPrice(price: num.parse(value[index].total.toString())).toString()} ₭',
                                              fontSize: fSize * 0.0145,
                                              color: appColor.blueLight,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                        num.parse(value[index].totalPaid.toString()) > 0 ?
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: '${'total_paid'.tr}: ',
                                              fontSize: fSize * 0.0145,
                                            ),
                                            CustomText(
                                              text:
                                                  '${FormatPrice(price: num.parse(value[index].totalPaid.toString())).toString()} ₭',
                                              fontSize: fSize * 0.0145,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ) : const SizedBox(),
                                        num.parse(value[index].discount.toString()) > 0 ?
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: '${'discount'.tr}:',
                                              fontSize: fSize * 0.0145,
                                            ),
                                            CustomText(
                                              text:
                                                  '- ${FormatPrice(price: num.parse(value[index].discount.toString())).toString()} ₭', // Show calculated difference
                                              fontSize: fSize * 0.0145,
                                              color: appColor.orange,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ) : const SizedBox(),
                                        num.parse(value[index].discountPhiset.toString()) > 0 ?
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: '${'special_discount'.tr}:',
                                              fontSize: fSize * 0.0145,
                                            ),
                                            CustomText(
                                              text:
                                                  '- ${FormatPrice(price: num.parse(value[index].discountPhiset.toString())).toString()} ₭', // Show calculated difference
                                              fontSize: fSize * 0.0145,
                                              color: appColor.orange,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ) : const SizedBox(),
                                        num.parse(value[index].totalDebt.toString()) > 0 ?
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: '${'total_debt'.tr}:',
                                              fontSize: fSize * 0.0145,
                                            ),
                                            CustomText(
                                              text:
                                                  '${FormatPrice(price: num.parse(value[index].totalDebt.toString())).toString()} ₭', // Show calculated difference
                                              fontSize: fSize * 0.0145,
                                              color: appColor.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ) : const SizedBox(),
                                        if (value[index].transactionIdPayment !=
                                                '' &&
                                            value[index].transactionIdPayment !=
                                                null &&
                                            value[index].status == 1)
                                          Center(
                                            child: InkWell(
                                              onTap: () {
                                                if (value[index].bankId ==
                                                    '1') {
                                                  paymentState.checkPaymentInfo(
                                                      id: value[index]
                                                          .id
                                                          .toString(),
                                                      transactionId: value[
                                                              index]
                                                          .transactionIdPayment
                                                          .toString(),
                                                      status: type);
                                                } else if (value[index]
                                                        .bankId ==
                                                    '2') {
                                                  paymentLdbState.checkPaymentInfo(
                                                      id: value[index]
                                                          .id
                                                          .toString(),
                                                      transactionId: value[index]
                                                              .transactionIdPayment ??
                                                          '',
                                                      accessToken: value[index]
                                                              .accessToken ??
                                                          '',
                                                      xClientTransactionDatetime:
                                                          value[index].xClientTransactionDatetime ??
                                                              '',
                                                      partnerId: value[index]
                                                              .partnerId ??
                                                          '',
                                                      digest:
                                                          value[index].digest ??
                                                              '',
                                                      created: value[index]
                                                              .qRcreated ??
                                                          '',
                                                      expires:
                                                          value[index].qRexpires ??
                                                              '',
                                                      signature:
                                                          value[index].signature ??
                                                              '',
                                                      reference2: value[index]
                                                              .reference2 ??
                                                          '',
                                                      status: type);
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                width: size.width * 0.5,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: appColor.mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: CustomText(
                                                  text: 'check_payment',
                                                  fontWeight: FontWeight.bold,
                                                  color: appColor.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (double.parse(
                                      value[index].totalDebt.toString()) >
                                  0)
                                GetBuilder<PaymentState>(builder: (getPay) {
                                  if (getPay.checkList.isEmpty) {
                                    return const SizedBox();
                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                          activeColor: appColor.green,
                                          value: getPay.checkList[index],
                                          onChanged: (v) {
                                            if (v == true) {
                                              paymentState.addTocart(
                                                  id: value[index].id!,
                                                  firstname:
                                                      value[index].firstname ??
                                                          '',
                                                  lastname:
                                                      value[index].lastname,
                                                  billerID:
                                                      value[index].billerID ??
                                                          '',
                                                  storeID: value[index].storeID ??
                                                      '',
                                                  terminalID:
                                                      value[index].terminalID ??
                                                          '',
                                                  ref2: value[index].ref2 ?? '',
                                                  month: DateFormat('MM/yyyy')
                                                      .format(DateFormat('d/MM/yyyy')
                                                          .parse(value[index]
                                                              .issueDate
                                                              .toString()))
                                                      .toString(),
                                                  total: double.parse(value[index]
                                                      .totalDebt
                                                      .toString()));
                                            } else {
                                              paymentState
                                                  .deleteCart(value[index].id!);
                                            }
                                            paymentState.updateCheckBox(
                                                index, v!);
                                          }),
                                      CustomText(
                                        text: 'select_pay',
                                        color: appColor.grey,
                                      )
                                    ],
                                  );
                                })
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<HistoryPaymentState>(
        builder: (getSelect) {
          if (getSelect.data.isEmpty) {
            return const SizedBox();
          }
          var value = getSelect.data
              .where((e) =>
                  (e.name ?? '')
                      .toLowerCase()
                      .contains(searchT.text.toLowerCase()) ||
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
          num sumTotalDebt = value.fold(
              0, (sum, e) => sum + num.parse(e.totalDebt.toString()));
          num sumTotalPaid = value.fold(
              0, (sum, e) => sum + num.parse(e.totalPaid.toString()));
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: appColor.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      spreadRadius: 2,
                      color: Color.fromRGBO(213, 213, 213, 1),
                      offset: Offset(0, -2), // Moves shadow to the top
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: 'all', fontWeight: FontWeight.bold),
                        CustomText(
                            text:
                                '${FormatPrice(price: num.parse(value.length.toString())).toString()} ${"items".tr}',
                            color: appColor.blueLight,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                            text: 'total_debt', fontWeight: FontWeight.bold),
                        CustomText(
                            text:
                                '${FormatPrice(price: sumTotalDebt).toString()} ₭',
                            color: appColor.red,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                            text: 'total_paid', fontWeight: FontWeight.bold),
                        CustomText(
                            text:
                                '${FormatPrice(price: sumTotalPaid).toString()} ₭',
                            color: appColor.green,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void showBottomDialog() {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return GetBuilder<HistoryPaymentState>(builder: (getPay) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: historyPaymentState.selectedMonth2.isEmpty
                        ? null
                        : historyPaymentState.selectedMonth2,
                    hint: const CustomText(text: 'select_month'),
                    onChanged: (selectedMonth) async {
                      historyPaymentState.updateMonth(selectedMonth!);
                      if (historyPaymentState.selectedYear1 != '' &&
                          selectedMonth != '') {
                        await historyPaymentState.getListStudents(
                            year: historyPaymentState.selectedYear1,
                            month: historyPaymentState.selectedMonth2,
                            id: widget.id.toString(),
                            type: type);
                      }
                    },
                    items: historyPaymentState.monthList.map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: CustomText(text: month),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    width: size.width * 0.2,
                  ),
                  DropdownButton<String>(
                    value: historyPaymentState.selectedYear1.isEmpty
                        ? null
                        : historyPaymentState.selectedYear1,
                    hint: const CustomText(text: 'select_year'),
                    onChanged: (selectedYear) async {
                      historyPaymentState.updateYear(selectedYear!);
                      if (selectedYear != '' &&
                          historyPaymentState.selectedMonth2 != '') {
                        await historyPaymentState.getListStudents(
                            year: selectedYear,
                            month: historyPaymentState.selectedMonth2,
                            id: widget.id.toString(),
                            type: type);
                      }
                    },
                    items: historyPaymentState.yearList.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  void showPayment() {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return GetBuilder<PaymentState>(builder: (vetCart) {
          return GetBuilder<PaymentLdbState>(builder: (bankPayment) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                  height: size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
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
                                      price: (num.parse(paymentState.sumtotal
                                              .toString()) +
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
                                      paymentState.sumtotal.toString()))
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
                        const SizedBox(height: 8),
                        Expanded(
                            child: ListView.builder(
                                itemCount: paymentState.cartList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: appColor.grey))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text:
                                              '${paymentState.cartList[index]['firstname']} ${paymentState.cartList[index]['lastname']}',
                                          fontSize: fixSize(0.01650, context),
                                        ),
                                        CustomText(
                                          text:
                                              '${"month".tr}: ${paymentState.cartList[index]['month']}',
                                          fontSize: fixSize(0.01650, context),
                                        ),
                                        CustomText(
                                          color: appColor.red,
                                          text: FormatPrice(
                                                  price: num.parse(paymentState
                                                      .cartList[index]['total']
                                                      .toString()))
                                              .toString(),
                                          fontSize: fixSize(0.01650, context),
                                        )
                                      ],
                                    ),
                                  );
                                })),
                        (bankPayment.bankPaymentList.isEmpty)
                            ? const SizedBox()
                            : Expanded(
                                child: ListView.builder(
                                    itemCount:
                                        bankPayment.bankPaymentList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            Get.back();
                                            if (bankPayment
                                                    .bankPaymentList[index]
                                                    .bankId ==
                                                1) {
                                              Get.to(
                                                  () => GenerateQrcodePayment(
                                                        type: 'many',
                                                        id: '0',
                                                        billerID: bankPayment
                                                            .bankPaymentList[
                                                                index]
                                                            .billerID,
                                                        bankId: bankPayment
                                                            .bankPaymentList[
                                                                index]
                                                            .bankId
                                                            .toString(),
                                                        storeID: bankPayment
                                                            .bankPaymentList[
                                                                index]
                                                            .storeID,
                                                        terminalID: bankPayment
                                                            .bankPaymentList[
                                                                index]
                                                            .terminalID,
                                                        ref2: bankPayment
                                                            .bankPaymentList[
                                                                index]
                                                            .ref2,
                                                        amount: (num.parse(
                                                                paymentState
                                                                    .sumtotal
                                                                    .toString()))
                                                            .toString(),
                                                        note: note.text,
                                                        totalDebt:
                                                            paymentLdbState
                                                                .totalDebt
                                                                .toString(),
                                                      ),
                                                  transition:
                                                      Transition.fadeIn);
                                            } else if (bankPayment
                                                        .bankPaymentList[index]
                                                        .bankId ==
                                                    2 &&
                                                bankPayment
                                                        .bankPaymentList[index]
                                                        .mERCHANTID !=
                                                    '' &&
                                                bankPayment
                                                        .bankPaymentList[index]
                                                        .clientId !=
                                                    '' &&
                                                bankPayment
                                                        .bankPaymentList[index]
                                                        .clientSecret !=
                                                    '' &&
                                                bankPayment
                                                        .bankPaymentList[index]
                                                        .partnerId !=
                                                    '' &&
                                                bankPayment
                                                        .bankPaymentList[index]
                                                        .signatureSecretKey !=
                                                    '' &&
                                                paymentState
                                                    .cartList.isNotEmpty) {
                                              Get.to(
                                                  () =>
                                                      GenerateQrcodePaymentLdb(
                                                        type: 'many',
                                                        billCode: '',
                                                        id: '0',
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
                                                        amount: (num.parse(
                                                                paymentState
                                                                    .sumtotal
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
                                                        cartList: paymentState
                                                            .cartList,
                                                        totalDebt:
                                                            paymentLdbState
                                                                .totalDebt
                                                                .toString(),
                                                      ),
                                                  transition:
                                                      Transition.fadeIn);
                                            }
                                          },
                                          child: Stack(
                                            alignment: Alignment.centerRight,
                                            children: [
                                              Container(
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
                                                            "${Repository().nuXtJsUrlApi}${bankPayment.bankPaymentList[index].logo}",
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
                                                          color: appColor
                                                              .mainColor,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
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
                                    }))
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
        });
      },
    );
  }
}
