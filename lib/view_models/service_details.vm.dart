import 'dart:developer';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/models/service.dart';
import 'package:huops/models/service_option.dart';
import 'package:huops/models/service_option_group.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/requests/favourite.request.dart';
import 'package:huops/requests/service.request.dart';
import 'package:huops/requests/vendor.request.dart';
import 'package:huops/services/alert.service.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:huops/views/pages/auth/login.page.dart';
import 'package:huops/views/pages/service/service_booking_summary.page.dart';
import 'package:huops/widgets/bottomsheets/age_restriction.bottomsheet.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:huops/constants/app_strings.dart';

class ServiceDetailsViewModel extends MyBaseViewModel {
  //
  ServiceDetailsViewModel(BuildContext context, this.service) {
    this.viewContext = context;
  }

  //
  ServiceRequest serviceRequest = ServiceRequest();
  Service service;
  List<ServiceOption> selectedOptions = [];
  List<int> selectedOptionsIDs = [];
  double subTotal = 0.0;
  double total = 0.0;
  final currencySymbol = AppStrings.currencySymbol;


  //
  updatedSelectedQty(int qty) async {
    service.selectedQty = qty;
    calculateTotal();
  }
  //
  calculateTotal() {
    //
    double? productPrice =
    !service.showDiscount ? service.price : service.discountPrice;

    //

    total = productPrice! * double.parse(service.selectedQty.toString()) ;
    notifyListeners();
  }

  void getServiceDetails() async {
    //
    setBusyForObject(service, true);
    await getFavStatus();
    try {
      final oldProductHeroTag = service.heroTag;
      service = await serviceRequest.serviceDetails(service.id);
      service.heroTag = oldProductHeroTag;

      //
      total = service.price;
      service.selectedQty = 1;
      notifyListeners();

      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(service, false);
  }

  //
  void openVendorPage() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.vendorDetails,
      arguments: service.vendor,
    );
  }

  //
  isOptionSelected(ServiceOption option) {
    return selectedOptionsIDs.contains(option.id);
  }

  //
  toggleOptionSelection(ServiceOptionGroup optionGroup, ServiceOption option) {
    //
    if (selectedOptionsIDs.contains(option.id)) {
      selectedOptionsIDs.remove(option.id);
      selectedOptions.remove(option);
    } else {
      //if it allows only one selection
      if (optionGroup.multiple == 0) {
        //
        final foundOption = selectedOptions.firstOrNullWhere(
          (option) => option.serviceOptionGroupId == optionGroup.id,
        );
        selectedOptionsIDs.remove(foundOption?.id);
        selectedOptions.remove(foundOption);
      }

      selectedOptionsIDs.add(option.id);
      selectedOptions.add(option);
    }

    //
    notifyListeners();
  }

  bookService() async {
    //if has options, and no option is selected but there is option group with required option
    if (service.optionGroups != null &&
        service.optionGroups!.isNotEmpty &&
        selectedOptions.isEmpty &&
        service.optionGroups!.any((optionGroup) => optionGroup.required == 1)) {
      AlertService.warning(
        title: "Aditional Option".tr(),
        text: "Please select an additional option".tr(),
      );
      return;
    }
    //check for age restriction
    if (service.ageRestricted) {
      bool? ageVerified = await showModalBottomSheet(
        context: viewContext,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return AgeRestrictionBottomSheet();
        },
      );
      //
      if (ageVerified == null || !ageVerified) {
        return;
      }
    }

    if (!AuthServices.authenticated()) {
      final result = await viewContext.push(
        (context) => LoginPage(),
      );
      //
      if (result == null || !(result is bool)) {
        return;
      }
    }

    //
    service.selectedOptions = selectedOptions;
    viewContext.push(
      (context) => ServiceBookingSummaryPage(service),
    );
  }

  bool isFav=false;
  FavouriteRequest favouriteRequest = FavouriteRequest();

  addToFav()async{
    log(service.id.toString());
    log("isFav before: $isFav");
    isFav=await favouriteRequest.makeFavouriteService(service.id);
    log("isFav added: $isFav");
  }

  processRemoveService(context) async {
    //
    isFav = await favouriteRequest.removeFavouriteService(service.id);
    log("isFav removed: $isFav");
    notifyListeners();
  }

  //
  getFavStatus()async{
    isFav=await favouriteRequest.getFavServiceStatus(service.id);
    log("status: $isFav");
    notifyListeners();
  }
}
