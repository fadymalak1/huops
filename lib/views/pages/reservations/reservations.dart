import 'package:flutter/material.dart';
import 'package:huops/view_models/reservation.vm.dart';
import 'package:huops/views/pages/reservations/bag_reservations/bag_reservations.page.dart';
import 'package:huops/views/pages/reservations/table_reservations/table_reservations.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'hotel_reservations/hotel_reservations.page.dart';

class Reservations extends StatelessWidget {
  const Reservations({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReservationViewModel>.reactive(
        viewModelBuilder: () => ReservationViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return DefaultTabController(
            length: 3,
            child: BasePageWithoutNavBar(
              showLeadingAction: true,
                showAppBar: true,
                title: "Reservations",
                elevation: 0,
                body: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Tables'.tr()),
                        Tab(text: 'Bags'.tr()),
                        Tab(text: 'Hotels'.tr()),
                      ],
                    ).glassMorphic(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                    TabBarView(children: [
                      vm.isAuthenticated()
                          ? TableReservations()
                          : EmptyState(
                        auth: true,
                        showAction: true,
                        actionPressed: vm.openLogin,
                      ).py12().centered().expand(),

                      vm.isAuthenticated()
                          ? BagReservations()
                          : EmptyState(
                              auth: true,
                              showAction: true,
                              actionPressed: vm.openLogin,
                            ).py12().centered().expand(),
                      vm.isAuthenticated()
                          ? HotelReservations()
                          : EmptyState(
                        auth: true,
                        showAction: true,
                        actionPressed: vm.openLogin,
                      ).py12().centered().expand(),

                    ]).pOnly(top: Vx.dp20).expand(),
                  ],
                )),
          );
        });
  }
}
