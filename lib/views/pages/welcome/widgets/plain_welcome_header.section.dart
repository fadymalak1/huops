import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/home_screen.config.dart';
import 'package:huops/models/delivery_address.dart';
import 'package:huops/services/alert.service.dart';
import 'package:huops/services/app.service.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/services/location.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/welcome.vm.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/finance/plain_wallet_management.view.dart';
import 'package:huops/widgets/inputs/search_bar.input.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PlainWelcomeHeaderSection extends StatelessWidget {
  const PlainWelcomeHeaderSection(
    this.vm, {
    Key? key,
  }) : super(key: key);

  final WelcomeViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //location section
        HStack(
          [
            HStack(
              [
                Icon(
                  FlutterIcons.location_pin_ent,
                  size: 24,
                  color: Utils.textColorByTheme(),
                ),
                UiSpacer.hSpace(5),
                VStack(
                  [
                    "Deliver To"
                        .tr()
                        .text
                        .thin
                        .light
                        .color(Utils.textColorByTheme())
                        .sm
                        .make(),
                    StreamBuilder<DeliveryAddress?>(
                      stream: LocationService.currenctDeliveryAddressSubject,
                      initialData: vm.deliveryaddress,
                      builder: (conxt, snapshot) {
                        return "${snapshot.data?.address ?? ""}"
                            .text
                            .maxLines(1)
                            .ellipsis
                            .base
                            .make();
                      },
                    ).flexible(),
                  ],
                ).flexible(),
                UiSpacer.hSpace(5),
                Icon(
                  FlutterIcons.chevron_down_ent,
                  size: 20,
                  color: Utils.textColorByTheme(),
                ),
              ],
            ).expand(),

            UiSpacer.hSpace(),
            //profile is login
            StreamBuilder<dynamic>(
              stream: AuthServices.listenToAuthState(),
              initialData: false,
              builder: (ctx, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data is bool &&
                    snapshot.data) {
                  return CustomImage(
                    imageUrl: AuthServices.currentUser?.photo ?? "",
                  )
                      .wh(35, 35)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make()
                      .onInkTap(
                    () {
                      AppService().homePageIndex.add(3);
                    },
                  );
                } else {
                  return UiSpacer.emptySpace();
                }
              },
            ),
          ],
        ).onTap(
          () async {
            await onLocationSelectorPressed();
          },
        ),

        //search button
        UiSpacer.vSpace(),
        SearchBarInput(
          onTap: () {
            AppService().homePageIndex.add(2);
          },
        ),
        UiSpacer.vSpace(5),

        //wallet UI for login user
        //finance section
        StreamBuilder<dynamic>(
          stream: AuthServices.listenToAuthState(),
          initialData: false,
          builder: (ctx, snapshot) {
            if (snapshot.hasData && snapshot.data is bool && snapshot.data) {
              return CustomVisibilty(
                visible: HomeScreenConfig.showWalletOnHomeScreen,
                child: PlainWalletManagementView().py(15),
              );
            } else {
              return UiSpacer.emptySpace();
            }
          },
        ),

        //
        UiSpacer.vSpace(120),
      ],
    )
        .wFull(context)
        .safeArea()
        .p12()
        .box
        .bottomRounded(value: 25)
        .color(AppColor.primaryColor)
        .make();
  }

  Future<void> onLocationSelectorPressed() async {
    try {
      vm.pickDeliveryAddress(onselected: () {
        vm.pageKey = GlobalKey<State>();
        vm.notifyListeners();
      });
    } catch (error) {
      AlertService.stopLoading();
    }
  }
}
