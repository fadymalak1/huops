import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_ui_settings.dart';
import 'package:huops/constants/app_upgrade_settings.dart';
import 'package:huops/services/location.service.dart';
import 'package:huops/views/pages/cart/cart.page.dart';
import 'package:huops/views/pages/profile/profile.page.dart';
import 'package:huops/view_models/home.vm.dart';
import 'package:huops/views/pages/qrCode/q_rcode_page.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:velocity_x/velocity_x.dart';

import 'order/orders.page.dart';
import 'search/main_search.page.dart';
import 'welcome/widgets/cart.fab.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = HomeViewModel(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        LocationService.prepareLocationListener();
        vm.initialise();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: "Press back again to close".tr(),
      child: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => vm,
        builder: (context, model, child) {
          return BasePage(
            body: UpgradeAlert(
              upgrader: Upgrader(
                showIgnore: !AppUpgradeSettings.forceUpgrade(),
                shouldPopScope: () => !AppUpgradeSettings.forceUpgrade(),
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
              ),
              child: PageView(
                controller: model.pageViewController,
                onPageChanged: model.onPageChanged,
                children: [
                  OrdersPage(),
                  QRcodePage(),
                  model.homeView,
                  CartPage(showLeading: false,),
                  ProfilePage(),
                ],
              ),
            ),
            showCart: false,
            // fab: AppUISettings.showCart ? CartHomeFab(model) : null,
            // fabLocation: AppUISettings.showCart
            //     ? FloatingActionButtonLocation.centerDocked
            //     : null,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              currentIndex: model.currentIndex,
              onTap: model.onTabChange,
              elevation: 0,
              selectedItemColor: AppColor.primaryColor,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),


              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    FlutterIcons.tasks_faw5s,
                  ),
                  label: "Orders".tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.qr_code_scanner_rounded,
                  ),
                  label: "QrCode".tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FlutterIcons.home_ant,
                  ),
                  label: "Home".tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FlutterIcons.cart_outline_mco,
                  ),
                  label: "Cart".tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FlutterIcons.profile_ant,
                  ),
                  label: "Profile".tr(),
                ),
              ],
            ).glassMorphic(
              circularRadius:40,
              opacity: 0.1,
            ).pOnly(bottom: 20,right: 20,left: 20),

            // bottomNavigationBar: SafeArea(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: GNav(
            //       gap: 3,
            //       activeColor: Colors.white,
            //       color: Theme.of(context).textTheme.bodyLarge?.color,
            //       iconSize: 20,
            //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //
            //       duration: Duration(milliseconds: 250),
            //       tabBackgroundColor: Theme.of(context).colorScheme.secondary,
            //       tabs: [
            //         GButton(
            //           icon: FlutterIcons.home_ant,
            //           text: 'Home'.tr(),
            //         ),
            //         GButton(
            //           icon: FlutterIcons.inbox_ant,
            //           text: 'Orders'.tr(),
            //         ),
            //         GButton(
            //           icon: FlutterIcons.search_fea,
            //           text: 'Search'.tr(),
            //         ),
            //         GButton(
            //           icon: FlutterIcons.menu_fea,
            //           text: 'More'.tr(),
            //         ),
            //       ],
            //       selectedIndex: model.currentIndex,
            //       onTabChange: model.onTabChange,
            //     ).glassMorphic(),
            //   ),
            // ),
          );
        },
      ),
    );
  }
}
