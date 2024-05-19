
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huops/models/service.dart';
import 'package:huops/models/vendor.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:huops/requests/service.request.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:huops/views/pages/auth/login.page.dart';
import 'package:huops/views/pages/vendor_details/reservation_hotel_rooms.dart';
import 'package:huops/views/pages/vendor_details/reservation_storage_bags.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/api.dart';
import '../models/vendor_images.dart';
import '../services/auth.service.dart';

class ServiceVendorDetailsViewModel extends MyBaseViewModel {
  //
  ServiceVendorDetailsViewModel(BuildContext context, {required this.vendor}) {
    this.viewContext = context;
  }

  //
  ServiceRequest _serviceRequest = ServiceRequest();
  final Vendor vendor;
  Map<String, dynamic> ?typeOfStorage;
  List<Service> services = [];
  VendorImages vendorImages = VendorImages();

  final _dio = Dio();



  initialise()async {
    getTypeOfStorageBags(vendor.id);
    getVendorServices();
  }
  getTypeOfStorageBags(vendorId) async {
    setBusy(true);
    _dio.options.headers['Authorization'] ="Bearer ${await AuthServices.getAuthBearerToken()}";
    final response = await _dio.get(Api.baseUrl + "/list/bag/prices/$vendorId",);
    if (response.statusCode == 200) {
      typeOfStorage = response.data;
    }
    setBusy(false);
  }



  StorageBags(vendorId) async {
    if (isAuthenticated()) {
      if (vendorId != null) {
        viewContext.nextPage(ReservationStoragePage(
            vendorId: vendorId, vendor: vendor,));
      }
    }
    else {
      viewContext
          .push((context) => LoginPage());
    }
  }

  hotelReservation(vendorId) async {
    if (isAuthenticated()) {
      if (vendorId != null) {
        viewContext.nextPage(ReservationHotelRooms(vendor: vendor,));
      }
    }
    else {
      viewContext
          .push((context) => LoginPage());
    }
  }


  //
  void getVendorServices() async {

    setBusy(true);
    try {
      services = await _serviceRequest.getServices(
        queryParams: {
          "vendor_id": vendor.id,
        },
        page: 0,
      );
      //
    } catch (error) {
      print("Services error ==> $error");
    }

    //
    setBusy(false);
  }
}
