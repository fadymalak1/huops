import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:huops/constants/api.dart';
import 'package:huops/models/user.dart';
import 'package:huops/services/app.service.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/views/pages/reservations/bag_reservations/reservation_details.dart';
import 'package:huops/views/pages/reservations/table_reservations/reservation_details.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../views/pages/reservations/hotel_reservations/reservation_details.dart';
import 'base.view_model.dart';

class ReservationViewModel extends MyBaseViewModel {
  Map<String, dynamic>? reservation;

  ReservationViewModel(BuildContext context, {Map<String, dynamic>? reservation}) {
    this.viewContext = context;
    this.reservation = reservation;
  }

  List<String> status = ["All", "Pending", "Accepted", "Rejected", "Cancelled"];
  List<String> changeStatus = [ "Accepted", "Rejected"];
  String selectedStatus = "All";

  //
  RefreshController refreshController = RefreshController();
  StreamSubscription? refreshReservationStream;

  @override
  void initialise() async {
    // TODO: implement initialise
    refreshReservationStream = AppService().refreshReservations.listen((refresh) {
      if (refresh) {
        // getTableReservations();
      }
    });
    // await getTableReservations();
    super.initialise();
  }
  dispose() {
    super.dispose();
    refreshReservationStream?.cancel();
  }

  List<Map<String, dynamic>> reservations = [];
/////////////////////// reservation api ////////////////////////
  getTableReservations({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      refreshController.refreshCompleted();
    }
    setBusy(true);
    reservations.clear();
    User currentUser = await AuthServices.getCurrentUser();

    final response =  await http.get(
            Uri.parse(
                "${Api.baseUrl + Api.getUserReservations}/${currentUser.id}"),
            headers: {
                "Authorization": "Bearer ${AuthServices.getAuthBearerToken()}"
              });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      jsonResponse['reservations'].forEach((element) {
        reservations.add(element);
      });
      // Sort the reservations based on the "created_at" field in descending order
      reservations.sort((a, b) => DateTime.parse(b["reservation_data"]["created_at"])
          .compareTo(DateTime.parse(a["reservation_data"]["created_at"])));

      log(reservations.toString());
    }

    setBusy(false);
  }
  getBagReservations({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      refreshController.refreshCompleted();
    }
    setBusy(true);
    reservations.clear();
    User currentUser = await AuthServices.getCurrentUser();

    final response =  await http.get(
            Uri.parse(
                "${Api.baseUrl + Api.getUserBagReservations}/${currentUser.id}"),
            headers: {
                "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
              });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      jsonResponse['reservations'].forEach((element) {
        reservations.add(element);
      });
      // Sort the reservations based on the "created_at" field in descending order
      reservations.sort((a, b) => DateTime.parse(b["reservation_data"]["created_at"])
          .compareTo(DateTime.parse(a["reservation_data"]["created_at"])));

      log(reservations.toString());
    }

    setBusy(false);
  }
  getHotelReservations({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      refreshController.refreshCompleted();
    }
    setBusy(true);
    reservations.clear();
    User currentUser = await AuthServices.getCurrentUser();

    final response =  await http.get(
            Uri.parse(
                "${Api.baseUrl + Api.getUserHotelReservations}/${currentUser.id}"),
            headers: {
                "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
              });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      jsonResponse['reservations'].forEach((element) {
        reservations.add(element);
      });
      // Sort the reservations based on the "created_at" field in descending order
      reservations.sort((a, b) => DateTime.parse(b["reservation_data"]["created_at"])
          .compareTo(DateTime.parse(a["reservation_data"]["created_at"])));

      log(reservations.toString());
    }

    setBusy(false);
  }
////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////
  makeCall(String phoneNumber) async {
    String url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);

    } else {
      viewContext.showToast(msg: "Could not launch $url");
      // throw 'Could not launch $url';
    }
  }
  sendMail(String email)async{
    String url = "mailto:$email";
    if (await canLaunch(url)) {
      launch(url);
    }else{
      viewContext.showToast(msg: "Could not launch $url");
      // throw 'Could not launch $url';
    }
  }
//////////////////////////////////////////////////////////////////


  ///////////////////////////// go to pages //////////////////////////
  goToTableReservationDetails(Map<String, dynamic> reservation) async {
    Navigator.push(viewContext, MaterialPageRoute(builder: (context) => TableReservationDetails(reservation: reservation,)));
  }
  goToHotelReservationDetails(Map<String, dynamic> reservation) async {
    Navigator.push(viewContext, MaterialPageRoute(builder: (context) => HotelReservationDetails(reservation: reservation,)));
  }
  goToBagReservationDetails(Map<String, dynamic> reservation) async {
    Navigator.push(viewContext, MaterialPageRoute(builder: (context) => BagReservationDetails(reservation: reservation,)));
  }
  ////////////////////////////////////////////////////////////////////

  void statusChanged(value) async {
    selectedStatus = value;
    await getTableReservations();
    notifyListeners();
  }

  cancelTableReservation()async{
    try{
      setBusy(true);
      log(reservation!['reservation_data']["id"].toString());
      final response = await http.post(Uri.parse("${Api.baseUrl +"/my/reservation"}/${reservation!['reservation_data']['id']}"),headers: {
        "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
      }).then((value) {
        log("rrrrrrrrrrrrrrrrrrrrrrrrrrrr"+value.body.toString());
        viewContext.showToast(msg: "Reservation Cancelled",bgColor: Colors.green);
      });
      Navigator.pop(viewContext);
    }catch(e){
      log("error"+e.toString());
      viewContext.showToast(msg: e.toString(),bgColor: Colors.red);
    }
    setBusy(false);
  }
  cancelBagReservation()async{
    try{
      setBusy(true);
      log(reservation!['reservation_data']["id"].toString());
      final response = await http.post(Uri.parse("${Api.baseUrl +"/my/bags/reservation"}/${reservation!['reservation_data']['id']}"),headers: {
        "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
      }).then((value) {
        log(value.body);
        viewContext.showToast(msg: "Reservation Cancelled",bgColor: Colors.green);
      });
      Navigator.pop(viewContext);
    }catch(e){
      viewContext.showToast(msg: e.toString(),bgColor: Colors.red);
    }
    setBusy(false);
  }
  cancelHotelReservation()async{
    try{
      setBusy(true);
      log(reservation!['reservation_data']["id"].toString());
      final response = await http.post(Uri.parse("${Api.baseUrl +"/my/hotel/reservation"}/${reservation!['reservation_data']['id']}"),headers: {
        "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
      }).then((value) {
        log(value.body);
        viewContext.showToast(msg: "Reservation Cancelled",bgColor: Colors.green);
      });
      Navigator.pop(viewContext);
    }catch(e){
      viewContext.showToast(msg: e.toString(),bgColor: Colors.red);
    }
    setBusy(false);
  }

}
