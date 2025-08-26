import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/states/camera_scan_state.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import '../../custom/app_color.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:audioplayers/audioplayers.dart';

import 'adminschool/admin_students.dart';

class CameraScanPage extends StatelessWidget {
  CameraScanPage({super.key});
  final AppColor appColors = AppColor();
  final player = AudioPlayer();
  void playSound() async {
    await player.play(AssetSource('sounds/error.mp3'));
  }

  void playSuccessSound() async {
    await player.play(AssetSource('sounds/success.mp3'));
  }
  @override
  Widget build(BuildContext context) {
    CameraScanPageState cameraScanPageState = Get.put(CameraScanPageState());
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    double cutOutSize = size.width * 0.6;
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        orientation: orientation,
        height: size.height,
        title: "scan-in-out".tr,
        titleSize: fixSize(0.02, context),
        actions: [IconButton(onPressed: (){
          Get.to(() => AdminStudents(branchId: '', checkInOut: true), transition: Transition.fadeIn);
        },
            icon: Icon(Icons.search, size: fixSize(0.02, context), color: appColors.white,))
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // QR Scanner View
          GetBuilder<CameraScanPageState>(builder: (camera)  {
            // camera.scanOut(context: context, code: '691246');
            return QRView(
              key: camera.qrKey,
              overlay: QrScannerOverlayShape(
                borderColor: appColors.mainColor,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize:
                    cutOutSize, // Ensure scanning effect is inside this area
              ),
              onQRViewCreated: (controller) {
                controller.scannedDataStream.listen((scanData) async {
                  camera.controller!.pauseCamera();
                  camera.updateBarCode(scanData).then((_) async {
                    try {
                      var res = await camera.scanOut(context: context);
                      if (res.statusCode == 200) {
                        // Get.back();
                        // controller.dispose();
                        // cameraScanPageState.controller!.dispose();
                        // playSuccessSound();
                        // CustomDialogs().showToast(
                        //   text: "success",
                        //   // ignore: deprecated_member_use
                        //   backgroundColor: appColors.green.withOpacity(0.75),
                        // );
                      } else if (res.statusCode == 404) {
                        // playSound();
                        // AwesomeDialog(
                        //   // ignore: use_build_context_synchronously
                        //   context: context,
                        //   dialogType: DialogType.error,
                        //   animType: AnimType.scale,
                        //   title: 'sorry'.tr,
                        //   desc: 'No_data_in_the_system'.tr,
                        //   showCloseIcon: false,
                        //   dismissOnTouchOutside: false,
                        //   btnOkText: 'ok'.tr,
                        //   dismissOnBackKeyPress: false,
                        //   btnOkColor: appColors.red,
                        //   btnOkOnPress: () {
                        //     Get.back();
                        //   },
                        // ).show();
                      }
                    } catch (e) {
                      Get.back();
                      CustomDialogs().showToast(
                        text: "something_went_wrong",
                        // ignore: deprecated_member_use
                        backgroundColor: appColors.mainColor.withOpacity(0.75),
                      );
                    }

                    await Future.delayed(const Duration(seconds: 2));
                    camera.controller!.resumeCamera();
                  });
                });
              },
            );
          }),

          // 🔵 Centered Scanning Animation
          Positioned(
            top: (MediaQuery.of(context).size.height - cutOutSize) / 2 +
                (cutOutSize / 2) -
                10,
            child: ScanningAnimation(cutOutSize: cutOutSize),
          ),
        ],
      ),
    );
  }
}

// 🔥 Scanning Effect Widget (Now Centered!)
class ScanningAnimation extends StatefulWidget {
  final double cutOutSize;
  const ScanningAnimation({super.key, required this.cutOutSize});

  @override
  // ignore: library_private_types_in_public_api
  _ScanningAnimationState createState() => _ScanningAnimationState();
}

class _ScanningAnimationState extends State<ScanningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // ✨ Start from Center, Move Up & Down
    _animation = Tween<double>(
      begin: -widget.cutOutSize * 2, // Start above center
      end: widget.cutOutSize * 2, // Move below center
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value), // Moves up & down
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 1, // Slightly thicker
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // ignore: deprecated_member_use
                  Colors.blueAccent.withOpacity(0.7),
                  // ignore: deprecated_member_use
                  Colors.blue.withOpacity(0.9),
                  // ignore: deprecated_member_use
                  Colors.blueAccent.withOpacity(0.7),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.blue.withOpacity(0.5),
                  blurRadius: 5, // Soft glow effect
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
