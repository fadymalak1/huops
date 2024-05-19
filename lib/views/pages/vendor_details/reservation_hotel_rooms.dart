import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/view_models/service_vendor_details.vm.dart';
import 'package:huops/views/pages/vendor_details/reservation_hotel_rooms_details.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wheel_slider/wheel_slider.dart';

class ReservationHotelRooms extends StatefulWidget {
  const ReservationHotelRooms({super.key, required this.vendor});

  // final ServiceVendorDetailsViewModel model;
  final Vendor vendor;

  @override
  State<ReservationHotelRooms> createState() => _ReservationHotelRoomsState();
}

class _ReservationHotelRoomsState extends State<ReservationHotelRooms> {
  final int daysTotalCount = 20;
  final int daysInitValue = 1;
  int daysCurrentValue = 1;
  final int guestsTotalCount = 20;
  final int guestsInitValue = 1;
  int guestsCurrentValue = 1;
  final int sroomsTotalCount = 20;
  final int sroomsInitValue = 1;
  int sroomsCurrentValue = 1;
  final int droomsTotalCount = 20;
  final int droomsInitValue = 1;
  int droomsCurrentValue = 1;
  String date = DateTime.now().toString().substring(0, 10);

  TextEditingController details = TextEditingController();

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
            title: "Reservation Hotel Rooms",
            body: Column(children: [
              Row(
                children: [
                  Text("Start Date").text.xl.make().expand(flex: 1),
                  10.widthBox,
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
                  ).glassMorphic().expand(flex: 3),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Number of Days")
                      .text
                      .xl
                      .align(TextAlign.center)
                      .make()
                      .expand(flex: 1),
                  10.widthBox,
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
                          totalCount: daysTotalCount,
                          initValue: daysInitValue,
                          unSelectedNumberStyle: TextStyle(
                            fontSize: 18.0,
                            color: AppColor.primaryColor.withOpacity(0.4),
                          ),
                          selectedNumberStyle: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
                          ),

                          currentIndex: daysCurrentValue,
                          onValueChanged: (val) {
                            setState(() {
                              daysCurrentValue = val;
                            });
                          },
                          // hapticFeedbackType: HapticFeedbackType.heavyImpact,
                        ),
                      ),
                    ],
                  ).glassMorphic().expand(flex: 3),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text("Single Rooms").text.xl.make(),
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                height: 30,
                                width: 30,
                                child: Icon(
                                  Icons.bedroom_child_outlined,
                                  color: AppColor.primaryColor,
                                ),
                              )),
                          Expanded(
                            flex: 3,
                            child: WheelSlider.number(
                              interval: 1,
                              // this field is used to show decimal/double values
                              perspective: 0.01,
                              totalCount: sroomsTotalCount,
                              initValue: sroomsInitValue,
                              unSelectedNumberStyle: TextStyle(
                                fontSize: 18.0,
                                color: AppColor.primaryColor.withOpacity(0.4),
                              ),
                              selectedNumberStyle: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor,
                              ),

                              currentIndex: sroomsCurrentValue,
                              onValueChanged: (val) {
                                setState(() {
                                  sroomsCurrentValue = val;
                                });
                              },
                              // hapticFeedbackType: HapticFeedbackType.heavyImpact,
                            ),
                          ),
                        ],
                      ).glassMorphic(),
                    ],
                  ).expand(),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text("Double Rooms").text.xl.make(),
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                height: 30,
                                width: 30,
                                child: Icon(
                                  Icons.bedroom_child_outlined,
                                  color: AppColor.primaryColor,
                                ),
                              )),
                          Expanded(
                            flex: 3,
                            child: WheelSlider.number(
                              interval: 1,
                              // this field is used to show decimal/double values
                              perspective: 0.01,
                              totalCount: droomsTotalCount,
                              initValue: droomsInitValue,
                              unSelectedNumberStyle: TextStyle(
                                fontSize: 18.0,
                                color: AppColor.primaryColor.withOpacity(0.4),
                              ),
                              selectedNumberStyle: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor,
                              ),

                              currentIndex: droomsCurrentValue,
                              onValueChanged: (val) {
                                setState(() {
                                  droomsCurrentValue = val;
                                });
                              },
                              // hapticFeedbackType: HapticFeedbackType.heavyImpact,
                            ),
                          ),
                        ],
                      ).glassMorphic(),
                    ],
                  ).expand(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Number of Guests")
                      .text
                      .xl
                      .align(TextAlign.center)
                      .make()
                      .expand(flex: 1),
                  10.widthBox,
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Icon(
                              CupertinoIcons.person_3,
                              color: AppColor.primaryColor,
                            ),
                          )),
                      Expanded(
                        flex: 3,
                        child: WheelSlider.number(
                          interval: 1,
                          // this field is used to show decimal/double values
                          perspective: 0.01,
                          totalCount: guestsTotalCount,
                          initValue: guestsInitValue,
                          unSelectedNumberStyle: TextStyle(
                            fontSize: 18.0,
                            color: AppColor.primaryColor.withOpacity(0.4),
                          ),
                          selectedNumberStyle: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
                          ),

                          currentIndex: guestsCurrentValue,
                          onValueChanged: (val) {
                            setState(() {
                              guestsCurrentValue = val;
                            });
                          },
                          // hapticFeedbackType: HapticFeedbackType.heavyImpact,
                        ),
                      ),
                    ],
                  ).glassMorphic().expand(flex: 3),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Details".tr().text.xl.white.make(),
                  SizedBox(
                    height: 5,
                  ),
                  CustomTextFormField(
                    textEditingController: details,
                    underline: false,
                    maxLines: 4,
                  ).glassMorphic(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationHotelRoomsDetails(
                        count_of_people: guestsCurrentValue.toString(),
                        date: DateTime.parse(date),
                        days: daysCurrentValue.toString(),
                        details: details.text,
                        double: droomsCurrentValue.toString(),
                        rooms: (sroomsCurrentValue+droomsCurrentValue).toString(),
                        single: sroomsCurrentValue.toString(),
                        vendor: model.vendor,
                      ),
                    ),
                  );
                },
                color: AppColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: "Book Now".tr(),
              )
            ]).p20(),
          );
        });
  }
}
