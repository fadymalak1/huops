import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/resources/resources.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/profile.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/cards/profile.card.dart';
import 'package:huops/widgets/menu_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_images.dart';
import '../../../widgets/busy_indicator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return BasePage(
            showAppBar: true,
            title: "Profile & App Settings".tr(),
            body: VStack(
              [
                //image of user
                model.authenticated ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, //This will make container round
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CachedNetworkImage(
                              imageUrl: model.currentUser?.photo ?? "",
                              progressIndicatorBuilder:
                                  (context, imageUrl, progress) {
                                return BusyIndicator();
                              },
                              errorWidget: (context, imageUrl, progress) {
                                return Image.asset(
                                  AppImages.user,
                                );
                              },
                            )
                                .wh(100, 100)
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make(),
                          ),
                        ),
                      ),
                      // model.currentUser!.name.text.xl.semiBold.make(),
                      // //email
                      // model.currentUser!.email.text.light.make(),
                      // //share invation code
                      // AppStrings.enableReferSystem ? "Share referral code".tr().text.sm.color(context.textTheme.bodyLarge!.color).make().box.px4.roundedSM.border(color: Colors.grey).make().onInkTap(model.shareReferralCode).py4() : UiSpacer.emptySpace(),
                    ],
                  ),
                ) : SizedBox(),
                //profile card
                ProfileCard(model).py12(),

                //menu
                // VStack(
                //   [
                //     //
                //     MenuItem(
                //       title: "Notifications".tr(),
                //       onPressed: model.openNotification,
                //       ic: AppIcons.bell,
                //     ),
                //
                //     //
                //     MenuItem(
                //       title: "Rate & Review".tr(),
                //       onPressed: model.openReviewApp,
                //       ic: AppIcons.rating,
                //     ),
                //
                //     //
                //     MenuItem(
                //       title: "Faqs".tr(),
                //       onPressed: model.openFaqs,
                //       ic: AppIcons.compliant,
                //     ),
                //     //
                //     MenuItem(
                //       title: "Privacy Policy".tr(),
                //       onPressed: model.openPrivacyPolicy,
                //       ic: AppIcons.compliant,
                //     ),
                //     //
                //     MenuItem(
                //       title: "Terms & Conditions".tr(),
                //       onPressed: model.openTerms,
                //       ic: AppIcons.termsAndConditions,
                //     ),
                //     //
                //     MenuItem(
                //       title: "Contact Us".tr(),
                //       onPressed: model.openContactUs,
                //       ic: AppIcons.communicate,
                //     ),
                //     //
                //     MenuItem(
                //       title: "Live Support".tr(),
                //       onPressed: model.openLivesupport,
                //       ic: AppIcons.livesupport,
                //     ),
                //     //
                //     MenuItem(
                //       title: "Language".tr(),
                //       divider: false,
                //       ic: AppIcons.translation,
                //       onPressed: model.changeLanguage,
                //     ),
                //
                //     //
                //     MenuItem(
                //       title: "Version".tr(),
                //       suffix: model.appVersionInfo.text.make(),
                //     ),
                //   ],
                // ),

                //
                "Copyright ©%s %s all right reserved"
                    .tr()
                    .fill([
                      "${DateTime.now().year}",
                      AppStrings.companyName,
                    ])
                    .text.color(Colors.white)
                    .center
                    .sm
                    .makeCentered()
                    .py20(),
                //
                // UiSpacer.verticalSpace(space: context.percentHeight * 10),
              ],
            ).py20().scrollVertical(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
