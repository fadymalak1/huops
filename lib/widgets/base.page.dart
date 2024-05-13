import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/views/shared/go_to_cart.view.dart';
import 'package:huops/widgets/cart_page_action.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/app_routes.dart';
import 'drawers/main_drawer.dart';


class BasePage extends StatefulWidget {
  final bool showAppBar;
  final bool showLeadingAction;
  final bool? extendBodyBehindAppBar;
  final Function? onBackPressed;
  final bool showCart;
  final dynamic title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget body;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Widget? fab;
  final FloatingActionButtonLocation? fabLocation;
  final bool isLoading;
  final Color? appBarColor;
  final double? elevation;
  final Color? appBarItemColor;
  final Color? backgroundColor;
  final bool showCartView;
  bool shopNote;
  final PreferredSize? customAppbar;
  final bool? showMenu;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PreferredSizeWidget? bottomTabBar;
  BasePage({
    this.shopNote = false,
    this.showAppBar = false,
    this.leading,
    this.showLeadingAction = false,
    this.onBackPressed,
    this.showCart = false,
    this.title = "",
    this.actions,
    required this.body,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.fab,
    this.fabLocation,
    this.isLoading = false,
    this.appBarColor,
    this.appBarItemColor,
    this.backgroundColor,
    this.elevation,
    this.extendBodyBehindAppBar,
    this.showCartView = false,
    this.customAppbar,
    this.showMenu = false,
    this.scaffoldKey,
    this.bottomTabBar,
    Key? key,
  }) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  //
  double bottomPaddingSize = 0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: translator.activeLocale.languageCode == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: KeyboardDismisser(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColor.LightBg,
          ),
          child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: widget.extendBodyBehindAppBar ?? false,
            drawer: widget.showMenu == true ? MainDrawer() : null,
            appBar: widget.customAppbar != null
                ? widget.customAppbar
                : widget.showAppBar
                ? AppBar(
              centerTitle: true,
              backgroundColor:
              widget.appBarColor ?? context.primaryColor,
              elevation: widget.elevation,
              automaticallyImplyLeading: widget.showLeadingAction,
              bottom: widget.bottomTabBar,
              leading: widget.showLeadingAction
                  ? widget.leading == null
                  ? widget.showMenu == false
                  ? IconButton(
                icon: Icon(
                  !Utils.isArabic
                      ? FlutterIcons.arrow_left_fea
                      : FlutterIcons.arrow_right_fea,
                  color: widget.appBarItemColor == null
                      ? Colors.white
                      : widget.appBarItemColor !=
                      Colors.transparent
                      ? widget.appBarItemColor
                      : AppColor.primaryColor,
                ),
                onPressed: widget.onBackPressed != null
                    ? () => widget.onBackPressed!()
                    : () => Navigator.pop(context),
              )
                  : IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState
                        ?.openDrawer();
                    //  Scaffold.of(context).openDrawer() ;
                  },
                  icon: Icon(Icons.menu,
                      color: Colors.white))
                  : widget.leading
                  : widget.leading,
              title: widget.title is Widget
                  ? widget.title
                  : "${widget.title}"
                  .text
                  .maxLines(1).bold
                  .overflow(TextOverflow.ellipsis)
                  .color(widget.appBarItemColor ?? Colors.white)
                  .make(),
              actions: widget.actions ??
                  [
                    widget.showCart
                        ? PageCartAction()
                        : UiSpacer.emptySpace(),
                    widget.shopNote
                        ? IconButton(
                        onPressed: () => {
                          Navigator.of(context).pushNamed(
                            AppRoutes.notificationsRoute,
                          )
                        },
                        icon: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ))
                        : UiSpacer.emptySpace()
                  ],
            )
                : null,
            body: Stack(
              children: [
                //body
                VStack(
                  [
                    //
                    widget.isLoading
                        ? LinearProgressIndicator()
                        : UiSpacer.emptySpace(),

                    //
                    widget.body.pOnly(bottom: bottomPaddingSize).expand(),
                  ],
                ),

                //cart view
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Visibility(
                    visible: widget.showCartView,
                    child: MeasureSize(
                      onChange: (size) {
                        setState(() {
                          bottomPaddingSize = size.height;
                        });
                      },
                      child: GoToCartView(),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: widget.bottomNavigationBar,
            bottomSheet: widget.bottomSheet,
            floatingActionButton: widget.fab,
            floatingActionButtonLocation: widget.fabLocation,
          ),
        ),
      ),
    );
  }
}