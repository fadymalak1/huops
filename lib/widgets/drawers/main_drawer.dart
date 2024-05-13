import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/resources/resources.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/profile.vm.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class MainDrawer extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<MainDrawer>
    with AutomaticKeepAliveClientMixin<MainDrawer> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
        onModelReady: (model) => model.initialise(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return Drawer(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColor.LightBg,
              ),
              child: VStack(
                crossAlignment: CrossAxisAlignment.center,
                [
                  //
                  Image.asset(
                    AppImages.appLogo,
                    width: 200,
                  ),
                  Divider(),
                  //   "Profile & App Settings".tr().text.lg.light.make(),

                  //profile card
                  //   ProfileCard(model).py12(),

                  //menu
                  VStack(
                    [
                      //
                      /*     MenuItem(
                        title: "Notifications".tr(),
                        onPressed: model.openNotification,
                        ic: AppIcons.bell,
                      ),
*/

                      /*
                      MenuItem(
                        title: "Favorites".tr(),
                        onPressed: model.openVendotFave,
                        ic: AppIcons.favourite,
                      ),
                      */
                      //
                      ViewModelBuilder<ProfileViewModel>.reactive(
                          viewModelBuilder: () => ProfileViewModel(context),
                          onViewModelReady: (model) => model.initialise(),
                          disposeViewModel: false,
                          builder: (context, model, child) {
                            return MenuItem(
                              title: "Favorite".tr(),
                              onPressed: model.openFavourites,
                              ic: AppIcons.favourite,
                            );
                          }),
                      Divider(),
                      MenuItem(
                        title: "Rate & Review".tr(),
                        onPressed: model.openReviewApp,
                        ic: AppIcons.rating,
                      ),
                      Divider(),

                      //
                      MenuItem(
                        title: "Faqs".tr(),
                        onPressed: model.openFaqs,
                        ic: AppIcons.faq,
                      ),
                      //
                      Divider(),
                      MenuItem(
                        title: "Privacy Policy".tr(),
                        onPressed: model.openPrivacyPolicy,
                        ic: AppIcons.compliant,
                      ),
                      //
                      Divider(),
                      MenuItem(
                        title: "Terms & Conditions".tr(),
                        onPressed: model.openTerms,
                        ic: AppIcons.termsAndConditions,
                      ),
                      //
                      Divider(),
                      MenuItem(
                        title: "Contact Us".tr(),
                        onPressed: model.openContactUs,
                        ic: AppIcons.communicate,
                      ),

                      //
                      Divider(),
                      MenuItem(
                        title: "Language".tr(),
                        divider: false,
                        ic: AppIcons.translation,
                        onPressed: model.changeLanguage,
                      ),

                      //

                      Divider(),
                      MenuItem(
                        onPressed: () {},
                        title: "Version".tr(),
                        suffix: model.appVersionInfo.text
                            .color(Colors.white)
                            .make(),
                      ),
                    ],
                  ),

                  //
                  "Copyright ©%s %s all right reserved"
                      .tr()
                      .fill([
                        "${DateTime.now().year}",
                        AppStrings.companyName,
                      ])
                      .text
                      .center
                      .sm
                      .makeCentered()
                      .py20(),
                  //
                  UiSpacer.verticalSpace(space: context.percentHeight * 10),
                ],
              ).p20().scrollVertical(),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    this.title,
    this.child,
    this.divider = true,
    this.topDivider = false,
    this.suffix,
    this.onPressed,
    this.ic,
    Key? key,
  }) : super(key: key);

  //
  final String? title;
  final Widget? child;
  final bool divider;
  final bool topDivider;
  final Widget? suffix;
  final Function? onPressed;
  final String? ic;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed != null ? () => onPressed!() : null,
      elevation: 0.0,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: HStack(
        [
          //
          CustomVisibilty(
            visible: ic != null,
            child: HStack(
              [
                //
                Image.asset(
                  ic ?? AppImages.appLogo,
                  width: 24,
                  height: 24,
                ),
                //
                UiSpacer.horizontalSpace(),
              ],
            ),
          ),
          //
          (child ?? "$title".text.lg.light.make()).expand(),
          //
          suffix ??
              Icon(
                FlutterIcons.right_ant,
                size: 16,
              ),
        ],
      ),
    ).pOnly(bottom: Vx.dp3);
  }
}
