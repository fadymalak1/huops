import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/models/delivery_address.dart';
import 'package:huops/requests/delivery_address.request.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';

class DeliveryAddressesViewModel extends MyBaseViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  List<DeliveryAddress> deliveryAddresses = [];

  //
  DeliveryAddressesViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  void initialise() {
    //
    fetchDeliveryAddresses();
  }

  //
  fetchDeliveryAddresses() async {
    //
    setBusyForObject(deliveryAddresses, true);
    try {
      deliveryAddresses = await deliveryAddressRequest.getDeliveryAddresses();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(deliveryAddresses, false);
  }

  //
  newDeliveryAddressPressed() async {
    await Navigator.of(viewContext).pushNamed(
      AppRoutes.newDeliveryAddressesRoute,
    );
    fetchDeliveryAddresses();
  }

  //
  editDeliveryAddress(DeliveryAddress deliveryAddress) async {
    await Navigator.of(viewContext).pushNamed(
      AppRoutes.editDeliveryAddressesRoute,
      arguments: deliveryAddress,
    );
    fetchDeliveryAddresses();
  }

  //
  deleteDeliveryAddress(DeliveryAddress deliveryAddress,context) {
    //
    // CoolAlert.show(
    //     context: viewContext,
    //     type: CoolAlertType.confirm,
    //     title: "Delete Delivery Address".tr(),
    //     text: "Are you sure you want to delete this delivery address?".tr(),
    //     confirmBtnText: "Delete".tr(),
    //     onConfirmBtnTap: () {
    //       viewContext.pop();
    //       processDeliveryAddressDeletion(deliveryAddress);
    //     });
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
                      "Delete Delivery Address".tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    10.heightBox,
                    Text(
                      "Are you sure you want to delete this delivery address?".tr(),
                      style: TextStyle(fontSize: 15, color: Colors.white),
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
                            processDeliveryAddressDeletion(deliveryAddress);
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

  //
  processDeliveryAddressDeletion(DeliveryAddress deliveryAddress) async {
    setBusy(true);
    //
    final apiResponse = await deliveryAddressRequest.deleteDeliveryAddress(
      deliveryAddress,
    );

    //remove from list
    if (apiResponse.allGood) {
      deliveryAddresses.remove(deliveryAddress);
    }

    setBusy(false);

    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Delete Delivery Address".tr(),
      confirmBtnTextStyle: TextStyle(color: Colors.black),
      text: apiResponse.message,
    );
  }
}
