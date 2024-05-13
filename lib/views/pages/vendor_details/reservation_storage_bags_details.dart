import 'dart:convert';
import 'dart:io';

import 'package:double_back_to_close/toast.dart';
import 'package:flutter/material.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../../constants/api.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/buttons/custom_button.dart';



class ReservationStorageBagsDetails extends StatefulWidget {
  const ReservationStorageBagsDetails(
      {super.key,
      required this.vendorId,
      required this.bagStorageImage,
      required this.descriptionOfBags,
      required this.dateOfStorageBags,
      required this.daysOfStorageBags,
      required this.sizeOfStorageBags,
      required this.typeOfStorage,
      });

  final int vendorId;
  final File bagStorageImage;
  final String descriptionOfBags;
  final String dateOfStorageBags;
  final int daysOfStorageBags;
  final String sizeOfStorageBags;
  final Map<String, dynamic> typeOfStorage;

  @override
  State<ReservationStorageBagsDetails> createState() => _ReservationStorageBagsDetailsState();
}

class _ReservationStorageBagsDetailsState extends State<ReservationStorageBagsDetails> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      showAppBar: true,
        title: "Storage Bags".tr(),
        showLeadingAction: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image of bags
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                image: FileImage(
                  widget.bagStorageImage,
                ),
                fit: BoxFit.fill,
              )
              ),
              child: Text(" "),
            ),
            20.heightBox,
            //Description
            "Description".tr().text.xl.white.make(),
            10.heightBox,
            widget.descriptionOfBags.text.medium.maxLines(4).make(),
            20.heightBox,
            //Start date Storage & number og days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        "Check-in".tr().text.xl.white.make(),
                        5.heightBox,
                        widget.dateOfStorageBags.text.xl.white.make(),
                      ],
                    ),
                    Icon(
                      Icons.date_range,
                      color: Colors.white,
                      size: 25,
                    )
                  ],
                ).expand(),
                SizedBox(
                  height: 40,
                  child: VerticalDivider(thickness: 2,
                    width: 20,
                    color: Colors.white,),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        "Duration".tr().text.xl.white.make(),
                        5.heightBox,
                        "${widget.daysOfStorageBags.toString()} Days".text.xl.white.make(),
                      ],
                    ),
                    Container(
                      height: 25,width: 25,
                      child: Image.asset("assets/icons/days.png",color: Colors.white,),
                    )
                  ],
                ).expand(),
              ],
            ),
            30.heightBox,
            //
            "Bag Size".tr().text.xl.white.make(),
            10.heightBox,
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  // padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    border: Border.all(color:widget.sizeOfStorageBags == "small" ? Colors.white : Colors.grey),
                  ),
                  child: "S".text.medium.color(widget.sizeOfStorageBags == "small" ? Colors.white : Colors.grey).make().centered(),
                ).onTap(() {}),
                15.widthBox,
                Container(
                  height: 40,
                  width: 40,
                  // padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color:widget.sizeOfStorageBags == "medium" ? Colors.white : Colors.grey),
                  ),
                  child: "M".text.medium.color(widget.sizeOfStorageBags == "medium" ? Colors.white : Colors.grey).make().centered(),
                ).onTap(() {}),
                15.widthBox,
                Container(
                  height: 40,
                  width: 40,
                  // padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color:widget.sizeOfStorageBags == "large" ? Colors.white : Colors.grey),
                  ),
                  child: "L".text.medium.color(widget.sizeOfStorageBags == "large" ? Colors.white : Colors.grey).make().centered(),
                ).onTap(() {}),
              ],
            ),
            20.heightBox,
            Divider(color: Colors.white,thickness: 1).pOnly(left: 50,right: 50),
            20.heightBox,
            "Price for ${widget.sizeOfStorageBags} Size".tr().text.xl.white.make(),
            10.heightBox,
            "\$${widget.typeOfStorage[widget.sizeOfStorageBags]}".tr().text.xl.bold.white.make(),
            10.heightBox,
            "Taxes and fees Free".tr().text.xl.white.make(),
            20.heightBox,
            Divider(color: Colors.white,thickness: 1).pOnly(left: 50,right: 50),
            20.heightBox,
            _isLoading ? Center(child: CircularProgressIndicator()) : CustomButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                String? userId = sharedPreferences.getString('user_id');
                String urlOfStorageBags = Api.baseUrl+"/user/bag/reservation/$userId/${widget.vendorId}";
                var request = http.MultipartRequest('POST', Uri.parse(urlOfStorageBags));
                Map<String,String> headers={
                  "Accept": "multipart/form-data",
                  "Content-type": "multipart/form-data",
                };
                if( widget.bagStorageImage.path.toString() != '' || widget.bagStorageImage.path.isNotEmpty){
                  request.files.add(
                    http.MultipartFile(
                      'image',
                      widget.bagStorageImage.readAsBytes().asStream(),
                      widget.bagStorageImage.lengthSync(),
                      filename: widget.bagStorageImage.path,
                    ),
                  );
                }

                request.fields['date'] = widget.dateOfStorageBags;
                request.fields['days'] = widget.daysOfStorageBags.toString();
                request.fields['big_size'] = widget.sizeOfStorageBags;
                request.fields['price'] = widget.sizeOfStorageBags == "large" ? widget.typeOfStorage['large']
                    :widget.sizeOfStorageBags == "medium" ?  widget.typeOfStorage['medium']
                    :widget.typeOfStorage['small'] ;
                request.fields['description'] = widget.descriptionOfBags;

                request.headers.addAll(headers);
                request.fields.addAll({});

                var res = await request.send().timeout(
                  const Duration(seconds: 90),
                );
                final respStr = await res.stream.bytesToString();

                // var result = jsonDecode(respStr)['data'];
                if (res.statusCode == 200 ) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Toast.show(
                      "Storage Bag Done".tr(),
                      context);
                }else{
                  print("##EROOR### in storage bags###${res.statusCode}");
                  Toast.show(
                      "Storage Bag Failed".tr(),
                      context);
                }
                setState(() {
                  _isLoading = false;
                });
                },
              color: Color(0xff04b415),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: "Confirm".tr(),
            ),
          ],
        ).p12(),
    );
  }
}
