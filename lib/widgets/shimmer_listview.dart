import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListview extends StatefulWidget {
  const ShimmerListview({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShimmerListviewState createState() => _ShimmerListviewState();
}

class _ShimmerListviewState extends State<ShimmerListview> {
  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size; // You can use this to get screen size
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.black,
                    highlightColor: Colors.white,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.125,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
