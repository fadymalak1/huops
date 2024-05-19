import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glass/glass.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/view_models/reservation.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class TableReservationDetails extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const TableReservationDetails({super.key, required this.reservation});

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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                          children: [
                                            Icon(Icons.date_range_rounded,size: 50,color: AppColor.primaryColor,),
                                            SizedBox(height: 10,),
                                            Text(reservation["reservation_data"]["date"]).text.xl2.semiBold.color(Colors.white).make(),
                                          ]
                                      ),
                                      SizedBox(width: 20,),
                                      Column(
                                          children: [
                                            Icon(Icons.access_time,size: 50,color: AppColor.primaryColor,),
                                            SizedBox(height: 10,),
                                            Text(reservation["reservation_data"]["time"]).text.xl2.semiBold.color(Colors.white).make(),
                                          ]
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                          children: [
                                            Icon(Icons.table_bar,size: 50,color: AppColor.primaryColor,),
                                            SizedBox(height: 10,),
                                            Text(reservation["reservation_data"]["tables"].toString()).text.xl2.semiBold.color(Colors.white).make(),
                                          ]
                                      ),
                                      SizedBox(width: 20,),
                                      Column(
                                          children: [
                                            Icon(CupertinoIcons.person_3_fill,size: 50,color: AppColor.primaryColor,),
                                            SizedBox(height: 10,),
                                            Text(reservation["reservation_data"]["count_of_people"].toString()).text.xl2.semiBold.color(Colors.white).make(),
                                          ]
                                      ),

                                    ],
                                  ),
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
                      onPressed:vm.cancelTableReservation,
                    ),
                  ),



                ]
            ),
          );
        },
    );
  }
}
