import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:double_back_to_close/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/api.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../../models/notification.dart' as notificationModel;


class ReservationHotelRoomsDetails extends StatefulWidget {
  const ReservationHotelRoomsDetails({super.key,required this.rooms,required this.single,required this.double,required this.date,required this.days,required this.count_of_people,required this.details,required this.vendor});
  final String rooms;
  final String single;
  final String double;
  final DateTime date;
  final String days;
  final String count_of_people;
  final String details;
  final Vendor vendor;

  @override
  State<ReservationHotelRoomsDetails> createState() => _ReservationHotelRoomsDetailsState();
}

class _ReservationHotelRoomsDetailsState extends State<ReservationHotelRoomsDetails> {
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      title: "Reservation Hotel Rooms",
      showAppBar: true,
      showLeadingAction: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Check-In"),
                      Text(widget.date.toString().substring(0, 10)),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.date_range_rounded),
                ],
              ).expand(),
              SizedBox(
                height: 40,
                child: VerticalDivider(
                  thickness: 1,
                  width: 20,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Check-Out"),
                      Text("${widget.date.add(Duration(days: int.parse(widget.days))).toString().substring(0, 10)}"),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.date_range_rounded),
                ],
              ).expand(),
            ]
          ),
          widget.details.isEmpty? SizedBox():20.heightBox,
          widget.details.isEmpty? SizedBox():Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Details".tr().text.xl2.make(),
              5.heightBox,
              widget.details.text.align(TextAlign.justify).make().p8().glassMorphic(),
            ],
          ),
          20.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  "TotalRooms".text.xl.make(),
                  SizedBox(height: 5,),
                  "${widget.rooms}".tr().text.xl.make(),
                ],
              ).p16().glassMorphic().expand(),
              5.widthBox,
              Column(
                children: [
                  widget.single=="1"?"${widget.single} Single Room".tr().text.xl.make().p8().glassMorphic().wFull(context):
                  "${widget.single} Single Rooms".tr().text.xl.make().p8().glassMorphic().wFull(context),
                  5.heightBox,
                  widget.double=="1"?"${widget.double} Double Room".tr().text.xl.make().p8().glassMorphic().wFull(context):"${widget.double} Double Rooms".tr().text.xl.make().p8().glassMorphic().wFull(context),
                ],
              ).expand(),
            ],
          ),

          20.heightBox,
          "Number of Guests: ${widget.count_of_people}".tr().text.xl.make().p8().color(Colors.green).glassMorphic(),
          30.heightBox,
          CustomButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
              String? userId = sharedPreferences.getString('user_id');
              String urlOfRoomReservation = Api.baseUrl +
                  "/user/hotel/reservation/${widget.vendor.id}/$userId";
              var request = http.MultipartRequest(
                  'POST', Uri.parse(urlOfRoomReservation));
              Map<String, String> headers = {
                "Authorization":
                "Bearer ${await AuthServices.getAuthBearerToken()}",
                "Accept": "multipart/form-data",
                "Content-type": "multipart/form-data",
              };

              request.fields['rooms'] = widget.rooms;
              request.fields['single'] = widget.single;
              request.fields['double'] = widget.double;
              request.fields['date'] = widget.date.toString().substring(0, 10);
              request.fields['days'] = widget.days;
              request.fields['count_of_people'] = widget.count_of_people;
              request.fields['details'] = widget.details;
              request.fields['count_of_people'] = widget.count_of_people;

              request.headers.addAll(headers);
              request.fields.addAll({});

              var res = await request.send().timeout(
                const Duration(seconds: 90),
              );
              final respStr = await res.stream.bytesToString();

              // var result = jsonDecode(respStr)['data'];
              if (res.statusCode == 200) {
                Navigator.pop(context);
                Navigator.pop(context);
                Toast.show("Room Reservation Service Done".tr(), context);

                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: Random().nextInt(100),
                    channelKey: 'basic_channel',
                    title: 'Houps',
                    body: 'Successful Hotel Reservation',
                  ),
                );
                notificationModel.NotificationModel newNotification =
                notificationModel.NotificationModel(
                  title: "Houps",
                  body: "Successful Hotel Reservation",
                  index: 0,
                );
                // RemoteMessage notificationRemote ;
                // notificationRemote = RemoteMessage();
                // NotificationService.addNotification(newNotification);
                // FirebaseService().saveNewNotification(
                //   null,
                //   title: "Houps",
                //   body: "Successful storage Bag",
                // );
              } else {
                print("##EROOR### in room reservation ###${res.statusCode}");
                Toast.show("Room Reservation Failed".tr(), context);
              }
              setState(() {
                _isLoading = false;
              });
            },
            color: AppColor.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: "Confirm".tr(),
          ).wFull(context),


        ],
      ).p20(),
    );
  }
}
