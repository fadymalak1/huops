import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:local_auth/local_auth.dart';
import '../../../models/api_response.dart';
import '../home.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/login.view_model.dart';
import 'package:huops/views/pages/auth/login/compain_login_type.view.dart';
import 'package:huops/views/pages/auth/login/email_login.view.dart';
import 'package:huops/views/pages/auth/login/otp_login.view.dart';
import 'package:huops/views/pages/auth/login/social_media.view.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'login/scan_login.view.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.required = false, Key? key}) : super(key: key);

  final bool required;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late final LocalAuthentication auth;
  bool _supportState = false;
  bool canUseBiometric = false;
  final _dio = Dio();


  getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String user_id = sharedPreferences.getString('user_id')!;
    if(user_id != null){
      setState(() {
        canUseBiometric = true;
      });
    }else{
      setState(() {
        canUseBiometric = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
        _supportState = isSupported;
      }),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return PopScope(
          // canPop: !widget.required,
          // onPopInvoked: (value) async {
          //   if (widget.required) {
          //     context.pop();
          //   }
          //   return true;
          // },
          child: BasePageWithoutNavBar(
            showLeadingAction: !widget.required,
            showAppBar: !widget.required,
            appBarColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                FlutterIcons.arrow_left_fea,
                color: AppColor.primaryColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
            isLoading: model.isBusy,
            body: SafeArea(
              top: true,
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
                child: VStack(
                  [
                    //
                    VStack(
                      crossAlignment: CrossAxisAlignment.center,
                      [

                        Image.asset(
                          AppImages.appLogo,
                        )
                            .h(80)
                            .w(260)
                            .box
                            .clip(Clip.antiAlias)
                            .make(),

                        //LOGIN Section
                        //both login type
                        if (AppStrings.enableOTPLogin &&
                            AppStrings.enableEmailLogin)
                          CombinedLoginTypeView(model).px12(),
                        //only email login
                        if (AppStrings.enableEmailLogin &&
                            !AppStrings.enableOTPLogin)
                          EmailLoginView(model),
                        //only otp login
                        if (AppStrings.enableOTPLogin &&
                            !AppStrings.enableEmailLogin)
                          OTPLoginView(model),
                      ],
                    ).wFull(context).px20().pOnly(top: Vx.dp20),
                    //
                    //register
                    HStack(
                      [
                        UiSpacer.divider().expand(),
                        "OR".tr().text.light.make().px8(),
                        UiSpacer.divider().expand(),
                      ],
                    ).py8().px20(),

                    SocialMediaView(model).py(12),
                    canUseBiometric ? Center(
                      child: CustomButton(
                        title: "Sign in with BioMetrics".tr(),
                        titleStyle: TextStyle(fontSize: 15),
                        shapeRadius: 15,
                        // loading: model.isBusy,
                        onPressed: (){_authenticate(model);},
                      ).centered().py12().px64(),
                    ) : SizedBox(),
                    "New user?"
                        .richText
                        .withTextSpanChildren([
                      " ".textSpan.make(),
                      "Create An Account"
                          .tr()
                          .textSpan
                          .semiBold
                          .color(AppColor.primaryColor)
                          .make(),
                    ])
                        .makeCentered()
                        .py12()
                        .onInkTap(model.openRegister),
                  ],
                ).scrollVertical(),
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> _authenticate (model) async {
    try{
      bool authenticated = await auth.authenticate(
          localizedReason: "Please authenticate to continue",
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          )
      );
      if(authenticated){
        // final String token = generateSecureToken();
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String user_id = sharedPreferences.getString('user_id')!;
        // final isVerified = await loginWithUserId(user_id,model);
        print("#######userid######$user_id");

        String urlOfLoginWithBiometric =
            "https://huopsapp.it/api/login/biometric/$user_id";
        final response = await _dio.get(urlOfLoginWithBiometric);
        // print("#########${response.data}");
        // print("#######ssssss##${response.statusCode}");

        if (response.statusCode == 200) {
          print("#########${response.data}");
          // ApiResponse.fromResponse(response);
          await model.handleDeviceLogin(ApiResponse.fromResponse(response));
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
          // return true;
        } else {

        }
      }
      print("authenticate:########: $authenticated");
    }on PlatformException catch (e){
      print("####_authenticate#####$e");
    }
  }

  Future<void> _getAvailableBioMetrics() async {
    List<BiometricType> availableBioMetrics = await auth.getAvailableBiometrics();
    print("list of Available BioMetrics ## $availableBioMetrics");

    if(!mounted){
      return ;
    }
  }
}
