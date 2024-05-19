import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glass/glass.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/view_models/reservation.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class HotelReservationDetails extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const HotelReservationDetails({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return ViewModelBuilder<ReservationViewModel>.reactive(
        viewModelBuilder: () => ReservationViewModel(context, reservation: reservation),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePage(
            showAppBar: true,
            showLeadingAction: true,
            title: "Reservation Details",
            elevation: 0,
            isLoading: vm.isBusy,
            backgroundColor: Colors.grey.shade100,
            body: VStack(
              crossAlignment: CrossAxisAlignment.center,
                [
                  Container(
                    padding: EdgeInsets.all(15),
                    color: AppColor.primaryColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Name").text.xl.semiBold.color(Colors.white).make(),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(reservation["vendor_name"]).text.xl.color(AppColor.primaryColor).make(),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("Email").text.xl.semiBold.color(Colors.white).make(),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(reservation["vendor_email"]).text.xl.color(AppColor.primaryColor).make(),
                                Spacer(),
                                InkWell(onTap: (){ vm.sendMail(reservation["vendor_email"]);} , child: Icon(Icons.email,color: Colors.white70,),)
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("Phone").text.xl.semiBold.color(Colors.white).make(),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(reservation["vendor_phone"]).text.xl.color(AppColor.primaryColor).make(),
                                Spacer(),
                                InkWell(onTap: (){ vm.makeCall(reservation["vendor_phone"]);} , child: Icon(Icons.call,color: Colors.white70,),)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              "Check-in".tr().text.xl.white.make(),
                                              5.heightBox,
                                              reservation["reservation_data"]["date"].toString().substring(0, 10).text.xl.white.make(),
                                            ],
                                          ),
                                          Icon(
                                            Icons.date_range,
                                            color: Colors.white,
                                            size: 25,
                                          )
                                        ],
                                      ).expand(),
                                      // SizedBox(width: 10,),
                                      SizedBox(
                                        height: 40,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          width: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // SizedBox(width: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              "Check-out".tr().text.xl.white.make(),
                                              5.heightBox,
                                              "${DateTime.parse(reservation["reservation_data"]["date"]).add(Duration(days: reservation["reservation_data"]["days"])).toString().substring(0, 10)}".text.xl.white.make(),
                                            ],
                                          ),
                                          Icon(
                                            Icons.date_range,
                                            color: Colors.white,
                                            size: 25,
                                          )
                                        ],
                                      ).expand(),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  (reservation["reservation_data"]["details"]==null||reservation["reservation_data"]["details"]=="")?SizedBox():"Details".tr().text.xl.semiBold.white.make(),
                                  (reservation["reservation_data"]["details"]==null||reservation["reservation_data"]["details"]=="")?SizedBox():Text("${reservation["reservation_data"]["details"]}",style: TextStyle(color: Colors.white),).text.lg.semiBold.make().p8().glassMorphic().wFull(context),
                                  15.heightBox,
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          "TotalRooms".text.xl.make(),
                                          SizedBox(height: 5,),
                                          "${reservation["reservation_data"]["rooms"]}".tr().text.xl.make(),
                                        ],
                                      ).p16().glassMorphic().expand(),
                                      5.widthBox,
                                      Column(
                                        children: [
                                          "${reservation["reservation_data"]["single"]}"=="1"?"${reservation["reservation_data"]["single"]} Single Room".tr().text.xl.make().p8().glassMorphic().wFull(context):
                                          "${reservation["reservation_data"]["single"]} Single Rooms".tr().text.xl.make().p8().glassMorphic().wFull(context),
                                          5.heightBox,
                                          "${reservation["reservation_data"]["double"]}"=="1"?"${reservation["reservation_data"]["double"]} Double Room".tr().text.xl.make().p8().glassMorphic().wFull(context):"${reservation["reservation_data"]["double"]} Double Rooms".tr().text.xl.make().p8().glassMorphic().wFull(context),
                                        ],
                                      ).expand(),
                                    ],
                                  ),

                                  20.heightBox,
                                  "Number of Guests: ${reservation["reservation_data"]["count_of_people"]}".tr().text.xl.make().p8().glassMorphic().wFull(context),

                                ]
                            ),
                            SizedBox(height: 20,),
                            Text(
                              reservation["reservation_data"]["status"],
                              style: TextStyle(
                                  color: reservation["reservation_data"]["status"] ==
                                      "Pending"
                                      ? Colors.grey
                                      :reservation["reservation_data"]["status"] == "Accepted"?Colors.green : Colors.red,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      ).asGlass(
                        tintColor: reservation["reservation_data"]["status"] == "Pending"?Colors.grey : reservation["reservation_data"]["status"] == "Accepted"?Colors.green : Colors.red,
                        clipBorderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),

                  reservation["reservation_data"]["status"] == "Cancelled"?SizedBox():reservation["reservation_data"]["status"] == "Rejected"&&reservation["reservation_data"]["reason"]!=null?reservation["reservation_data"]["reason"].toString().text.xl.make().p8().glassMorphic().wFull(context).px20():vm.isBusy?LoadingShimmer():Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomButton(
                      shapeRadius: 12,
                      color: Colors.red,
                      title: "Cancel Reservation",
                      onPressed:vm.cancelHotelReservation,
                    ),
                  ),


                ]
            ),
          );
        },
    );
  }
}
