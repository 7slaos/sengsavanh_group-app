
import 'dart:typed_data' as typed;
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/teacher_recordes/scan_result_page.dart';
import 'package:pathana_school_app/states/profile_state.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';

import '../../functions/determine_postion.dart';
import '../../states/checkin-out-student/check_in_out_student_state.dart';
import '../../states/profile_student_state.dart';
import '../../states/profile_teacher_state.dart';

import '../../widgets/bottom_bill_bar.dart';

class CheckInMapPage extends StatefulWidget {
  const CheckInMapPage({
    super.key,
    required this.type,
    required this.status,
    this.id,

    /// ✅ ສົ່ງ URL ໂລໂກ້ໂຮງຮຽນ (ຖ້າບໍ່ສົ່ງຈະ fallback ທີ່ asset)
    this.schoolLogoUrl,

    /// ✅ ສົ່ງ URL ຮູບ profile ຂອງຄູ/ນັກຮຽນ
    this.profilePhotoUrl,

    /// ✅ asset fallback (optional)
    this.schoolLogoAsset = 'assets/images/logo.png',
    this.profileAsset = 'assets/images/person.png',
  });

  final String type;   // 'owner_teacher' | 'owner_student'
  final String status;
  final String? id;

  final String? schoolLogoUrl;
  final String? profilePhotoUrl;
  final String schoolLogoAsset;
  final String profileAsset;

  @override
  State<CheckInMapPage> createState() => _CheckInMapPageState();
}

class _CheckInMapPageState extends State<CheckInMapPage> {
  final AppColor appColor = AppColor();
  static const Color _red = Color(0xFFE25D4F);
  static const Color _blue = Color(0xFF1F8BFF);

  final player = AudioPlayer();
  Future<void> playErrorSound() async =>
      player.play(AssetSource('sounds/error.mp3')); // ensure asset exists

  final ProfileTeacherState profileTeacherState = Get.put(ProfileTeacherState());
  final ProfileStudentState profileStudentState = Get.put(ProfileStudentState());
  final ProfileState profileState = Get.put(ProfileState());
  final CheckInOutStudentState checkInOutStudentState =
  Get.put(CheckInOutStudentState());

  GoogleMapController? _map;

  MapType _mapType = MapType.normal;
  void _toggleMapType() {
    setState(() {
      _mapType =
      (_mapType == MapType.normal) ? MapType.hybrid : MapType.normal;
    });
  }

  double? _geofenceKm; // ດຶງຈາກ DB (km)
  double get _radiusMeters {
    final v = _geofenceKm;
    return (v != null && v > 0) ? v * 1000.0 : 220.0;
  }

  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  String? lat;
  String? lng;

  // Coordinates
  LatLng? _schoolCenter;
  LatLng? _userNow;
  double distanceKm = 0;

  // Custom icons
  BitmapDescriptor? _schoolIcon;
  BitmapDescriptor? _profileIcon;

  static const LatLng _fallback = LatLng(17.9757, 102.6331);

  @override
  void initState() {
    super.initState();
    if (profileState.profiledModels == null &&
        widget.type == 'a') {
      profileState.checkToken();
    }
    if (profileTeacherState.teacherModels == null &&
        widget.type == 't') {
      profileTeacherState.checkToken();
    }
    if (profileStudentState.dataModels == null &&
        widget.type == 's') {
      profileStudentState.checkToken();
    }

    _applySchoolCenterFromState();
    _getCurrentPosition();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _prepareIcons(); // load once when context ready
  }

  // ---------- Build custom marker icons (school logo + profile photo) ----------
  Future<void> _prepareIcons() async {
    // School logo
    if (_schoolIcon == null) {
      if (widget.schoolLogoUrl != null && widget.schoolLogoUrl!.isNotEmpty) {
        _schoolIcon = BitmapDescriptor.fromBytes(
          await _buildAvatarMarkerFromUrl(
            widget.schoolLogoUrl!,
            diameter: 112,
            ringWidth: 6,
            ringColor: appColor.red, // ຂອບເຫຼືອງໃຫ້ສະດຸດ
            includePinTip: true,
          ),
        );
      } else {
        _schoolIcon = BitmapDescriptor.fromBytes(
          await _buildAvatarMarkerFromAsset(
            widget.schoolLogoAsset,
            diameter: 112,
            ringWidth: 6,
            ringColor: appColor.red,
            includePinTip: true,
          ),
        );
      }
    }

    // Profile (teacher/student)
    if (_profileIcon == null) {
      if (widget.profilePhotoUrl != null &&
          widget.profilePhotoUrl!.isNotEmpty) {
        _profileIcon = BitmapDescriptor.fromBytes(
          await _buildAvatarMarkerFromUrl(
            widget.profilePhotoUrl!,
            diameter: 112,
            ringWidth: 6,
            ringColor: Colors.white,
            includePinTip: true,
          ),
        );
      } else {
        _profileIcon = BitmapDescriptor.fromBytes(
          await _buildAvatarMarkerFromAsset(
            widget.profileAsset,
            diameter: 112,
            ringWidth: 6,
            ringColor: Colors.white,
            includePinTip: true,
          ),
        );
      }
    }

    if (mounted) setState(() {});
  }

  void _applySchoolCenterFromState() {
    if(widget.type == 'a'){
      final a = profileState.profiledModels;
      if (a != null && a.lat != null && a.lng != null) {
        _schoolCenter = LatLng(a.lat!, a.lng!);
        _geofenceKm = _toDouble(a.km); // ເຂດ km ຈາກ DB
      }
    }
    else if(widget.type == 't'){
      final t = profileTeacherState.teacherModels;
      if (t != null && t.lat != null && t.lng != null) {
        _schoolCenter = LatLng(t.lat!, t.lng!);
        _geofenceKm = _toDouble(t.km); // ເຂດ km ຈາກ DB
      }
    }else{
      final s = profileStudentState.dataModels;
      if (s != null && s.lat != null && s.lng != null) {
        _schoolCenter = LatLng(s.lat!, s.lng!);
        _geofenceKm = _toDouble(s.km); // ເຂດ km ຈາກ DB
      }
    }
    setState(() {});
  }

  Future<void> _getCurrentPosition() async {
    try {
      final Position pos = await DeterminePosition().determinePosition();
      setState(() {
        lat = pos.latitude.toString();
        lng = pos.longitude.toString();
        _userNow = LatLng(pos.latitude, pos.longitude);
        //_userNow = const LatLng(17.987046642034503, 102.66064350650448);
      });
      if (_userNow != null && _schoolCenter != null) {
        distanceKm = kmBetween(_userNow!, _schoolCenter!);
      }
    } catch (_) {
      // permission denied or GPS off
    }
  }

  LatLng get _initialTarget => _schoolCenter ?? _userNow ?? _fallback;

  // -------- Markers --------
  Set<Marker> get _markers {
    final m = <Marker>{};

    if (_schoolCenter != null) {
      m.add(Marker(
        markerId: const MarkerId('school'),
        position: _schoolCenter!,
        infoWindow: const InfoWindow(title: 'ໂຮງຮຽນ'),
        icon: _schoolIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        anchor: const Offset(0.5, 1.0),
      ));
    }

    if (_userNow != null) {
      m.add(Marker(
        markerId: const MarkerId('user_now'),
        position: _userNow!,
        infoWindow: InfoWindow(
            title:
            widget.type == 'a' ? 'ຜູ້ບໍລິຫານ (ປັດຈຸບັນ)' : widget.type == 't' ? 'ຄູ (ປັດຈຸບັນ)' : 'ນັກຮຽນ (ປັດຈຸບັນ)'),
        icon: _profileIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        anchor: const Offset(0.5, 1.0),
      ));
    }

    return m;
  }

  // -------- Geofence circles --------
  Set<Circle> get _circles {
    final circles = <Circle>{};

    if (_schoolCenter != null) {
      circles.add(
        Circle(
          circleId: const CircleId('outer'),
          center: _schoolCenter!,
          radius: _radiusMeters,
          strokeWidth: 0,
          fillColor: Colors.red.withOpacity(0.16),
        ),
      );
    }

    if (_userNow != null) {
      circles.add(
        Circle(
          circleId: const CircleId('inner'),
          center: _userNow!,
          radius: 50,
          strokeWidth: 0,
          fillColor: Colors.blue.withOpacity(0.35),
        ),
      );
    }

    return circles;
  }

  double kmBetween(LatLng start, LatLng end) {
    final meters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
    return meters / 1000.0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final isTablet = w >= 600;
      final scale = (w / 390).clamp(0.9, 1.3).toDouble();

      final allowedKm = _geofenceKm ?? 0;
      final isInRange =
      (_userNow != null && _schoolCenter != null && allowedKm > 0)
          ? distanceKm <= allowedKm
          : false;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appColor.mainColor,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 16,
          title:  Text(
            widget.id !=null ? 'Check-Out' : 'Check-In',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: _mapType,
              initialCameraPosition:
              CameraPosition(target: _initialTarget, zoom: 17),
              onMapCreated: (c) => _map = c,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: _markers,
              circles: _circles,
            ),

            // Right-side floating
            Positioned(
              right: 18 * scale,
              bottom: (isTablet ? 140 : 120) * scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Map type toggle: Normal <-> Hybrid
                  _SmallRoundBtn(
                    color: Colors.orange.withOpacity(0.85),
                    icon: _mapType == MapType.normal
                        ? Icons.layers
                        : Icons.map_rounded,
                    onTap: _toggleMapType,
                  ),
                  SizedBox(height: 12 * scale),

                  // GPS recenter
                  _SmallRoundBtn(
                    color: _red,
                    icon: Icons.gps_fixed_rounded,
                    onTap: () {
                      final target = _schoolCenter ?? _userNow ?? _fallback;
                      _map?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(target: target, zoom: 17),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12 * scale),
                  RingedCircleBtn(
                    outerSize: (isTablet ? 58 : 54) * scale,
                    ringWidth: 4 * scale,
                    fillColor:
                    isInRange ? _blue : appColor.grey, // enabled/disabled
                    icon: Icons.check_rounded,
                    onTap: () {
                      if (!isInRange) {
                        playErrorSound();
                        CustomDialogs().showToastWithIcon(
                          context: context,
                          backgroundColor: appColor.red,
                          message:
                          'ກະລຸນາເຂົ້າໃກ້ສະຖານທີ່ໂຮງຮຽນ ແລ້ວລອງອີກຄັ້ງ',
                          icon: Icons.close,
                        );
                        return;
                      }
                      if (lat != null && lng != null) {
                        Get.to(
                                () => ScanResultPage(
                              lat: lat!,
                              lng: lng!,
                              type: widget.type,
                              status: widget.status,
                              id: widget.id,
                            ),
                            transition: Transition.fadeIn);
                      }
                    },
                  ),
                ],
              ),
            ),

            BottomPillBar(
              scale: scale,
              isTablet: isTablet,
              teal: appColor.mainColor,
              type: widget.type,
            ),
          ],
        ),
      );
    });
  }
}

// ================= widgets =================
class _SmallRoundBtn extends StatelessWidget {
  const _SmallRoundBtn({
    required this.color,
    required this.icon,
    this.onTap,
  });

  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 4,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}



/// ✅ ປຸ່ມກົມມີຂອບ (ໃຊ້ກັບປຸ່ມ Confirm)
class RingedCircleBtn extends StatelessWidget {
  const RingedCircleBtn({
    super.key,
    required this.outerSize,
    required this.ringWidth,
    required this.fillColor,
    required this.icon,
    this.onTap,
  });

  final double outerSize;
  final double ringWidth;
  final Color fillColor;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: outerSize,
          height: outerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fillColor,
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
            border: Border.all(width: ringWidth, color: Colors.white),
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

/// =============================================================================
/// ================ Image → BitmapDescriptor utilities =========================
/// =============================================================================

Future<typed.Uint8List> _buildAvatarMarkerFromUrl(
    String url, {
      double diameter = 116,
      double ringWidth = 6,
      Color ringColor = Colors.white,
      bool includePinTip = true,
    }) async {
  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return _buildAvatarMarkerFromBytes(
        res.bodyBytes,
        diameter: diameter,
        ringWidth: ringWidth,
        ringColor: ringColor,
        includePinTip: includePinTip,
      );
    }
  } catch (_) {}
  // fallback: transparent bytes
  return _buildAvatarMarkerFromBytes(
    typed.Uint8List(0),
    diameter: diameter,
    ringWidth: ringWidth,
    ringColor: ringColor,
    includePinTip: includePinTip,
  );
}

Future<typed.Uint8List> _buildAvatarMarkerFromAsset(
    String assetPath, {
      double diameter = 116,
      double ringWidth = 6,
      Color ringColor = Colors.white,
      bool includePinTip = true,
    }) async {
  final typed.ByteData data = await rootBundle.load(assetPath);
  return _buildAvatarMarkerFromBytes(
    data.buffer.asUint8List(),
    diameter: diameter,
    ringWidth: ringWidth,
    ringColor: ringColor,
    includePinTip: includePinTip,
  );
}

Future<typed.Uint8List> _buildAvatarMarkerFromBytes(
    typed.Uint8List imageBytes, {
      double diameter = 116,
      double ringWidth = 6,
      Color ringColor = Colors.white,
      bool includePinTip = true,
    }) async {
  ui.Image? decoded;
  if (imageBytes.isNotEmpty) {
    final codec = await ui.instantiateImageCodec(
      imageBytes,
      targetWidth: diameter.toInt(),
      targetHeight: diameter.toInt(),
    );
    decoded = (await codec.getNextFrame()).image;
  }

  final tipH = includePinTip ? 22.0 : 0.0;
  final width = diameter;
  final height = diameter + tipH;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final center = Offset(width / 2, diameter / 2);
  final radius = diameter / 2;

  // shadow
  final shadowPaint = Paint()
    ..color = Colors.black.withOpacity(0.25)
    ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8);
  canvas.drawCircle(center.translate(0, 3), radius, shadowPaint);

  // white background
  canvas.drawCircle(center, radius, Paint()..color = Colors.white);

  // clip inner circle then draw image cover
  final innerRadius = radius - ringWidth;
  final clip = Path()
    ..addOval(Rect.fromCircle(center: center, radius: innerRadius));
  canvas.save();
  canvas.clipPath(clip);
  if (decoded != null) {
    paintImage(
      canvas: canvas,
      rect: Rect.fromCircle(center: center, radius: innerRadius),
      image: decoded,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
  canvas.restore();

  // ring
  final ring = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = ringWidth
    ..color = ringColor;
  canvas.drawCircle(center, radius - ringWidth / 2, ring);

  // subtle inner ring
  final innerRing = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.2
    ..color = const Color(0x22000000);
  canvas.drawCircle(center, innerRadius - 0.6, innerRing);

  // pin tip
  if (includePinTip) {
    final tipW = 26.0;
    final tipPath = Path()
      ..moveTo(width / 2, height)
      ..lineTo(width / 2 - tipW / 2, diameter - 2)
      ..quadraticBezierTo(
          width / 2, diameter + 6, width / 2 + tipW / 2, diameter - 2)
      ..close();

    final tipShadow = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 6);
    canvas.drawPath(tipPath.shift(const Offset(0, 1.5)), tipShadow);

    canvas.drawPath(tipPath, Paint()..color = Colors.white);
  }

  final picture = recorder.endRecording();
  final img = await picture.toImage(width.toInt(), height.toInt());
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}

