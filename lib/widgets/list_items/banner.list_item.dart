import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BannerListItem extends StatelessWidget {
  const BannerListItem({
    required this.imageUrl,
    this.onPressed,
    this.radius = 4,
    this.noMargin = false,
    Key? key,
  }) : super(key: key);

  final String imageUrl;
  final double radius;
  final bool noMargin;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: this.imageUrl,
      fit: BoxFit.fill,
      width: double.infinity,
    )
        .onInkTap(this.onPressed != null ? () => this.onPressed!() : null)
        .box
    .customRounded(BorderRadius.only(bottomRight: Radius.circular(radius), bottomLeft: Radius.circular(radius)))
        .clip(Clip.antiAlias)

        .make();
  }
}
