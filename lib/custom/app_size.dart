import 'dart:math';

import 'package:flutter/material.dart';

Size size(BuildContext context) {
  return MediaQuery.of(context).size;
}

double fixSize(double percent, BuildContext context) {
  return (size(context).width + size(context).height) * percent;
}

double minSize(BuildContext context) {
  return min(size(context).width, size(context).height);
}

double maxSize(BuildContext context) {
  return max(size(context).width, size(context).height);
}
