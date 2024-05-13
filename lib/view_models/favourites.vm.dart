import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/models/product.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/requests/favourite.request.dart';
import 'package:huops/requests/vendor.request.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:huops/views/pages/favourite/fav_data.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/app_colors.dart';

class FavouritesViewModel extends MyBaseViewModel {
  //
  FavouriteRequest favouriteRequest = FavouriteRequest();
  List<Product> products = [];
  List<FavVendor> vendors = [];
  final _vendorRequest = VendorRequest();

  //
  FavouritesViewModel(BuildContext context) {
    this.viewContext = context;
  }

  getFavVendors() async{
    setBusyForObject(vendors, true);
    try {
      vendors=await _vendorRequest.getFavVendors();
      log(vendors.toString());
      clearErrors();
    } catch (error) {
      setError(error);
      log(error.toString());
    }

    setBusyForObject(vendors, false);

  }

  void initialise() {
    getFavVendors();
    fetchProducts();
  }

  //
  fetchProducts() async {
    //
    setBusyForObject(products, true);
    try {
      products = await favouriteRequest.favourites();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(products, false);
  }

  vendorSelected(Vendor vendor) async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    );
  }
  //
  removeFavourite(Product product, context) {


    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            height: MediaQuery.of(context).size.height * .42,
            width: MediaQuery.of(context).size.width * .7,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xff56516f).withOpacity(.9),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  child: Image.asset(
                    "assets/images/warning.png",
                  ),
                ),
                10.heightBox,
                Text(
                  "Remove Product From Favourite".tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            // side: BorderSide(color: Colors.red),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Container(
                        width: 60,
                        // padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                        child: Center(
                            child: Text(
                          "Cancel".tr(),
                          style: TextStyle(color: Colors.black),
                        )),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        viewContext.pop();
                        processRemove(product, context);
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColor.primaryColor),
                      ),
                      child: Container(
                        width: 60,
                        // padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                        child: Center(
                            child: Text(
                          "Remove".tr(),
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
              // .glassMorphic(opacity: 0.3,borderRadius: BorderRadius.circular(20)),
              );
        });
  }
  removeFavouriteVendor(Vendor vendor, context) {

    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            height: MediaQuery.of(context).size.height * .42,
            width: MediaQuery.of(context).size.width * .7,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xff56516f).withOpacity(.9),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  child: Image.asset(
                    "assets/images/warning.png",
                  ),
                ),
                10.heightBox,
                Text(
                  "Remove Vendor From Favourite".tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),

                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            // side: BorderSide(color: Colors.red),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Container(
                        width: 60,
                        // padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                        child: Center(
                            child: Text(
                          "Cancel".tr(),
                          style: TextStyle(color: Colors.black),
                        )),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        viewContext.pop();
                        processRemoveVendor(vendor, context);
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColor.primaryColor),
                      ),
                      child: Container(
                        width: 60,
                        // padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                        child: Center(
                            child: Text(
                          "Remove".tr(),
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
              );
        });
  }

  //
  processRemove(Product product, context) async {
    setBusy(true);
    //
    final apiResponse = await favouriteRequest.removeFavourite(
      product.id,
    );

    //remove from list
    if (apiResponse.allGood) {
      products.remove(product);
    }

    setBusy(false);

    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Remove Product From Favourite".tr(),
      text: apiResponse.message,
      confirmBtnTextStyle: TextStyle(color: Colors.black),
    );
  }
  processRemoveVendor(Vendor vendor, context) async {
    setBusy(true);
    //
    final apiResponse = await favouriteRequest.removeFavouriteVendor(
      vendor.id,
    );

    //remove from list
    if (apiResponse.allGood) {
      vendors.remove(vendor);
      notifyListeners();
      reloadPage();
    }

    setBusy(false);

    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Remove Vendor From Favourite".tr(),
      text: apiResponse.message,
      confirmBtnTextStyle: TextStyle(color: Colors.black),
    );
  }

  openProductDetails(Product product) {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.product,
      arguments: product,
    );
  }
}
