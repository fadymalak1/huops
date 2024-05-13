import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/vendor_details.vm.dart';
import 'package:huops/views/pages/search/main_search.page.dart';
import 'package:huops/views/pages/vendor_details/service_vendor_details.page.dart';
import 'package:huops/views/pages/vendor_details/widgets/upload_prescription.btn.dart';
import 'package:huops/views/pages/vendor_details/widgets/vendor_details_header.view.dart';
import 'package:huops/views/pages/vendor_details/widgets/vendor_with_subcategory.view.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_leading.dart';
import 'package:huops/widgets/buttons/share.btn.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/cart_page_action.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../../../constants/app_ui_sizes.dart';
import '../../../../widgets/busy_indicator.dart';
import '../../../../widgets/custom_grid_view.dart';
import '../../../../widgets/custom_list_view.dart';
import '../../../../widgets/list_items/category.list_item.dart';
import '../vendor_category_products.page.dart';

class VendorPlainDetailsView extends StatefulWidget {
  const VendorPlainDetailsView(this.model, {Key? key}) : super(key: key);
  final VendorDetailsViewModel model;

  @override
  State<VendorPlainDetailsView> createState() => _VendorPlainDetailsViewState();
}

class _VendorPlainDetailsViewState extends State<VendorPlainDetailsView> {

  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      showAppBar: false,
      showLeadingAction: false,
      showCart: false,
      elevation: 0,
      extendBodyBehindAppBar: true,
      appBarColor: Colors.transparent,
      backgroundColor: context.theme.colorScheme.background,
      appBarItemColor: Colors.white,
      fab: UploadPrescriptionFab(widget.model),
      actions: [
        SizedBox(
          width: 50,
          height: 50,
          child: FittedBox(
            child: ShareButton(
              model: widget.model,
            ),
          ),
        ),
        UiSpacer.hSpace(10),
      ],
      body: VStack(
        [
//           //subcategories && hide for service vendor type
//           CustomVisibilty(
//             visible: (widget.model.vendor!.hasSubcategories &&
//                 !widget.model.vendor!.isServiceType),
//             child: VendorDetailsWithSubcategoryPage(
//               vendor: widget.model.vendor!,
//             ),
//           ),

          //show for service vendor type
          CustomVisibilty(
            visible: widget.model.vendor!.isServiceType,
            child: ServiceVendorDetailsPage(
              widget.model,
              vendor: widget.model.vendor!,
            ),
          ),
        ],
      ),
    );
  }
}
