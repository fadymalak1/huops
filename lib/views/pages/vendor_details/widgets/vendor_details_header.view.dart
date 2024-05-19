import 'dart:developer';

import 'package:double_back_to_close/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_ui_settings.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/vendor_details.vm.dart';
import 'package:huops/views/pages/auth/login.page.dart';
import 'package:huops/views/pages/search/main_search.page.dart';
import 'package:huops/views/pages/vendor/vendor_reviews.page.dart';
import 'package:huops/views/pages/vendor_details/menu_page.dart';
import 'package:huops/widgets/buttons/call.button.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/buttons/route.button.dart';
import 'package:huops/widgets/buttons/share.btn.dart';
import 'package:huops/widgets/buttons/time.button.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/tags/close.tag.dart';
import 'package:huops/widgets/tags/delivery.tag.dart';
import 'package:huops/widgets/tags/open.tag.dart';
import 'package:huops/widgets/tags/pickup.tag.dart';
import 'package:huops/widgets/tags/time.tag.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wheel_picker/wheel_picker.dart';
import 'package:wheel_slider/wheel_slider.dart';

class VendorDetailsHeader extends StatefulWidget {
  const VendorDetailsHeader(this.model,
      {this.isDelivery = true,this.showFeatureImage = true, Key? key,
      })
      : super(key: key);

  final VendorDetailsViewModel model;
  final bool showFeatureImage;
  final bool isDelivery;

  @override
  State<VendorDetailsHeader> createState() => _VendorDetailsHeaderState();
}

class _VendorDetailsHeaderState extends State<VendorDetailsHeader> {
  int? tableVendorId;

  final now = TimeOfDay.now();
  late final hoursWheel = WheelPickerController(
    itemCount: 12,
    initialIndex: now.hour % 12,
  );
  late final periodWheel = WheelPickerController(
    itemCount: 2,
    initialIndex: now.period.index,
  );
  late final minutesWheel = WheelPickerController(
    itemCount: 60,
    initialIndex: now.minute,
    mounts: [hoursWheel],
  );
  late final guestsWheel = WheelPickerController(
    itemCount: 10,
    initialIndex: 0,
  );
  String date=DateTime.now().toString().substring(0,10);

  @override
  void initState() {
    super.initState();

  }
  openBookingDialog() async {
    final textStyle = TextStyle(
      color: AppColor.primaryColor,
      fontWeight: FontWeight.bold,
      height: 1.5,
      fontSize: 17,
    );

    final int nTotalCount = 20;
    final int nInitValue = 1;
    final int tableInitValue = 1;
    int nCurrentValue=nInitValue;
    int tableCurrentValue=tableInitValue;
    final wheelStyle = WheelPickerStyle(
      shiftAnimationStyle: WheelShiftAnimationStyle(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
      size: 50,
      itemExtent: 30,
      diameterRatio: 0.8,
    );
    Widget itemBuilder(BuildContext context, int index) {
      return Text("$index".padLeft(2, '0'), style: textStyle);
    }

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2.2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Column(
                            children: [
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
                                        CupertinoIcons.clock,
                                        color: AppColor.primaryColor,
                                        size: 30,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              WheelPicker(
                                                builder: itemBuilder,
                                                controller: hoursWheel,
                                                looping: true,
                                                style: wheelStyle,
                                                selectedIndexColor: AppColor.primaryColor,
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Text(":", style: textStyle),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              WheelPicker(
                                                builder: itemBuilder,
                                                controller: minutesWheel,
                                                style: wheelStyle,
                                                enableTap: true,
                                                selectedIndexColor: AppColor.primaryColor,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          WheelPicker(
                                            // itemCount: 2,
                                            builder: (context, index) {
                                              return Text(["AM", "PM"][index],
                                                  style: textStyle);
                                            },
                                            controller: periodWheel,

                                            looping: true,
                                            style: wheelStyle.copyWith(
                                              shiftAnimationStyle:
                                              WheelShiftAnimationStyle(
                                                duration: Duration(seconds: 1),
                                                curve: Curves.bounceOut,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
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
                                          CupertinoIcons.person_3_fill,
                                          color: AppColor.primaryColor,
                                          size: 30,
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
                              SizedBox(height: 20,),
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
                                          Icons.table_bar,
                                          color: AppColor.primaryColor,
                                          size: 30,
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

                                        currentIndex: tableCurrentValue,
                                        onValueChanged: (val) {
                                          setState(() {
                                            tableCurrentValue = val;
                                          });
                                        },
                                        // hapticFeedbackType: HapticFeedbackType.heavyImpact,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30,),
                          CustomButton(
                            onPressed: () {
                              log("${nCurrentValue}");
                              if(nCurrentValue==0){
                                Toast.show( "Please select number of guests", context,);
                              }else{
                                widget.model.makeBook(widget.model.vendor!.id,date
                                    , "${hoursWheel.selected}:${minutesWheel.selected} ${periodWheel.selected==0?"AM":"PM"}", nCurrentValue,tableCurrentValue);
                              }

                            },
                            color: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: "Make a Reservation".tr(),
                          ),

                        ]),
                  ),
                ),
              ).glassMorphic(circularRadius: 20,),
            );
          });
        });
  }

  openTimeDialog(){
    showDialog(context: context, builder: (context){
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(children: [
                  // Icon(Icons.timer_outlined,size: 40,color: AppColor.primaryColor,),
                  Text("Prepare Time",style: TextStyle(color: AppColor.primaryColor,fontSize: 20),),
                  Spacer(),
                  Text("${widget.model.vendor!.prepareTime} min",style: TextStyle(color: AppColor.primaryColor,fontSize: 20),),
                ],),
                Row(children: [
                  // Icon(Icons.delivery_dining,size: 40,color: AppColor.primaryColor,),
                  Text("Delivery Time",style: TextStyle(color: AppColor.primaryColor,fontSize: 20),),
                  Spacer(),
                  Text("${widget.model.vendor!.deliveryTime} min",style: TextStyle(color: AppColor.primaryColor,fontSize: 20),),
                ],),
              ]
            ),
          ),
        ).glassMorphic(),
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    child: CustomImage(
                      width: double.infinity,
                      imageUrl: widget.model.vendor!.featureImage,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .3,
                      canZoom: false,
                    ).box.clip(Clip.antiAlias).bottomRounded(value: 20).make(),
                  ),
                  AppBar(
                    elevation: 0,
                    title: GestureDetector(
                      onTap: () =>
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainSearchPage(),
                            ),
                          ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            enabled: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide.none),
                            // filled: true,
                            contentPadding: EdgeInsets.all(5),
                            // fillColor: AppColor.primaryColor.withOpacity(0.3),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ).glassMorphic(
                        circularRadius: 50,
                        opacity: 0.2,
                        blur: 8,
                      ),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    actions: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: FittedBox(
                          child: ShareButton(
                            model: widget.model,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  VStack(
                    crossAlignment: CrossAxisAlignment.center,
                    [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomVisibilty(
                                  visible: (widget.model
                                      .vendor!.longitude
                                      .isNotEmptyAndNotNull),
                                  //location routing
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      RouteButton(widget.model.vendor!, size: 20),
                                      Text("Location",
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                //call button
                                if (widget.model.vendor!.phone
                                    .isNotEmptyAndNotNull)
                                  Visibility(
                                    visible: true,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        CallButton(widget.model.vendor, size: 20),
                                        Text("Phone",
                                            style: TextStyle(fontSize: 12)),

                                      ],
                                    ),
                                  )
                                else
                                  UiSpacer.emptySpace(),
                              ]),
                          widget.model.vendor!.isOpen
                              ? "Opened".text.bold.color(Colors.green)
                              .make()
                              : "Closed".text.bold.color(Colors.red).make(),
                        ],
                      ),
                      UiSpacer.verticalSpace(space: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.isDelivery?CustomVisibilty(
                              visible: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                children: [
                                  GestureDetector(onTap: (){widget.model.vendor!.prepareTime!=null?openTimeDialog():Toast.show("Time not available", context);},child: TimeButton(widget.model.vendor!, size: 20)),
                                  Text("Time",
                                      style: TextStyle(fontSize: 12),
                                  ),

                                ],
                              ),
                            ):SizedBox(),
                            Spacer(),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    log(widget.model.isFav.toString());
                                    if(widget.model.isAuthenticated()){
                                    if (widget.model.isFav) {
                                      widget.model.isFav = false;
                                      Toast.show(
                                          widget.model.isFav
                                              ? "Added to favourite"
                                              : "Removed from favourite",
                                          context);
                                      widget.model.notifyListeners();

                                      widget.model.processRemoveVendor(widget.model.vendor, context);
                                    } else {
                                      widget.model.isFav = true;
                                      Toast.show(
                                          widget.model.isFav
                                              ? "Added to favourite"
                                              : "Removed from favourite",
                                          context);
                                      widget.model.notifyListeners();
                                      await widget.model.addToFav();
                                    }}else{
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            20),
                                        color: AppColor.primaryColor),
                                    child: Row(
                                      children: [
                                        Icon(widget.model.isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                          size: 20,)
                                      ],
                                    ),
                                  ),
                                ),
                                Text("Favourite",
                                    style: TextStyle(fontSize: 12)),

                              ],
                            ),

                            Spacer(),
                             widget.isDelivery?Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    widget.model.isAuthenticated()
                                        ?
                                    openBookingDialog():
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        color: AppColor.primaryColor),
                                    child: Icon(
                                      Icons.table_bar_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                    "Book", style: TextStyle(fontSize: 12)),
                              ],
                            ):SizedBox()

                          ],
                      ),
                    ],
                  )
                      .px20().py12()
                      .glassMorphic(
                      opacity: 0.1, blur: 8, circularRadius: 15)
                      .wTwoThird(context),

                  Positioned(
                    top: -40,
                    child: CustomImage(
                      imageUrl: widget.model.vendor!.logo,
                      width: 80,
                      height: 80,
                      canZoom: false,
                    ).cornerRadius(100),
                  ),
                ],
              )
            ],
          ).h(MediaQuery
              .of(context)
              .size
              .height * .37),
          SizedBox(height: 10,),

          widget.isDelivery? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text("Delivery", style: TextStyle(fontSize: 12)),
                  Image.asset("assets/images/delivery.png", width: 40,
                    color: Colors.white,),
                  Text("${widget.model.vendor!.delivery == 1
                      ? "Available"
                      : "Unavailable"}",
                      style: TextStyle(fontSize: 12, color: widget.model.vendor!
                          .delivery == 1 ? Colors.green : Colors.red)),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuPage(model: widget.model,),),);
                },
                child: Column(
                  children: [
                    Image.asset("assets/images/menu.png", width: 40,),
                    SizedBox(height: 5,),
                    Text("Menu",
                        style: TextStyle(fontSize: 12, color:Colors.amber)),
                  ],
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Text("Pickup", style: TextStyle(fontSize: 12)),
                  Image.asset("assets/images/pickup.png", width: 40,),
                  Text("${widget.model.vendor!.pickup == 1
                      ? "Available"
                      : "Unavailable"}",
                      style: TextStyle(fontSize: 12, color: widget.model.vendor!
                          .pickup == 1 ? Colors.green : Colors.red)),
                ],
              ),
            ],
          ).wTwoThird(context):SizedBox(),
          //description
          // "${model.vendor!.name}".text.xl2.bold.make(),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
