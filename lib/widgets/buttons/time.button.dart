import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/vendor.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class TimeButton extends StatelessWidget {
  const TimeButton(
      this.vendor, {
        this.size,
        Key? key,
      }) : super(key: key);

  final Vendor vendor;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.access_time_rounded,
      size: size ?? 24,
      color: Colors.white,
    ).p8().box.color(AppColor.primaryColor).roundedFull.make();
  }
}
