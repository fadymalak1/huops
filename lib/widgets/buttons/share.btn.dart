import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/product_details.vm.dart';
import 'package:huops/view_models/service_details.vm.dart';
import 'package:huops/view_models/vendor_details.vm.dart';
import 'package:huops/widgets/buttons/custom_outline_button.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    this.model,
    Key? key,
  }) : super(key: key);

  final dynamic model;

  @override
  Widget build(BuildContext context) {
    return
      // model.busy((model is ProductDetailsViewModel)
      //   ? model.shareProduct
      //   : (model is VendorDetailsViewModel)
      //   ? model.shareVendor
      //   : model.shareService)?CircularProgressIndicator():
    CustomOutlineButton(
      color: Colors.transparent,
      child: Icon(
        // FlutterIcons.share_fea,
        AntDesign.sharealt,
        color: Colors.white,
        size: 26,
      ),
      onPressed: () {
        if (model is ProductDetailsViewModel) {
          model.shareProduct(model.product);
        } else if (model is VendorDetailsViewModel) {
          model.shareVendor(model.vendor);
        } else if (model is ServiceDetailsViewModel) {
          model.shareService(model.service);
        }
      },
    ).p2().box.roundedFull.make();
  }
}
