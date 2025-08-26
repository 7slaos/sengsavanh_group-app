import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/format_price.dart';
import 'package:pathana_school_app/models/paymentinfo_model.dart';
import 'package:pathana_school_app/states/payment_state.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

class PaymentSuccess extends StatefulWidget {
  final String paymentId;
  final String? note;
  final PaymentInfoModel? data;
  final PaymentInfo? paymentInfo;
  const PaymentSuccess(
      {super.key,
      required this.paymentId,
      this.note,
      this.data,
      this.paymentInfo});
  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  PaymentState paymentState = Get.put(PaymentState());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppColor appColor = AppColor();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'payment',
          fontSize: fixSize(0.019, context),
        ),
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.white,
        centerTitle: true,
      ),
      backgroundColor: appColor.mainColor,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: appColor.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                    child: Icon(
                  Icons.check_circle_outline,
                  color: appColor.green,
                  size: fixSize(0.1, context),
                )),
                Center(
                  child: CustomText(
                    text: 'success',
                    fontSize: fixSize(0.0135, context),
                    fontWeight: FontWeight.w300,
                    color: appColor.green,
                  ),
                ),
                if (widget.data != null) ...[
                  const Divider(),
                  CustomText(
                    text: 'bill_number',
                    fontSize: fixSize(0.0135, context),
                    fontWeight: FontWeight.w300,
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data?.paymentInfo?.billerID ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'amount',
                    fontSize: fixSize(0.0135, context),
                    fontWeight: FontWeight.w300,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        text:
                            '-${FormatPrice(price: num.parse(widget.data?.paymentInfo?.payAmount ?? '0'))}',
                        fontSize: fixSize(0.03, context),
                        color: appColor.red,
                      ),
                      CustomText(
                        text: widget.data?.paymentInfo?.payCurrencyCode ?? '',
                        fontSize: fixSize(0.0165, context),
                        color: appColor.red,
                      ),
                    ],
                  ),
                  const Divider(),
                  CustomText(
                    text: 'detail',
                    fontSize: fixSize(0.0135, context),
                    fontWeight: FontWeight.w300,
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: (widget.note != '' && widget.note != null)
                        ? widget.note.toString()
                        : 'ຊໍາລະຄ່າຮຽນ',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'LAPNet_reference_number',
                    fontSize: fixSize(0.0135, context),
                    fontWeight: FontWeight.w300,
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.paymentId,
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'Destination_bank',
                    fontSize: fixSize(0.0135, context),
                    fontWeight: FontWeight.w300,
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data?.paymentInfo?.payerBankCode ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                ],
                if (widget.paymentInfo != null) ...[
                  const Divider(),
                  CustomText(
                    text: 'amount',
                    fontSize: fixSize(0.0135, context),
                    fontWeight: FontWeight.w300,
                    color: appColor.grey,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        text:
                            '-${FormatPrice(price: num.parse(widget.paymentInfo?.amount ?? '0'))}',
                        fontSize: fixSize(0.03, context),
                        color: appColor.red,
                      ),
                      CustomText(
                        text: widget.paymentInfo?.currency ?? '',
                        fontSize: fixSize(0.0165, context),
                        color: appColor.red,
                      ),
                    ],
                  ),
                  const Divider(),
                  CustomText(
                    text: 'detail',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                    fontWeight: FontWeight.w300,
                  ),
                  CustomText(
                    text: (widget.note != '' && widget.note != null)
                        ? widget.note.toString()
                        : 'Pay_tuition_fees',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'LAPNet_reference_number',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                    fontWeight: FontWeight.w300,
                  ),
                  CustomText(
                    text: widget.paymentId,
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'Destination_bank',
                    fontSize: fixSize(0.0135, context),
                    fontWeight: FontWeight.w300,
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.paymentInfo?.paymentBank ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
