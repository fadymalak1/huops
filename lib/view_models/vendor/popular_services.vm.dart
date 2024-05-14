import 'package:flutter/material.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/service.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/requests/service.request.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:huops/views/pages/service/service_details.page.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/vendor.dart';
import '../../requests/vendor.request.dart';
import '../../views/pages/vendor_details/vendor_details.page.dart';

class PopularServicesViewModel extends MyBaseViewModel {
  //
  ServiceRequest _serviceRequest = ServiceRequest();
  //
  List<Service> services = [];
  List<Vendor> vendors = [];
  VendorRequest vendorRequest = VendorRequest();

  VendorType? vendorType;

  PopularServicesViewModel(BuildContext context, this.vendorType) {
    this.viewContext = context;
  }

  //
  initialise() async {
    setBusy(true);
    getVendors();
    try {
      services = await _serviceRequest.getServices(
        byLocation: AppStrings.enableFatchByLocation,
        queryParams: {
          "vendor_type_id": vendorType?.id,
        },
      );
      clearErrors();
    } catch (error) {
      print("PopularServicesViewModel Error ==> $error");
      setError(error);
    }
    setBusy(false);
  }

  //
  serviceSelected(Service service) {
    viewContext.push(
      (context) => ServiceDetailsPage(service),
    );
  }

  //
  getVendors() async {
    //
    setBusyForObject(vendors, true);
    try {
      vendors = await vendorRequest.nearbyVendorsRequest(
        params: {
          "vendor_type_id": vendorType?.id,
        },
      );
    } catch (error) {
      print("Error ==> $error");
    }
    setBusyForObject(vendors, false);
  }

  //
  openVendorDetails(Vendor vendor) {
    viewContext.push(
          (context) => VendorDetailsPage(
        vendor: vendor,
      ),
    );
  }

}
