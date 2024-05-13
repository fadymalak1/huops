import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:glass_kit/glass_kit.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/requests/vendor.request.dart';
import 'package:huops/views/pages/vendor_details/vendor_details.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';

class QRcodePage extends StatefulWidget {
  const QRcodePage({Key? key}) : super(key: key);

  @override
  _QRcodePageState createState() => _QRcodePageState();
}

class _QRcodePageState extends State<QRcodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  int? req = 0;
  VendorRequest vr = VendorRequest();
  Vendor? selectedVendor = null;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: AppColor.primaryColorDark,
      body: Stack(
        children: <Widget>[
          Container(
            //flex: 5,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: QRView(
              overlay: QrScannerOverlayShape(
                  borderColor: AppColor.primaryColor,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: scanArea),
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: (result != null)
                ? CircularProgressIndicator()
                : GlassContainer.clearGlass(
                        borderRadius: BorderRadius.circular(10),
                        borderColor: AppColor.primaryColorDark.withOpacity(.8),
                        blur: 7.5,
                        height: 35,
                        width: MediaQuery.of(context).size.width,
                        child: 'Scan QR code to open the menu'
                            .tr()
                            .text
                            .color(Colors.white)
                            .bold
                            .make()
                            .centered()
                        //.expand()
                        )
                    .box
                    .color(Colors.transparent)
                    .height(35)
                    .make()
                    .py8().px(20)
                    .color(Colors.transparent),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.resumeCamera();
    log("Hello");

    this.controller = controller;
    this.controller?.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      if (result == null) {
        setState(() {
          result = scanData;

          log(result!.code.toString());
          req = int.parse(result!.code.toString());
          debugPrint("${req}");
        });

        if (req != 0) {
          vr.vendorDetails(
            req ?? 0,
            params: {
              "type": "small",
            },
          ).then((value) => {
                setState(() {
                  if (value != null) {
                    log("message");
                    selectedVendor = value;
                    // LocalStorageService.prefs?.setInt("vendor_id", value.id);
                    // LocalStorageService.prefs
                    //     ?.setInt("table_id", req?.tableId ?? 0);
                    // LocalStorageService.prefs
                    //     ?.setInt("table_number", req?.tableNumber ?? 0);

                    Navigator.of(context).pushNamed(
                      AppRoutes.vendorDetails,
                      arguments: selectedVendor,
                    );

                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => VendorDetailsPage(
                    //           vendor: value,
                    //         )));
                    result = null;
                    req = 0;
                  }
                }),

              });
        }
      }
    });
  }

  @override
  void dispose() {

    this.controller?.pauseCamera();
    controller?.dispose();
    super.dispose();
  }
}
