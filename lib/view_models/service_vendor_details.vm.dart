import 'dart:io';

import 'package:dio/dio.dart';
import 'package:double_back_to_close/toast.dart';
import 'package:flutter/material.dart';
import 'package:huops/models/service.dart';
import 'package:huops/models/vendor.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:huops/requests/service.request.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:huops/views/pages/vendor_details/reservation_storage_bags.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../constants/api.dart';
import '../constants/app_colors.dart';
import '../models/vendor_images.dart';
import '../services/auth.service.dart';
import '../widgets/buttons/custom_button.dart';

class ServiceVendorDetailsViewModel extends MyBaseViewModel {
  //
  ServiceVendorDetailsViewModel(BuildContext context, this.vendor) {
    this.viewContext = context;
  }

  //
  ServiceRequest _serviceRequest = ServiceRequest();
  Vendor? vendor;

  List<Service> services = [];
  VendorImages vendorImages = VendorImages();

  final _dio = Dio();

  StorageBags(vendorId) async {

    if (vendorId != null) {
      _dio.options.headers['Authorization'] ="Bearer ${await AuthServices.getAuthBearerToken()}";
    // .body["token"];
      final response =
          await _dio.get(Api.baseUrl + "/list/bag/prices/$vendorId",);
      print("########${response.statusCode}");
      print("########${response.data}");
      print("########${await AuthServices.getAuthBearerToken()}");

      if (response.statusCode == 200) {
        Map<String, dynamic> typeOfStorage = response.data;
        print("########${response.data}");
        viewContext.nextPage(ReservationStoragePage(
            typeOfStorage: typeOfStorage, vendorId: vendorId));
      } else {
        print("Error of get price list ");
      }
    }
  }

  //
  void getVendorServices() async {
    //
    setBusy(true);
    try {
      services = await _serviceRequest.getServices(
        queryParams: {
          "vendor_id": vendor?.id,
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
