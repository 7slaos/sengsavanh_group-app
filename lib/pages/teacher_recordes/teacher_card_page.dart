import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/states/profile_state.dart';
import 'package:multiple_school_app/states/profile_teacher_state.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TeacherCardPage extends StatelessWidget {
  const TeacherCardPage({super.key});
  String get qrValue => '123456'; // use name as QR value
  /// Return example: "2024-2025"
  String currentAcademicYear({int startMonth = 9, int startDay = 1}) {
    final now = DateTime.now();
    final startThisYear = DateTime(now.year, startMonth, startDay);

    final startYear = now.isBefore(startThisYear) ? now.year - 1 : now.year;
    return '$startYear-${startYear + 1}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: GetBuilder<ProfileTeacherState>(builder: (getPro) {
        return GetBuilder<ProfileState>(
          builder: (getAdminProfile) {
            return Stack(
              children: [
                const _Background(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const _TopBar(title: 'TEACHER ID CARD'),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _Avatar(
                                      name:
                                          '${getPro.teacherModels?.firstname ?? getAdminProfile.profiledModels?.firstname ?? ""} ${getPro.teacherModels?.lastname ?? getAdminProfile.profiledModels?.lastname ?? ""}',
                                      url: '${Repository().nuXtJsUrlApi}${getPro.teacherModels?.imagesProfile}'),
                                  const SizedBox(height: 14),
                                  CustomText(
                                    text:
                                    '${getPro.teacherModels?.firstname ?? getAdminProfile.profiledModels?.firstname ?? ""} ${getPro.teacherModels?.lastname ?? getAdminProfile.profiledModels?.lastname ?? ""}',
                                    textAlign: TextAlign.center,
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  if(getPro.teacherModels?.duty !=null)...[
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text: getPro.teacherModels?.duty ?? "",
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  )],
                                  if(getAdminProfile.profiledModels !=null)...[
                                    const SizedBox(height: 4),
                                    CustomText(
                                      text: "ຜູ້ບໍລິຫານ",
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    )],
                                  const SizedBox(height: 18),
                                  QrCard(
                                      value: getPro.teacherModels?.code ?? getAdminProfile.profiledModels?.code ?? qrValue),
                                  const SizedBox(height: 18),
                                  CustomText(
                                    text:
                                        '${"academic_year".tr}: ${currentAcademicYear(startMonth: 9)}',
                                    textAlign: TextAlign.center,
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        );
      }),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _CirclesPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _CirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()..color = const Color(0x33FFFFFF);
    final p2 = Paint()..color = const Color(0x22FFFFFF);
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.78), size.width * 0.40, p1);
    canvas.drawCircle(
        Offset(size.width * 0.65, size.height * 0.90), size.width * 0.30, p2);
    canvas.drawCircle(
        Offset(size.width * 0.00, size.height * 0.25), size.width * 0.35, p2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleIcon(
            icon: Icons.chevron_left_rounded,
            onTap: () => Navigator.maybePop(context)),
        const Spacer(),
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5)),
        const Spacer(),
      ],
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.url});
  final String name;
  final String? url;
  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name
            .trim()
            .split(RegExp(r'\s+'))
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase();
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
      child: CircleAvatar(
        radius: 46,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 43,
          backgroundColor: const Color(0xFFFFF7ED),
          child: (url != null && url!.isNotEmpty)
              ? ClipOval(
                  child: CachedNetworkImage(
                  imageUrl: url!,
                  width: 86,
                  height: 86,
                  fit: BoxFit.cover,
                  errorWidget: (context, _url, error) => Image.asset(
                    'assets/images/istockphoto-587805078-612x612.jpg',
                    width: 86,
                    height: 86,
                    fit: BoxFit.cover,
                  ),
                )
          )
              : Text(initials,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF7C2D12))), // deep brown for contrast
        ),
      ),
    );
  }
}

class QrCard extends StatelessWidget {
  const QrCard({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33000000), blurRadius: 22, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            padding: const EdgeInsets.all(8),
            child: QrImageView(
              data: value.isEmpty ? 'fallback' : value,
              version: QrVersions.auto,
              size: 210,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
          ),
          CustomText(text: value)
        ],
      ),
    );
  }
}
