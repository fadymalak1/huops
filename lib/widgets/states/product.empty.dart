import 'package:flutter/material.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EmptyProduct extends StatelessWidget {
  const EmptyProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imageUrl: AppImages.noFav,
      title: "No Product Found".tr(),
      description: "There seems to be no product".tr(),
    );
  }
}
