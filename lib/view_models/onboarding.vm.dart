import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/models/on_boarding.dart';
import 'package:huops/requests/settings.request.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class OnboardingViewModel extends MyBaseViewModel {
  OnboardingViewModel(BuildContext context, this.finishLoading) {
    this.viewContext = context;
  }

  final PageController pageController = PageController();
  final Function finishLoading;

  List<OnBoarding> onBoardData = [];

  initialise() {
    final bgColor = viewContext.theme.colorScheme.background;
    final textColor =
        Utils.textColorByColor(viewContext.theme.colorScheme.background);
    //
    // onBoardData = [
    //   PageModel(
    //     color: Colors.white,
    //     titleColor: textColor,
    //     bodyColor: textColor,
    //     imageAssetPath: AppImages.onboarding1,
    //     title: "Browse through different vendors".tr(),
    //     body: "Get your favourite meal/food/items from varities of vendor".tr(),
    //     doAnimateImage: true,
    //   ),
    //   PageModel(
    //     color: bgColor,
    //     titleColor: textColor,
    //     bodyColor: textColor,
    //     imageAssetPath: AppImages.onboarding2,
    //     title: "Chat with vendor/delivery boy".tr(),
    //     body:
    //         "Call/Chat with vendor/delivery boy for update about your order and more"
    //             .tr(),
    //     doAnimateImage: true,
    //   ),
    //   PageModel(
    //     color: bgColor,
    //     titleColor: textColor,
    //     bodyColor: textColor,
    //     imageAssetPath: AppImages.onboarding3,
    //     title: "Delivery made easy".tr(),
    //     body:
    //         "Get your ordered food/item or parcel delivered at a very fast, cheap and reliable way"
    //             .tr(),
    //     doAnimateImage: true,
    //   ),
    // ];
    //
    loadOnboardingData();
  }

  loadOnboardingData() async {
    setBusy(true);
    try {
      final apiResponse = await SettingsRequest().appOnboardings();
      //load the data
      if (apiResponse.allGood) {
        // log(apiResponse.body.toString());
        final mOnBoardDatas = (apiResponse.body as List).map(
          (e) => OnBoarding.fromJson(e),
        );

        onBoardData = mOnBoardDatas.toList();
        log(onBoardData.toString());
        // final mOnBoardDatas = (apiResponse.body as List).map(
        //   (e) {
        //     return PageModel.withChild(
        //       child: VStack(
        //         [
        //           Padding(
        //             padding: new EdgeInsets.only(bottom: 25.0),
        //             child: CustomImage(
        //               imageUrl: "${e['photo']}",
        //               width: viewContext.percentWidth * 50,
        //               height: viewContext.percentWidth * 50,
        //               boxFit: BoxFit.cover,
        //             ).centered(),
        //           ),
        //           "${e["title"]}".tr().text.xl3.bold.make(),
        //           UiSpacer.vSpace(5),
        //           "${e["description"]}".tr().text.lg.hairLine.make(),
        //         ],
        //       ).p20(),
        //       color: viewContext.theme.colorScheme.background,
        //       doAnimateChild: true,
        //     );
        //   },
        // ).toList();
        //

      } else {
        toastError("${apiResponse.message}");
      }
    } catch (error) {
      toastError("$error");
    }
    setBusy(false);
    finishLoading();
  }

  void onDonePressed() async {
    //
    await AuthServices.firstTimeCompleted();
    Navigator.of(viewContext).pushNamedAndRemoveUntil(
      AppRoutes.homeRoute,
      (route) => false,
    );
  }
}
