import 'dart:io';

import 'package:dio/dio.dart';
import 'package:double_back_to_close/toast.dart';
import 'package:flutter/material.dart';
import 'package:huops/views/pages/vendor_details/reservation_storage_bags_details.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../../../constants/api.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/base.page.withoutNavbar.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';

class ReservationStoragePage extends StatefulWidget {
  const ReservationStoragePage({super.key, required this.typeOfStorage, required this.vendorId});

  final Map<String, dynamic> typeOfStorage;
  final int vendorId;

  @override
  State<ReservationStoragePage> createState() => _ReservationStoragePageState();
}

class _ReservationStoragePageState extends State<ReservationStoragePage> {
  final _dio = Dio();
  String date=DateTime.now().toString().substring(0,10);
  final int nTotalCount = 20;
  final int nInitValue = 1;
  int nCurrentValue = 1;
  String selectedSizeOfStorage = "large";
  TextEditingController descriptionTEC = TextEditingController();


  // List<File>? bagsStorageImages;
  // List<File> bagsStorageImages = [File('')];

  File bagStorageImage = File('');

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            // title: Center(child: Text("select image".tr(),style: TextStyle(fontWeight: FontWeight.bold),)),
            backgroundColor: Colors.white30,
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: ()async {
                    Navigator.pop(context);
                    PickedFile? file =
                    (await ImagePicker.platform.pickImage(source: ImageSource.gallery,imageQuality: 25));
                    setState(() {
                      bagStorageImage = File(file!.path);
                      // bagsStorageImages[index] = File(file!.path);
                      // bagsStorageImages.length < 3 ? bagsStorageImages.add(File("")) : null;
                    });
                  },
                  child: Center(child: Text("Select image from your gallery".tr(),style: TextStyle(fontWeight: FontWeight.bold),))),
              SimpleDialogOption(
                onPressed: ()async{
                  Navigator.pop(context);
                  PickedFile? file = (await ImagePicker.platform.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 25,
                    maxHeight: 675,
                    maxWidth: 960,
                  ));
                  setState(() {
                    bagStorageImage = File(file!.path);
                    // bagsStorageImages[index] = File(file!.path);
                    // bagsStorageImages.length < 6 ? bagsStorageImages.add(File("")) : null;
                  });
                },
                child: Center(child: Text("Take image from your camera".tr(),style: TextStyle(fontWeight: FontWeight.bold),)),
              ),
              SimpleDialogOption(
                child: Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).primaryColor,
                        ),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back,color: Colors.white,size: 20,),
                            8.widthBox,
                            Text(
                              "Back".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ))),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      showAppBar: true,
      showLeadingAction: true,
      title: "Storage your Bag".tr(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //date
                  "Start Storage:".tr().text.xl.white.make(),
                  10.heightBox,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.date_range,
                              color: AppColor.primaryColor,
                              size: 30,
                            )),
                        Expanded(
                          flex: 3,
                          child: ScrollWheelDatePicker(
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  date = value.toString().substring(0,10);
                                });
                              },
                              theme: CurveDatePickerTheme(
                                monthFormat: MonthFormat.threeLetters,
                                wheelPickerHeight: 50.0,
                                overlay: ScrollWheelDatePickerOverlay.highlight,
                                itemTextStyle: defaultItemTextStyle.copyWith(
                                    color: AppColor.primaryColor),
                                overlayColor: Colors.transparent,
                                overAndUnderCenterOpacity: 0.5,
                                itemExtent: 50.0,
                                diameterRatio: 1.0,
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  //days
                  "Number of days:".tr().text.xl.white.make(),
                  10.heightBox,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,width: 30,
                              child: Image.asset("assets/icons/days.png",color: AppColor.primaryColor,),
                            )),
                        Expanded(
                          flex: 3,
                          child: WheelSlider.number(

                            interval: 1, // this field is used to show decimal/double values
                            perspective: 0.01,
                            totalCount: nTotalCount,
                            initValue: nInitValue,
                            unSelectedNumberStyle:  TextStyle(
                              fontSize: 18.0,

                              color: AppColor.primaryColor.withOpacity(0.4),
                            ),
                            selectedNumberStyle: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),

                            currentIndex: nCurrentValue,
                            onValueChanged: (val) {
                              setState(() {
                                nCurrentValue = val;
                              });
                            },
                            // hapticFeedbackType: HapticFeedbackType.heavyImpact,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                  10.heightBox,
                  "Size of your bag:".tr().text.xl.white.make(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: DropdownButtonFormField<dynamic>(
                      autovalidateMode: AutovalidateMode.always,
                      elevation: 9,
                      value: selectedSizeOfStorage,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      isExpanded: true,
                      items: ['large', 'medium', 'small']
                          .map((label) => DropdownMenuItem(
                          value: label,
                          child: Align(
                              alignment: const Alignment(.5, 1),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: Text(
                                    label.toString(),
                                    textAlign: TextAlign.start,
                                  )))))
                          .toList(),
                      // dropdownColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          selectedSizeOfStorage = value;
                        });
                      },
                    ),
                  ),
                  10.heightBox,
                  //
                  "Description:".tr().text.xl.white.make(),
                  CustomTextFormField(
                    textEditingController: descriptionTEC,
                    underline: false,
                    // hintText: "Description".tr(),
                    maxLines: 3,
                  ).color(Colors.black).cornerRadius(15),
                  //images
                  10.heightBox,
                  "Image Of Bag:".tr().text.xl.white.make(),
                  10.heightBox,
                  // bagsStorageImages[0].path.isEmpty ?
                  bagStorageImage.path.isNotEmpty ? SizedBox() : Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppColor.primaryColor),
                    child: "Add Image".text.white.make(),
                  ).onTap(() {
                    bagStorageImage.path.isEmpty ? selectImage(context) : null ;
                    print("###########${bagStorageImage}");
                  }) ,
                  10.heightBox,
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),image: DecorationImage(
                      image: FileImage(
                        bagStorageImage,
                      ),
                      fit: BoxFit.fill,
                    )),
                    child: Text(" "),
                  ).onTap(() {
                    selectImage(context);
                  }).pOnly(right: 5),
                  // confirm storage bags
                  SizedBox(height: 30,),
                  CustomButton(
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>ReservationStorageBagsDetails(
                            bagStorageImage: bagStorageImage,
                            descriptionOfBags: descriptionTEC.text,
                            dateOfStorageBags: date,
                            daysOfStorageBags: nCurrentValue,
                            sizeOfStorageBags: selectedSizeOfStorage,
                            typeOfStorage: widget.typeOfStorage,
                            vendorId: widget.vendorId,
                          )));

                    },
                    color: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: "Storage you bag".tr(),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
