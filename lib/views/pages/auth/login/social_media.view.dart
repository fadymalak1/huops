import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/view_models/login.view_model.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:velocity_x/velocity_x.dart';

import 'scan_login.view.dart';

class SocialMediaView extends StatelessWidget {
  const SocialMediaView(
    this.model, {
    this.bottomPadding = Vx.dp48,
    Key? key,
  }) : super(key: key);

  final LoginViewModel model;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !Platform.isIOS || (Platform.isIOS && AppStrings.appleLogin),
      child: Column(
        children: [
          HStack(
            alignment: MainAxisAlignment.center,
            [
              //facebook
              Visibility(
                visible: AppStrings.facebbokLogin,
                child: GestureDetector(
                  onTap: (){
                    model.socialMediaLoginService.facebookLogin(model);
                  },
                  child: Image.asset("assets/images/facebook.png",width: 40,height: 40,),
                ),
              ),
              SizedBox(width: 10,),
              //google
              Visibility(
                visible: AppStrings.googleLogin,
                child: GestureDetector(
                  onTap: (){
                      model.socialMediaLoginService.googleLogin(model);
                  },
                  child: Image.asset("assets/images/google.png",width: 40,height: 40,),
                ),
              ),
              SizedBox(width: 10,),
              Visibility(
                visible: AppStrings.googleLogin,
                child: GestureDetector(
                  onTap: (){
                    model.initateQrcodeLogin();
                  },
                  child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.qr_code_scanner,color: Colors.black,),
                  ))
                ),
              ),



            ],
          ).centered(),
          SizedBox(height: 10,),
          //apple
          Visibility(
            visible: Platform.isIOS && AppStrings.appleLogin,
            child: SignInWithAppleButton(
              onPressed: () => model.socialMediaLoginService.appleLogin(model),
            ).px24().py12(),
          ),
        ],
      ),
    );
  }
}
