import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/models/menu.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/models/product.dart';
import 'package:huops/models/vendor_images.dart';
import 'package:huops/requests/favourite.request.dart';
import 'package:huops/requests/product.request.dart';
import 'package:huops/requests/vendor.request.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/views/pages/pharmacy/pharmacy_upload_prescription.page.dart';
import 'package:huops/views/pages/vendor_search/vendor_search.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/app_colors.dart';
import 'vendor_details.vm.dart';

class VendorDetailsWithMenuViewModel extends VendorDetailsViewModel {
  //
  VendorDetailsWithMenuViewModel(
    BuildContext context,
    this.vendor, {
    required this.tickerProvider,
  }) : super(context, vendor) {
    this.viewContext = context;
  }

  //
  VendorRequest _vendorRequest = VendorRequest();
  FavouriteRequest favouriteRequest = FavouriteRequest();

  //
  Vendor? vendor;
  TickerProvider? tickerProvider;
  TabController? tabBarController;
  final currencySymbol = AppStrings.currencySymbol;

  ProductRequest _productRequest = ProductRequest();
  RefreshController refreshContoller = RefreshController();
  List<RefreshController> refreshContollers = [];
  List<int> refreshContollerKeys = [];

  VendorImages vendorImages=VendorImages();
  //
  Map<int, List> menuProducts = {};
  Map<int, int> menuProductsQueryPages = {};
  bool isFav=false;

  //

  processRemoveVendor(Vendor? vendor, context) async {
    setBusy(true);
    //
    final apiResponse = await favouriteRequest.removeFavouriteVendor(
      vendor!.id,
    );

    // //remove from list
    // if (apiResponse.allGood) {
    //   isFav=false;
    //   notifyListeners();
    // }

    setBusy(false);

    // CoolAlert.show(
    //   context: viewContext,
    //   type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
    //   title: "Remove Vendor From Favourite".tr(),
    //   text: apiResponse.message,
    //   confirmBtnTextStyle: TextStyle(color: Colors.black),
    // );
  }

  Future<bool> addToFav()async{
    bool result= await _vendorRequest.addToFav(vendor!.id);
    // notifyListeners();
    return result;
  }

  void getVendorDetails() async {
    //
    setBusy(true);
    getFavStatus();
    await getVendorImages();

    try {
      vendor = await _vendorRequest.vendorDetails(
        vendor!.id,
        params: {
          "type": "small",
        },
      );

      print("vendor menus ==> ${vendor!.menus.length}");
      //empty menu
      vendor!.menus.insert(
        0,
        Menu.fromJson(
          {
            "id": 0,
            "name": "All".tr(),
          },
        ),
      );
      updateUiComponents();
      clearErrors();
    } catch (error) {
      setError(error);
      print("error ==> ${error}");
    }
    setBusy(false);
  }

  //
  getFavStatus()async{
    isFav=await _vendorRequest.getFavStatus(vendor!.id);
    notifyListeners();
  }

  getVendorImages() async {
    //
    vendorImages = await _vendorRequest.getVendorImages(vendor!.id);
    notifyListeners();
  }

  updateUiComponents() {
    //
    if (!vendor!.hasSubcategories) {
      tabBarController = TabController(
        length: vendor!.menus.length,
        vsync: tickerProvider!,
      );

      //
      loadMenuProduts();
    } else {
      //nothing to do yet
    }
  }



  void productSelected(Product product) async {
    await Navigator.of(viewContext).pushNamed(
      AppRoutes.product,
      arguments: product,
    );

    //
    notifyListeners();
  }

  //
  void uploadPrescription() {
    //
    viewContext.push(
      (context) => PharmacyUploadPrescription(vendor!),
    );
  }

  RefreshController getRefreshController(int key) {
    int index = refreshContollerKeys.indexOf(key);
    return refreshContollers[index];
  }

  //
  loadMenuProduts() {
    //
    refreshContollers = List.generate(
      vendor!.menus.length,
      (index) => new RefreshController(),
    );
    refreshContollerKeys = List.generate(
      vendor!.menus.length,
      (index) => vendor!.menus[index].id,
    );
    //
    vendor!.menus.forEach((element) {
      loadMoreProducts(element.id);
      menuProductsQueryPages[element.id] = 1;
    });
  }

  //
  loadMoreProducts(int id, {bool initialLoad = true}) async {
    int queryPage = menuProductsQueryPages[id] ?? 1;
    if (initialLoad) {
      queryPage = 1;
      menuProductsQueryPages[id] = queryPage;
      getRefreshController(id).refreshCompleted();
      setBusyForObject(id, true);
    } else {
      menuProductsQueryPages[id] = ++queryPage;
    }

    //load the products by subcategory id
    try {
      final mProducts = await _productRequest.getProdcuts(
        page: queryPage,
        queryParams: {
          "menu_id": id,
          "vendor_id": vendor!.id,
        },
      );

      //
      if (initialLoad) {
        menuProducts[id] = mProducts;
      } else {
        menuProducts[id]!.addAll(mProducts);
      }
    } catch (error) {
      print("load more error ==> $error");
    }

    //
    if (initialLoad) {
      setBusyForObject(id, false);
    } else {
      getRefreshController(id).loadComplete();
    }

    notifyListeners();
  }

  openVendorSearch() {
    viewContext.push(
      (context) => VendorSearchPage(vendor!),
    );
  }
}
