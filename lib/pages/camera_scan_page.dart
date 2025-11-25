import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/widgets/custom_app_bar.dart';
import 'package:multiple_school_app/states/camera_scan_state.dart';

class CameraScanPage extends StatelessWidget {
  CameraScanPage({super.key, required this.type, this.student_records_id, this.id});
  final AppColor appColors = AppColor();
  final String type;
  final String? student_records_id;
  final String? id;

  @override
  Widget build(BuildContext context) {
    final camera = Get.put(CameraScanPageState());
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;
    final cutOutSize = size.width * 0.6;

    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        orientation: orientation,
        height: size.height,
        title: "scan".tr,
        titleSize: fixSize(0.02, context),
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
              // Get.to(
              //       () => AdminStudents(branchId: '', checkInOut: true),
              //   transition: Transition.fadeIn,
              // );
            },
            icon: Icon(Icons.close, size: fixSize(0.02, context), color: appColors.white),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // QR camera
          GetBuilder<CameraScanPageState>(
            builder: (_) {
              return QRView(
                key: camera.qrKey,
                overlay: QrScannerOverlayShape(
                  borderColor: appColors.mainColor,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: cutOutSize,
                ),
                onQRViewCreated: (ctrl) {
                  // ✅ always attach a fresh controller (handles re-entrance)
                  camera.attachController(ctrl: ctrl, context: context, type: type, student_records_id: student_records_id, id: id);
                },
                onPermissionSet: (ctrl, granted) {
                  camera.handlePermission(granted);
                },
              );
            },
          ),

          // Scanning animation line (center)
          Positioned(
            top: (MediaQuery.of(context).size.height - cutOutSize) / 2 + (cutOutSize / 2) - 10,
            child: ScanningAnimation(cutOutSize: cutOutSize),
          ),

          // Pulsing border around cutout (heartbeat)
          GetBuilder<CameraScanPageState>(
            id: 'hud',
            builder: (_) {
              final color = (camera.previewTick % 2 == 0)
                  ? appColors.mainColor
                  : Colors.green;
              return IgnorePointer(
                ignoring: true,
                child: Center(
                  child: Container(
                    width: cutOutSize,
                    height: cutOutSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color, width: 3),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ScanningAnimation extends StatefulWidget {
  final double cutOutSize;
  const ScanningAnimation({super.key, required this.cutOutSize});

  @override
  State<ScanningAnimation> createState() => _ScanningAnimationState();
}

class _ScanningAnimationState extends State<ScanningAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _animation = Tween<double>(
      begin: -widget.cutOutSize * 2,
      end: widget.cutOutSize * 2,
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
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.7),
                  Colors.blue.withOpacity(0.9),
                  Colors.blueAccent.withOpacity(0.7),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  blurRadius: 5,
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
