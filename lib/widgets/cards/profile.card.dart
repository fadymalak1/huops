import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_finance_settings.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/constants/app_ui_settings.dart';
import 'package:huops/resources/resources.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/profile.vm.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/menu_item.dart';
import 'package:huops/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.model, {Key? key}) : super(key: key);

  final ProfileViewModel model;
  @override
  Widget build(BuildContext context) {
    return model.authenticated
        ? VStack(
            [
              //profile card
              //
              VStack(
                [
                  MenuItem(
                    title: "Edit Profile".tr(),
                    onPressed: model.openEditProfile,
                    ic: AppIcons.editProfile,
                    showDivider: false,
                  ),
                  //change password
                  MenuItem(
                    title: "Change Password".tr(),
                    onPressed: model.openChangePassword,
                    ic: AppIcons.changePassword,
                    showDivider: false,
                  ),
                  //referral
                  CustomVisibilty(
                    visible: AppStrings.enableReferSystem,
                    child: MenuItem(
                      title: "Refer & Earn".tr(),
                      onPressed: model.openRefer,
                      ic: AppIcons.refers,
                      showDivider: false,
                    ),
                  ),
                  //loyalty point
                  CustomVisibilty(
                    visible: AppFinanceSettings.enableLoyalty,
                    child: MenuItem(
                      title: "Loyalty Points".tr(),
                      onPressed: model.openLoyaltyPoint,
                      ic: AppIcons.loyaltyPoint,
                      colorIcon: Colors.grey.shade300,
                      showDivider: false,
                    ),
                  ),
                  //Wallet
                  CustomVisibilty(
                    visible: AppUISettings.allowWallet,
                    child: MenuItem(
                      title: "Wallet".tr(),
                      onPressed: model.openWallet,
                      ic: AppIcons.wallets,
                      showDivider: false,
                    ),
                  ),
                ],
              ),
              8.heightBox,
              VStack(
                  [
                //addresses
                MenuItem(
                  title: "Delivery Addresses".tr(),
                  onPressed: model.openDeliveryAddresses,
                  ic: AppIcons.address,
                  showDivider: false,
                ),
                //favourites
                MenuItem(
                  title: "Favourites".tr(),
                  onPressed: model.openFavourites,
                  ic: AppIcons.fav,
                  showDivider: false,
                ),
                //
                MenuItem(
                  title: "Logout".tr(),
                  ic: AppIcons.logout,
                  onPressed: model.logoutPressed,
                  suffix: SizedBox(),
                ),
              ]
              ),
                MenuItem(
                  child: "Delete Account".tr().text.red500.make(),
                  onPressed: model.deleteAccount,
                  ic: AppIcons.delete,
                  suffix: SizedBox(),
                ).py8(),
            ],
          )
            // .wFull(context)
            .box
            // .border(color: Theme.of(context).cardColor)
            // .color(Theme.of(context).cardColor)
            // .shadow
            // .roundedSM
            .make()
        : EmptyState(
            auth: true,
            showAction: true,
            actionPressed: model.openLogin,
          ).py12();
  }
}
