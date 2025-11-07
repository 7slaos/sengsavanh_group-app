// File: lib/pages/google_map_page.dart
// Requires: google_maps_flutter, http
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapPage extends StatefulWidget {
  /// ຈຸດທີ່ຈະສ້າງ marker ຮູບ
  final List<PhotoPoint> points;

  /// ຕໍາແໜ່ງເລີ່ມຕົ້ນ (ຖ້າບໍ່ສົ່ງ ຈະໃຊ້ຈາກ point ອັນທຳອິດ)
  final CameraPosition? initialCamera;

  /// ເຮັດ “ປິກ” ທີ່ດ້ານລຸ່ມຂອງ marker ຫຼືບໍ່
  final bool includePinTip;

  const GoogleMapPage({
    super.key,
    required this.points,
    this.initialCamera,
    this.includePinTip = true,
  });

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final Set<Marker> _markers = {};
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    final markers = <Marker>{};

    for (final p in widget.points) {
      Uint8List iconBytes;

      if (p.assetPath != null) {
        final data = await rootBundle.load(p.assetPath!);
        iconBytes = await _buildAvatarMarkerFromBytes(
          data.buffer.asUint8List(),
          diameter: 116,
          ringWidth: 6,
          includePinTip: widget.includePinTip,
        );
      } else if (p.imageUrl != null) {
        iconBytes = await _buildAvatarMarkerFromUrl(
          p.imageUrl!,
          diameter: 116,
          ringWidth: 6,
          includePinTip: widget.includePinTip,
        );
      } else {
        // fallback: ວົງຂາວລ້ວນ
        iconBytes = await _buildAvatarMarkerFromBytes(
          Uint8List(0),
          diameter: 116,
          ringWidth: 6,
          includePinTip: widget.includePinTip,
        );
      }

      markers.add(
        Marker(
          markerId: MarkerId(p.id),
          position: p.position,
          icon: BitmapDescriptor.fromBytes(iconBytes),
          anchor: const Offset(0.5, 1.0),
          onTap: () => p.onTap?.call(p),
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _markers
        ..clear()
        ..addAll(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final camPos = widget.initialCamera ??
        CameraPosition(
          target: widget.points.isNotEmpty
              ? widget.points.first.position
              : const LatLng(17.9738, 102.6268), // Vientiane (default)
          zoom: 15.5,
        );

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: camPos,
        onMapCreated: (c) => _controller = c,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        markers: _markers,
      ),
    );
  }
}

/// ===== Helper models =====
class PhotoPoint {
  final String id;
  final LatLng position;
  final String? imageUrl; // ຮູບຈາກ URL
  final String? assetPath; // ຮູບຈາກ asset
  final void Function(PhotoPoint p)? onTap;

  const PhotoPoint({
    required this.id,
    required this.position,
    this.imageUrl,
    this.assetPath,
    this.onTap,
  });
}

/// ===== Marker painter (circle + white ring + shadow + pin tip) =====
Future<Uint8List> _buildAvatarMarkerFromUrl(
    String url, {
      double diameter = 116,
      double ringWidth = 6,
      bool includePinTip = true,
    }) async {
  final res = await http.get(Uri.parse(url));
  if (res.statusCode != 200) {
    // ຖ້າໂຫຼດຮູບບໍ່ສຳເລັດ ວາດວົງໂລງ
    return _buildAvatarMarkerFromBytes(
      Uint8List(0),
      diameter: diameter,
      ringWidth: ringWidth,
      includePinTip: includePinTip,
    );
  }
  return _buildAvatarMarkerFromBytes(
    res.bodyBytes,
    diameter: diameter,
    ringWidth: ringWidth,
    includePinTip: includePinTip,
  );
}

Future<Uint8List> _buildAvatarMarkerFromBytes(
    Uint8List imageBytes, {
      double diameter = 116,
      double ringWidth = 6,
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

  // Shadow
  final shadowPaint = Paint()
    ..color = Colors.black.withOpacity(0.25)
    ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8);
  canvas.drawCircle(center.translate(0, 3), radius, shadowPaint);

  // Background circle (white)
  final bg = Paint()..color = Colors.white;
  canvas.drawCircle(center, radius, bg);

  // Clip to inner circle and draw the image cover
  final innerRadius = radius - ringWidth;
  final clip = Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius));
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

  // White ring
  final ring = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = ringWidth
    ..color = Colors.white;
  canvas.drawCircle(center, radius - ringWidth / 2, ring);

  // Subtle inner ring
  final innerRing = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.2
    ..color = const Color(0x22000000);
  canvas.drawCircle(center, innerRadius - 0.6, innerRing);

  // Pin tip (triangle-ish with curve)
  if (includePinTip) {
    final tipW = 26.0;
    final tipPath = Path()
      ..moveTo(width / 2, height) // bottom tip
      ..lineTo(width / 2 - tipW / 2, diameter - 2)
      ..quadraticBezierTo(width / 2, diameter + 6, width / 2 + tipW / 2, diameter - 2)
      ..close();

    final tipShadow = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 6);
    canvas.drawPath(tipPath.shift(const Offset(0, 1.5)), tipShadow);

    final tipPaint = Paint()..color = Colors.white;
    canvas.drawPath(tipPath, tipPaint);
  }

  final picture = recorder.endRecording();
  final img = await picture.toImage(width.toInt(), height.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
