import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/states/payment_state.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class GenerateQrcodePayment extends StatefulWidget {
  final String id;
  final String bankId;
  final String amount;
  final String? note;
  final String type;
  final String? billerID;
  final String? storeID;
  final String? terminalID;
  final String? ref2;
  final String totalDebt;
  const GenerateQrcodePayment(
      {super.key,
      required this.id,
      required this.bankId,
      required this.amount,
      this.note,
      required this.type,
      this.billerID,
      this.storeID,
      this.terminalID,
      this.ref2,
      required this.totalDebt});
  @override
  State<GenerateQrcodePayment> createState() => _GenerateQrcodePaymentState();
}

class _GenerateQrcodePaymentState extends State<GenerateQrcodePayment> {
  final GlobalKey _qrKey = GlobalKey();
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      // For Android 13+
      if (await Permission.photos.request().isGranted) {
        return true;
      }
      return false;
    }
    return true; // No permission needed for iOS
  }

  Future<void> _captureAndSavePng() async {
    try {
      // Request permission
      if (!await _requestPermission()) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission is required!')),
        );
        return;
      }
      // Capture the widget
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 2.0);

      // Add white background
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      );
      canvas.drawRect(
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        whitePaint,
      );
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      // Save to gallery
      final result = await ImageGallerySaverPlus.saveImage(pngBytes,
          quality: 100, name: 'cit_schools_lao_qrcode_payment');
      if (result['isSuccess']) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(text: 'QR_code_download_complete'),
            backgroundColor: AppColor().green,
          ),
        );
      } else {
        throw Exception("Failed to save QR code Payment.");
      }
    } catch (e) {
      debugPrint('Error: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: CustomText(text: 'Failed to download QR code Payment!')),
      );
    }
  }

  String generateRandomString({required String storeID, required int length}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return "$storeID${List.generate(length, (index) => chars[random.nextInt(chars.length)]).join()}";
  }

  PaymentState paymentState = Get.put(PaymentState());
  int _seconds = 0;
  int _minutes = 0;
  late Timer _timer;
  @override
  void initState() {
    getData();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (paymentState.laoQrModel != null) {
        paymentState.checkPayment(
            id: widget.type == 'one' ? widget.id.toString() : '0',
            transactionId: paymentState.laoQrModel!.transactionId!,
            amount: widget.amount,
            note: widget.note,
            type: widget.type,
            totalDebt: widget.totalDebt);
      }
    });
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        if (_seconds == 60) {
          _seconds = 0;
          _minutes++;
        }
        if (_minutes == 60) {
          Get.back();
          CustomDialogs().showToast(
            // ignore: deprecated_member_use
            backgroundColor: AppColor().red.withOpacity(0.8),
            text: 'QR Code Payment is expired',
          );
        }
      });
    });
  }

  getData() {
    Future.delayed(Duration(seconds: 5));
    if (widget.type == 'one') {
      if (widget.billerID == null ||
          widget.storeID == null ||
          widget.terminalID == null) {
        Get.back();
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().red.withOpacity(0.8),
          text:
              'Can not generate Lao Qrcode Payment', // Message for "Entered amount is too large"
        );
      } else {
        paymentState.generateLaoQrcode(
            feeInvoiceId: widget.id.toString(),
            billerID: widget.billerID!,
            ref1: generateRandomString(storeID: widget.storeID!, length: 13),
            ref2: widget.ref2!,
            amount: double.parse(widget.amount.toString()) +
                double.parse(widget.totalDebt.toString()),
            storeID: widget.storeID!,
            terminalID: widget.terminalID!,
            bankId: widget.bankId,
            type: widget.type,
            totalDebt: widget.totalDebt);
      }
    } else if (widget.type == 'many') {
      if (widget.billerID == null ||
          widget.storeID == null ||
          widget.terminalID == null) {
        Get.back();
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().red.withOpacity(0.8),
          text:
              'Can not generate Lao Qrcode Payment', // Message for "Entered amount is too large"
        );
      } else {
        paymentState.generateLaoQrcode(
            feeInvoiceId: widget.id.toString(),
            billerID: widget.billerID!,
            ref1: generateRandomString(storeID: widget.storeID!, length: 13),
            ref2: widget.ref2!,
            amount: double.parse(widget.amount.toString()) +
                double.parse(widget.totalDebt.toString()),
            storeID: widget.storeID!,
            bankId: widget.bankId,
            terminalID: widget.terminalID!,
            type: widget.type,
            totalDebt: widget.totalDebt);
      }
    } else {
      Get.back();
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text:
            'Can not generate Lao Qrcode Payment', // Message for "Entered amount is too large"
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppColor appColor = AppColor();

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'QR Code Payment',
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
            padding: const EdgeInsets.all(15),
            child: GetBuilder<PaymentState>(builder: (getPay) {
              if (getPay.checkLaoQr == false || getPay.laoQrModel == null) {
                return SizedBox(
                    height: size.height * 0.65,
                    child: Center(child: CircleLoad()));
              }
              if (getPay.laoQrModel?.qrCode == '') {
                return SizedBox(
                    height: size.height * 0.65,
                    child: Center(
                        child: CustomText(
                      text: 'Not_Found_QR_Code_Payment',
                      color: appColor.grey,
                    )));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    key: _qrKey,
                    child: Column(
                      children: [
                        Image.asset('assets/images/LAPNet-Template-01.png'),
                        Stack(
                          alignment:
                              Alignment.center, // Align the icon at the center
                          children: [
                            QrImageView(
                              data: getPay.laoQrModel!.qrCode!,
                              size: size.width * 0.8,
                            ),
                            Image.asset('assets/images/LAPNet-Template-02.png',
                                width: size.width * 0.3)
                          ],
                        ),
                        CustomText(
                          text: 'QR_Code_valid_within_hour',
                          fontSize: fixSize(0.0135, context),
                          fontWeight: FontWeight.w300,
                        ),
                        CustomText(
                          text:
                              '${"Still_left".tr}: ${_minutes.toString().padLeft(2, '0')}${"Minute".tr} : ${_seconds.toString().padLeft(2, '0')}${"Seconds".tr}',
                          fontSize: fixSize(0.0125, context),
                          color: appColor.red,
                          fontWeight: FontWeight.w300,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  InkWell(
                    onTap: _captureAndSavePng,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_download_outlined,
                            color: appColor.mainColor,
                            size: fixSize(0.02, context)),
                        const SizedBox(width: 8),
                        CustomText(
                          text: 'download',
                          fontSize: fixSize(0.0165, context),
                          color: appColor.mainColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  CustomText(
                    text: 'Please_scan_the_QRCode_to_pay_your_tuition',
                    fontSize: fixSize(0.0135, context),
                    fontWeight: FontWeight.w300,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(appColor.mainColor),
          minimumSize: WidgetStateProperty.all(
              Size(double.infinity, size.height * 0.08)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
        onPressed: () {},
        child: CustomText(
          text: 'Waiting_for_payment',
          fontSize: fixSize(0.018, context),
          color: Colors.white,
        ),
      ),
    );
  }
}
