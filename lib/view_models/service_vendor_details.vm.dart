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
  // String date=DateTime.now().toString().substring(0,10);
  // final int nTotalCount = 20;
  // final int nInitValue = 1;
  // int nCurrentValue = 1;
  // String selectedTypeOfStorage = "large";
  // TextEditingController descriptionTEC = TextEditingController();
  //
  //
  // // List<File>? bagsStorageImages;
  // List<File> bagsStorageImages = [File('')];

  // selectImage(parentContext,index) {
  //   return showDialog(
  //       context: parentContext,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: Center(child: Text("select image".tr(),style: TextStyle(fontWeight: FontWeight.bold),)),
  //           children: <Widget>[
  //             SimpleDialogOption(
  //                 onPressed: ()async {
  //                   viewContext.pop();
  //                   PickedFile? file =
  //                   (await ImagePicker.platform.pickImage(source: ImageSource.gallery,imageQuality: 25));
  //                   bagsStorageImages[index] = File(file!.path);
  //                   bagsStorageImages.length < 3 ? bagsStorageImages.add(File("")) : null;
  //                   notifyListeners();
  //                 },
  //                 child: Center(child: Text("Image from gallery".tr(),style: TextStyle(fontWeight: FontWeight.bold),))),
  //             SimpleDialogOption(
  //               onPressed: ()async{
  //                 viewContext.pop();
  //                 PickedFile? file = (await ImagePicker.platform.pickImage(
  //                   source: ImageSource.camera,
  //                   imageQuality: 25,
  //                   maxHeight: 675,
  //                   maxWidth: 960,
  //                 ));
  //                 bagsStorageImages[index] = File(file!.path);
  //                 bagsStorageImages.length < 6 ? bagsStorageImages.add(File("")) : null;
  //                 notifyListeners();
  //               },
  //               child: Center(child: Text("Image from camera".tr(),style: TextStyle(fontWeight: FontWeight.bold),)),
  //             ),
  //             SimpleDialogOption(
  //               child: Center(
  //                   child: Container(
  //                       width: MediaQuery.of(context).size.width * .5,
  //                       padding: const EdgeInsets.all(8),
  //                       margin: const EdgeInsets.all(8),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(15),
  //                         color: Theme.of(context).primaryColor,
  //                       ),
  //                       child: const Text(
  //                         "رجوع",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                         ),
  //                       ))),
  //               onPressed: () => viewContext.pop(),
  //             )
  //           ],
  //         );
  //       });
  // }

  StorageBags(vendorId)async{
    if(vendorId != null){
      final response = await _dio.get(Api.baseUrl+"/list/bag/prices/$vendorId");
      print("########${response.statusCode}");

      if (response.statusCode == 200) {
        Map<String, dynamic> typeOfStorage = response.data;
        print("########${response.data}");
        viewContext.nextPage(ReservationStoragePage(typeOfStorage: typeOfStorage, vendorId: vendorId));
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



// Dialog(
// backgroundColor: Colors.transparent,
// child: SizedBox(
// width: MediaQuery.of(context).size.width,
// height: MediaQuery.of(context).size.height/2,
// child: Padding(
// padding: const EdgeInsets.all(12.0),
// child: SingleChildScrollView(
// physics: const BouncingScrollPhysics(),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// //date
// "Start Storage:".tr().text.xl.white.make(),
// 10.heightBox,
// Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// color: Colors.black,
// ),
// child: Row(
// children: [
// Expanded(
// flex: 1,
// child: Icon(
// Icons.date_range,
// color: AppColor.primaryColor,
// size: 30,
// )),
// Expanded(
// flex: 3,
// child: ScrollWheelDatePicker(
// onSelectedItemChanged: (value) {
// setState(() {
// date = value.toString().substring(0,10);
// });
// },
// theme: CurveDatePickerTheme(
// monthFormat: MonthFormat.threeLetters,
// wheelPickerHeight: 50.0,
// overlay: ScrollWheelDatePickerOverlay.highlight,
// itemTextStyle: defaultItemTextStyle.copyWith(
// color: AppColor.primaryColor),
// overlayColor: Colors.transparent,
// overAndUnderCenterOpacity: 0.5,
// itemExtent: 50.0,
// diameterRatio: 1.0,
// )),
// ),
// ],
// ),
// ),
// SizedBox(height: 20,),
// //days
// "Number of days:".tr().text.xl.white.make(),
// 10.heightBox,
// Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// color: Colors.black,
// ),
// child: Row(
// children: [
// Expanded(
// flex: 1,
// child: Container(
// height: 30,width: 30,
// child: Image.asset("assets/icons/days.png",color: AppColor.primaryColor,),
// )),
// Expanded(
// flex: 3,
// child: WheelSlider.number(
//
// interval: 1, // this field is used to show decimal/double values
// perspective: 0.01,
// totalCount: nTotalCount,
// initValue: nInitValue,
// unSelectedNumberStyle:  TextStyle(
// fontSize: 18.0,
//
// color: AppColor.primaryColor.withOpacity(0.4),
// ),
// selectedNumberStyle: TextStyle(
// fontSize: 19.0,
// fontWeight: FontWeight.bold,
// color: AppColor.primaryColor,
// ),
//
// currentIndex: nCurrentValue,
// onValueChanged: (val) {
// setState(() {
// nCurrentValue = val;
// });
// },
// // hapticFeedbackType: HapticFeedbackType.heavyImpact,
// ),
// ),
// ],
// ),
// ),
// //
// 10.heightBox,
// "Size of bag:".tr().text.xl.white.make(),
// Container(
// padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// decoration: BoxDecoration(
// color: Colors.black,
// borderRadius: BorderRadius.circular(18),
// ),
// child: DropdownButtonFormField<dynamic>(
// autovalidateMode: AutovalidateMode.always,
// elevation: 9,
// value: selectedTypeOfStorage,
// decoration: const InputDecoration(
// border: InputBorder.none,
// ),
// isExpanded: true,
// items: ['large', 'medium', 'small']
//     .map((label) => DropdownMenuItem(
// value: label,
// child: Align(
// alignment: const Alignment(.5, 1),
// child: SizedBox(
// width: MediaQuery.of(context).size.width * .8,
// child: Text(
// label.toString(),
// textAlign: TextAlign.start,
// )))))
//     .toList(),
// // dropdownColor: Colors.white,
// onChanged: (value) {
// setState(() {
// selectedTypeOfStorage = value;
// });
// },
// ),
// ),
// 10.heightBox,
// //
// "Description:".tr().text.xl.white.make(),
// CustomTextFormField(
// textEditingController: descriptionTEC,
// underline: false,
// // hintText: "Description".tr(),
// maxLines: 3,
// ).color(Colors.black).cornerRadius(15),
// //images
// 10.heightBox,
// "Image Of Bag:".tr().text.xl.white.make(),
// // bagsStorageImages[0].path.isEmpty ?
// Container(
// padding: EdgeInsets.all(10),
// decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppColor.primaryColor),
// child: "AddImage".text.white.make(),
// ).onTap(() {
// selectImage(context, 0);
// notifyListeners();
// print("###########${bagsStorageImages}");
// }) ,
// 10.heightBox,
// Row(
// children: [
// Container(
// height: 70,
// width: 70,
// decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),image: DecorationImage(
// image: FileImage(
// bagsStorageImages[0],
// ),
// fit: BoxFit.fill,
// )),
// child: Text(" "),
// )
// ],
// ),
// // confirm storage bags
// SizedBox(height: 30,),
// CustomButton(
// onPressed: () async {
// SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// String? userId = sharedPreferences.getString('user_id');
// //.post(urlOfStoreCallHistory, data: {"call_to": userId,},
// final response = await _dio.post(
// Api.baseUrl+"/user/bag/reservation/$userId/$vendorId",
// data: {
// "date": date,
// "days": nCurrentValue,
// "big_size": selectedTypeOfStorage,
// "price": selectedTypeOfStorage == "large" ? typeOfStorage['large']
//     :selectedTypeOfStorage == "medium" ?  typeOfStorage['medium']
//     :typeOfStorage['small'] ,
// }
// );
// print("########${response.statusCode}");
//
// if (response.statusCode == 200) {
// Map<String, dynamic> typeOfStorage = response.data;
// print("##Done######${response.data}");
// viewContext.pop();
// Toast.show(
// "Storage Bag Done".tr(),
// context);
// }else{
// print("##EROOR### in storage bags###${response.statusCode}");
// Toast.show(
// "Storage Bag Failed".tr(),
// context);
// }
//
// },
// color: AppColor.primaryColor,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10),
// ),
// title: "Storage you bag".tr(),
// ),
//
// ]),
// ),
// ),
// ).glassMorphic(circularRadius: 20,),
// );