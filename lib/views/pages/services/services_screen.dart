import 'package:flutter/material.dart';
import 'package:huops/services/navigation.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/welcome.vm.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/list_items/vendor_type.list_item.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key, required this.vm});

  final WelcomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      showAppBar: true,
      showLeadingAction: true,
      title: "Services",
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomListView(
          noScrollPhysics: false,
          dataSet: vm.vendorTypes,
          isLoading: vm.isBusy,
          loadingWidget: LoadingShimmer().px20(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final vendorType = vm.vendorTypes[index];
            return VendorTypeListItem(
              vendorType,
              onPressed: () {
                NavigationService.pageSelected(vendorType, context: context);
              },
            );
          },
          separatorBuilder: (context, index) => UiSpacer.emptySpace(),
        ),
      ),
    );
  }
}
