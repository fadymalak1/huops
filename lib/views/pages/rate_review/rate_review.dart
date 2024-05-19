import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:double_back_to_close/toast.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class RateAndReview extends StatefulWidget {
  const RateAndReview({super.key});

  @override
  State<RateAndReview> createState() => _RateAndReviewState();
}

class _RateAndReviewState extends State<RateAndReview> {
  double rating = 0;
  TextEditingController comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
        title: "Rate And Review",
        showLeadingAction: true,
        showAppBar: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.heightBox,
            Text(
              "What's your rate for Huops?".tr(),
              style: TextStyle(fontSize: 20),
            ),
            30.heightBox,
            VxRating(
              maxRating: 5.0,
              value: rating,
              isSelectable: true,
              onRatingUpdate: (value) {
                setState(() {
                  rating = double.parse(value);
                  log(rating.toString());
                });
              },
              selectionColor: AppColor.ratingColor,
              size: 45,
            ).p4().centered(),
            50.heightBox,
            Text(
              "Type your review here".tr(),
              style: TextStyle(fontSize: 20),
            ),
            5.heightBox,
            "Please share your opinions and suggestions if you encounter any problems."
                .tr()
                .text
                .color(Colors.white54)
                .make(),
            10.heightBox,
            TextFormField(
              controller: comment,
              decoration: InputDecoration(
                hintText: "Write here...".tr(),
              ),
            ),
            40.heightBox,
            ElevatedButton(
              child: "Send proposal".text.xl2.make(),
              onPressed: rating == 0 || rating == "0.0"
                  ? null
                  : () async {
                      String token = await AuthServices.getAuthBearerToken();

                      final response = await http.post(
                        Uri.parse("http://huopsapp.it/api/app/user/review"),
                        headers: <String, String>{
                          "Authorization": "Bearer $token",
                        },
                        body: {
                            "rate": rating.toString(),
                            "comment": comment.text,
                          },
                      );
                      log(response.body.toString());
                      if(response.statusCode==200){
                        Toast.show("Thank you for your feedback".tr(), context);
                        Navigator.pop(context);

                      }
                    },
            ).wFull(context).h(45).cornerRadius(10),
            50.heightBox,
            Divider(
              color: Colors.white54,
            ),
            50.heightBox,
            ElevatedButton(
              child: "Rate us on the store".text.xl2.make(),
              onPressed: () async {
                final InAppReview inAppReview = InAppReview.instance;
                if (Platform.isAndroid) {
                  inAppReview.openStoreListing(
                      appStoreId: AppStrings.appStoreId);
                } else if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                } else {
                  inAppReview.openStoreListing(
                      appStoreId: AppStrings.appStoreId);
                }
              },
            ).wTwoThird(context).h(45).cornerRadius(50).centered(),
          ],
        ).p20());
  }
}
