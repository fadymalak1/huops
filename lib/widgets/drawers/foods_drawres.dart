import 'package:flutter/material.dart' hide MenuItem;
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/models/search.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/profile.vm.dart';
import 'package:huops/views/pages/category/categories.page.dart';
import 'package:huops/widgets/drawers/main_drawer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/navigation.service.dart';

class FoodsDrawers extends StatefulWidget {

  final Search search;

  const FoodsDrawers({required Key key, required this.search}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();

}




class _ProfilePageState extends State<FoodsDrawers>
    {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
        onModelReady: (model) => model.initialise(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return Drawer(
            child: VStack(
              [
                //
                AppStrings.companyName.text.xl2.semiBold.make(),
                Divider(),
                //   "Profile & App Settings".tr().text.lg.light.make(),

                //profile card
                //   ProfileCard(model).py12(),

                //menu
                VStack(
                  [
                    //

                 /*   MenuItem(
                      title: "Profile".tr(),
                      onPressed: model.openProfile,
                      suffix: Icon(Icons.manage_accounts),
                    )*/

                    MenuItem(
                      title: "Search".tr(),
                      onPressed: (){

                        if(widget.search != null)
                          {
                            final page = NavigationService().searchPageWidget(widget.search);
                            context.nextPage(page);
                          }
                      },
                      suffix: Icon(Icons.search_sharp),
                    ),



                    MenuItem(
                      title: "Categories".tr(),
                      onPressed: (){
                        context.nextPage(
                          CategoriesPage(vendorType: widget.search.vendorType),
                        );
                      },
                      suffix: Icon(Icons.list_alt_rounded),
                    ),

                    MenuItem(
                      title: "favorites".tr(),
                      onPressed: model.openFavourites,
                      suffix: Icon( Icons.favorite),
                    ),

                    Divider(),

                    MenuItem(
                      title: "Notifications".tr(),
                      onPressed: model.openNotification,
                      suffix: Icon( Icons.notifications),
                    ),

                    //
                    MenuItem(
                      title: "Rate & Review".tr(),
                      onPressed: model.openReviewApp,
                      suffix: Icon( Icons.star),
                    ),

                    //
                    MenuItem(
                      title: "Faqs".tr(),
                      onPressed: model.openFaqs,
                      suffix: Icon( Icons.help),
                    ),
                    //
                    MenuItem(
                      title: "Privacy Policy".tr(),
                      onPressed: model.openPrivacyPolicy,
                      suffix: Icon( Icons.privacy_tip_outlined),
                    ),
                    //
                    MenuItem(
                      title: "Terms & Conditions".tr(),
                      onPressed: model.openTerms,
                      suffix: Icon( Icons.rule),
                    ),
                    //
                    MenuItem(
                      title: "Contact Us".tr(),
                      onPressed: model.openContactUs,
                      suffix: Icon(Icons.contact_support_outlined),
                    ),
                    //
                    MenuItem(
                      title: "Live Support".tr(),
                      onPressed: model.openLivesupport,
                      suffix: Icon(Icons.chat),
                    ),
                    //
                    MenuItem(
                      title: "Language".tr(),
                      divider: false,
                      suffix: Icon( Icons.language),
                      onPressed: model.changeLanguage,
                    ),

                    //
                    MenuItem(
                      title: "Version".tr(),
                      suffix: model.appVersionInfo.text.make(),
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
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
