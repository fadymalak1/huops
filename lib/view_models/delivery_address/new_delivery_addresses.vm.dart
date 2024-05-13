import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/address.dart';
import 'package:huops/models/delivery_address.dart';
import 'package:huops/requests/delivery_address.request.dart';
import 'package:huops/view_models/delivery_address/base_delivery_addresses.vm.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class NewDeliveryAddressesViewModel extends BaseDeliveryAddressesViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  TextEditingController what3wordsTEC = TextEditingController();
  bool isDefault = false;
  DeliveryAddress? deliveryAddress = new DeliveryAddress();

  //
  NewDeliveryAddressesViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  showAddressLocationPicker() async {
    dynamic result = await newPlacePicker();

    if (result is PickResult) {
      PickResult locationResult = result;
      addressTEC.text = locationResult.formattedAddress ?? "";
      deliveryAddress!.address = locationResult.formattedAddress;
      deliveryAddress!.latitude = locationResult.geometry?.location.lat;
      deliveryAddress!.longitude = locationResult.geometry?.location.lng;

      if (locationResult.addressComponents != null &&
          locationResult.addressComponents!.isNotEmpty) {
        //fetch city, state and country from address components
        locationResult.addressComponents!.forEach((addressComponent) {
          if (addressComponent.types.contains("locality")) {
            deliveryAddress!.city = addressComponent.longName;
          }
          if (addressComponent.types.contains("administrative_area_level_1")) {
            deliveryAddress!.state = addressComponent.longName;
          }
          if (addressComponent.types.contains("country")) {
            deliveryAddress!.country = addressComponent.longName;
          }
        });
      } else {
        // From coordinates
        setBusy(true);
        deliveryAddress = await getLocationCityName(deliveryAddress!);
        setBusy(false);
      }
      notifyListeners();
    } else if (result is Address) {
      Address locationResult = result;
      addressTEC.text = locationResult.addressLine ?? "";
      deliveryAddress!.address = locationResult.addressLine;
      deliveryAddress!.latitude = locationResult.coordinates?.latitude;
      deliveryAddress!.longitude = locationResult.coordinates?.longitude;
      deliveryAddress!.city = locationResult.locality;
      deliveryAddress!.state = locationResult.adminArea;
      deliveryAddress!.country = locationResult.countryName;
    }
  }

  //

  void toggleDefault(bool? value) {
    isDefault = value ?? false;
    deliveryAddress!.isDefault = isDefault ? 1 : 0;
    notifyListeners();
  }

  //
  saveNewDeliveryAddress(context) async {
    if (formKey.currentState!.validate()) {
      //
      deliveryAddress!.name = nameTEC.text;
      deliveryAddress!.description = descriptionTEC.text;
      //
      setBusy(true);
      //
      final apiRespose = await deliveryAddressRequest.saveDeliveryAddress(
        deliveryAddress!,
      );

      //
      showDialog(context: context, builder: (context){
        return Center(
          child: Container(
            height: MediaQuery.of(context).size.height * .42,
            width: MediaQuery.of(context).size.width * .7,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xff56516f)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  child: Image.asset("assets/images/done.png"),
                ),
                10.heightBox,
                Text(
                  "New Delivery Address".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.white,inherit: false),
                ),
                10.heightBox,
                Text(
                  apiRespose.message.toString(),
                  style: TextStyle(fontSize: 15,color: Colors.white,inherit: false),
                  textAlign: TextAlign.center,
                ),
                10.heightBox,
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          // side: BorderSide(color: Colors.red),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
                    ),
                    child: Container(
                      width: 60,
                      // padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                      child: Center(child: Text("Ok".tr(),style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
      //
      setBusy(false);
    }
  }

  //
}
