import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/reservation.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/states/error.state.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:huops/widgets/states/order.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class TableReservations extends StatefulWidget {
  const TableReservations({super.key});

  @override
  _TableReservationsState createState() => _TableReservationsState();
}

class _TableReservationsState extends State<TableReservations>   with AutomaticKeepAliveClientMixin<TableReservations>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ViewModelBuilder<ReservationViewModel>.reactive(
      viewModelBuilder: () => ReservationViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          title: "Table Reservations".tr(),
          showAppBar: false,
          elevation: 3,
          showLeadingAction: true,
          body: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CustomListView(
                    canRefresh: true,
                    canPullUp: true,
                    refreshController: vm.refreshController,
                    onRefresh: vm.getTableReservations,
                    isLoading: vm.isBusy,
                    onLoading: () => vm.getTableReservations(initialLoading: false),
                    dataSet: vm.reservations,
                    hasError: vm.hasError,
                    errorWidget: LoadingError(
                      onrefresh: vm.getTableReservations,
                    ),
                    emptyWidget: EmptyOrder(title: "No Reservations",description: "When you make a reservation, they will appear here",),
                    separatorBuilder: (context, index) =>
                        UiSpacer.verticalSpace(space: 8),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          vm.goToReservationDetails(vm.reservations[index]);
                        },
                        child: ReservationCard(
                            vm,
                            vm.reservations[index],
                        ),
                      );
                    },
                  ).expand(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

Widget ReservationCard(
    ReservationViewModel vm, Map<String, dynamic> reservation) {
  return Card(
    color: Colors.transparent,
    elevation: 0,
    child: vm.isBusy
        ? LoadingShimmer()
        : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(
                    CupertinoIcons.profile_circled,
                    color: AppColor.primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    reservation["vendor_name"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ]),
                Row(children: [
                  Icon(
                    Icons.date_range,
                    color: AppColor.primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    reservation['reservation_data']["date"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ]),
                Row(children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: AppColor.primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    reservation['reservation_data']["time"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(
                        Icons.people_alt_outlined,
                        color: AppColor.primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        reservation['reservation_data']["count_of_people"]
                            .toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
                    SizedBox(width: 20,),
                    Row(children: [
                      Icon(
                        Icons.table_bar,
                        color: AppColor.primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        reservation['reservation_data']["tables"]
                            .toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              reservation["reservation_data"]["status"],
              style: TextStyle(
                  color: reservation["reservation_data"]["status"] ==
                      "Accepted"
                      ? Colors.green
                      :reservation["reservation_data"]["status"] == "Rejected" ? Colors.red:Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ).glassMorphic(),
  );
}
