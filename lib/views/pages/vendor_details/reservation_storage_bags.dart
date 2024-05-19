import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/view_models/service_vendor_details.vm.dart';
import 'package:huops/views/pages/vendor_details/reservation_storage_bags_details.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../../../constants/api.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/base.page.withoutNavbar.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';

class ReservationStoragePage extends StatefulWidget {
  const ReservationStoragePage(
      {super.key, required this.vendor, required this.vendorId});

  final int vendorId;
  final Vendor vendor;

  @override
  State<ReservationStoragePage> createState() => _ReservationStoragePageState();
}

class _ReservationStoragePageState extends State<ReservationStoragePage> {
  final _dio = Dio();
  String date = DateTime.now().toString().substring(0, 10);
  final int nTotalCount = 20;
  final int nInitValue = 1;
  int nCurrentValue = 1;
  String selectedSizeOfStorage = "large";
  TextEditingController descriptionTEC = TextEditingController();

  // List<File>? bagsStorageImages;
  List<File> bagsStorageImages = [File('')];

  File bagStorageImage = File('');

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.17,
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              PickedFile? file = (await ImagePicker.platform
                                  .pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 25));
                              setState(() {
                                bagStorageImage = File(file!.path);
                                // bagsStorageImages[index] = File(file!.path);
                                // bagsStorageImages.length < 3 ? bagsStorageImages.add(File("")) : null;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image,),
                                15.heightBox,
                                Text(
                                  "Gallery".tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ).centered(),
                          ),
                        ).glassMorphic(),
                      ),
                      10.widthBox,
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.17,
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              PickedFile? file =
                                  (await ImagePicker.platform.pickImage(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.camera_fill),
                                15.heightBox,
                                Text(
                                  "Camera".tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ).centered(),
                          ),
                        ).glassMorphic(),
                      ),
                    ],
                  ),
                  10.heightBox,
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        // margin: const EdgeInsets.all(8),//
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 15,
                            ),
                            8.widthBox,
                            Text(
                              "Back".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ).p12().glassMorphic(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ServiceVendorDetailsViewModel>.reactive(
        viewModelBuilder: () =>
            ServiceVendorDetailsViewModel(context, vendor: widget.vendor),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return BasePageWithoutNavBar(
            showAppBar: true,
            showLeadingAction: true,
            title: "Storage Bag".tr(),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //date
                        "Start Storage Date".tr().text.xl.white.make(),
                        5.heightBox,
                        Row(
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
                                      date = value.toString().substring(0, 10);
                                    });
                                  },
                                  theme: CurveDatePickerTheme(
                                    monthFormat: MonthFormat.threeLetters,
                                    wheelPickerHeight: 50.0,
                                    overlay:
                                        ScrollWheelDatePickerOverlay.highlight,
                                    itemTextStyle: defaultItemTextStyle
                                        .copyWith(color: AppColor.primaryColor),
                                    overlayColor: Colors.transparent,
                                    overAndUnderCenterOpacity: 0.5,
                                    itemExtent: 50.0,
                                    diameterRatio: 1.0,
                                  )),
                            ),
                          ],
                        ).glassMorphic(),
                        SizedBox(
                          height: 15,
                        ),
                        //days
                        "Number of days to store".tr().text.xl.white.make(),
                        5.heightBox,
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    "assets/icons/days.png",
                                    color: AppColor.primaryColor,
                                  ),
                                )),
                            Expanded(
                              flex: 3,
                              child: WheelSlider.number(
                                interval: 1,
                                // this field is used to show decimal/double values
                                perspective: 0.01,
                                totalCount: nTotalCount,
                                initValue: nInitValue,
                                unSelectedNumberStyle: TextStyle(
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
                        ).glassMorphic(),
                        //
                        15.heightBox,
                        "Size of Storage Bag".tr().text.xl.white.make(),
                        5.heightBox,
                        DropdownButtonFormField<dynamic>(
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .8,
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
                        ).glassMorphic(),
                        15.heightBox,
                        //
                        "Description".tr().text.xl.white.make(),
                        CustomTextFormField(
                          textEditingController: descriptionTEC,
                          underline: false,
                          maxLines: 4,
                        ).glassMorphic(),
                        //images
                        15.heightBox,
                        "Image of Storage Bag".tr().text.xl.white.make(),
                        5.heightBox,
                        bagStorageImage.path.isEmpty
                            ? Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColor.primaryColor),
                                child: "Add Image".text.white.make(),
                              ).onTap(() {
                                bagStorageImage.path.isEmpty
                                    ? selectImage(context)
                                    : null;
                                print("###########${bagStorageImage}");
                              })
                            : Image.file(
                          bagStorageImage,
                          fit: BoxFit.fill,
                          width: double.infinity,
                        )
                            .onInkTap(() {
                          selectImage(context);
                        })
                            .box
                            .roundedSM
                            .clip(Clip.antiAlias)
                            .make()
                            .p12(),
                        // Container(
                        //   height: 100,
                        //   width: 100,
                        //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),image: DecorationImage(
                        //     image: FileImage(
                        //       bagStorageImage,
                        //     ),
                        //     fit: BoxFit.fill,
                        //   )),
                        //   child: Text(" "),
                        // ).onTap(() {
                        //   selectImage(context);
                        // }).pOnly(right: 5),
                        // confirm storage bags
                        SizedBox(
                          height: 30,
                        ),
                        model.typeOfStorage != null?CustomButton(
                          onPressed:() async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReservationStorageBagsDetails(
                                          bagStorageImage: bagStorageImage,
                                          descriptionOfBags:
                                              descriptionTEC.text,
                                          dateOfStorageBags: date,
                                          daysOfStorageBags: nCurrentValue,
                                          sizeOfStorageBags:
                                              selectedSizeOfStorage,
                                          typeOfStorage:
                                              model.typeOfStorage ?? {},
                                          vendorId: widget.vendorId,
                                        )));
                          },
                          color: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: "Storage you bag".tr(),
                        ):Center(child:LoadingShimmer()),
                      ]).px12(),
                ),
              ),
            ),
          );
        });
  }
}
