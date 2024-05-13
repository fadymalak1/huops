import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/home_screen.config.dart';
import 'package:huops/view_models/welcome.vm.dart';
import 'package:huops/views/pages/search/main_search.page.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({
    Key? key,
  }) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with AutomaticKeepAliveClientMixin<WelcomePage> {
  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<WelcomeViewModel>.reactive(
        viewModelBuilder: () => WelcomeViewModel(context),
    onViewModelReady: (vm) => vm.initialise(),
    disposeViewModel: false,
    builder: (context, vm, child) {
      return BasePageWithoutNavBar(
        showMenu: true,
        showSearch: true,
        extendBodyBehindAppBar: true,
        showAppBar: true,
        appBarColor: Colors.transparent,
        elevation: 0,
        showNote: true,
        notificationCount: vm.count,
        showLeadingAction: true,
        title: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MainSearchPage())),
          child: TextFormField(decoration: InputDecoration(
            enabled: false,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: BorderSide.none),
              contentPadding: EdgeInsets.all(7),
            prefixIcon: Icon(Icons.search,color:Colors.grey,),
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.grey)
          ),).glassMorphic(circularRadius: 50,opacity: 0.2,blur: 8,),
        ),
        body:  SmartRefresher(
              controller: vm.refreshController,
              onRefresh: () => vm.initialise(initial: false),
              enablePullDown: true,
              enablePullUp: false,
              child: HomeScreenConfig.homeScreen(vm, vm.pageKey),
            ),
      );

    });

  }
}
