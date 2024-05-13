import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/api.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/views/pages/payment/custom_webview.page.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      elevation: 0,
      title: "Contact Us".tr(),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/contact_us.png", width: 300)
               .centered(),
          CustomButton(
            title: "Live Support".tr(),
            onPressed: () async {
              final url = Api.inappSupport;
              if (Platform.isIOS) {
                await launchUrlString(url);
                return;
              }
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomWebviewPage(
                      selectedUrl: url,
                    ),
                  ),
              );
            },
            shapeRadius: 12,
          ).centered().pSymmetric(h: 40).pOnly(bottom: 12),
          "Get in touch".tr().text.xl4.semiBold.make(),
          "Have a question? We're here to help!, and we'll respond within 24 hours."
              .tr()
              .text
              .make(),
          GestureDetector(
            onTap: () {
              launchUrlString('https://wa.me/+201068780588',mode: LaunchMode.externalApplication);
            },
            child: Card(
              elevation: 1,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(FontAwesome.whatsapp, color: Colors.green),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "WhatsApp".text.xl.color(Colors.white).bold.make(),
                    Text(
                      "+201068780588".tr(),
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ]).px16().py8().glassMorphic(),
            ).py2(),
          ),
          GestureDetector(
            onTap: () {
              launchUrlString('mailto:support@huopsapp.com',mode: LaunchMode.externalApplication);
            },
            child: Card(
              elevation: 1,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(FlutterIcons.gmail_mco, color: Colors.red),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Email".text.xl.bold.color(Colors.white).make(),
                    Text(
                      "support@huopsapp.com".tr(),
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ]).px16().py8().glassMorphic(),
            ).py2(),
          ),
          GestureDetector(
            onTap: () {
              launchUrlString('tel:+201068780588',mode: LaunchMode.externalApplication);
            },
            child: Card(
              elevation: 2,
              color: Colors.transparent,
              surfaceTintColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(FontAwesome.phone, color: Colors.blue),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Phone".text.xl.bold.color(Colors.white).make(),
                    Text(
                      "+201068780588".tr(),
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ]).px16().py8().glassMorphic(),
            ).py2(),
          ),
          GestureDetector(
            onTap: () {
              launchUrlString('https://www.huopsapp.com',mode: LaunchMode.externalApplication);
            },
            child: Card(
              elevation: 2,
              color: Colors.transparent,
              surfaceTintColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(AntDesign.earth, color: Colors.teal),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Website".text.xl.color(Colors.white).bold.make(),
                    Text(
                      "www.huopsapp.com".tr(),
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ]).px16().py8().glassMorphic(),
            ).py2(),
          ),
        ],
      ).p20().scrollVertical().centered(),
    );
  }
}
