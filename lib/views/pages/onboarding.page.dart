import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/onboarding.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: ViewModelBuilder<OnboardingViewModel>.nonReactive(
        viewModelBuilder: () => OnboardingViewModel(context, finishLoading),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return VStack(
            [
              Visibility(
                visible: vm.isBusy,
                child: BusyIndicator().centered().expand(),
              ),
              //
              Visibility(
                visible: !vm.isBusy,
                child: Directionality(
                  textDirection: Utils.textDirection,
                  child:OnBoardingSlider(
                    hasSkip: true,
                    hasFloatingButton: true,
                    imageVerticalOffset: 50,

                    headerBackgroundColor:  Vx.hexToColor("#312B48"),
                    finishButtonText: 'Welcome',
                    
                    finishButtonStyle: FinishButtonStyle(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    skipTextButton: Text('Skip',style: TextStyle(color: Colors.white),),
                    trailing: Text('Skip',style: TextStyle(color: Colors.white),),
                    trailingFunction: vm.onDonePressed,
                    onFinish: vm.onDonePressed,
                    pageBackgroundGradient: AppColor.LightBg,
                    indicatorAbove: true,

                    background:vm.onBoardData.map((e) => Container(alignment: Alignment.center,width: MediaQuery.of(context).size.width,child: Image.network(e.photo??"").wFourFifth(context))).toList(),
                    totalPage: vm.onBoardData.length,
                    speed: 1.8,
                    pageBodies:vm.onBoardData.map((e) => Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 480,
                          ),
                          Text(e.title??"",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                          SizedBox(height: 15,),
                          Text(e.description??"",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                        ],
                      ),
                    ),).toList(),
                  ).expand(),
                  // OverBoard(
                  //
                  //   pages: vm.onBoardData,
                  //   showBullets: true,
                  //   skipText: "Skip".tr(),
                  //   nextText: "Next".tr(),
                  //   finishText: "Done".tr(),
                  //   skipCallback: vm.onDonePressed,
                  //   finishCallback: vm.onDonePressed,
                  //   buttonColor: AppColor.primaryColor,
                  //   inactiveBulletColor: AppColor.accentColor,
                  //   activeBulletColor: AppColor.primaryColorDark,
                  // ).expand(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  finishLoading() {
    setState(() {});
  }
}
