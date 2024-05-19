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

class HotelReservations extends StatefulWidget {
  const HotelReservations({super.key});

  @override
  _HotelReservationsState createState() => _HotelReservationsState();
}

class _HotelReservationsState extends State<HotelReservations>   with AutomaticKeepAliveClientMixin<HotelReservations>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ViewModelBuilder<ReservationViewModel>.reactive(
      viewModelBuilder: () => ReservationViewModel(context),
      onViewModelReady: (vm) => vm.getHotelReservations(),
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
                    onRefresh: vm.getHotelReservations,
                    isLoading: vm.isBusy,
                    onLoading: () => vm.getHotelReservations(initialLoading: false),
                    dataSet: vm.reservations,
                    hasError: vm.hasError,
                    errorWidget: LoadingError(
                      onrefresh: vm.getHotelReservations,
                    ),
                    emptyWidget: EmptyOrder(title: "No Reservations",description: "When you make a reservation, they will appear here",),
                    separatorBuilder: (context, index) =>
                        UiSpacer.verticalSpace(space: 8),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          vm.goToHotelReservationDetails(vm.reservations[index]);
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
                    MaterialIcons.hotel,
                    color: AppColor.primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    reservation["vendor_name"],
                    style: TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,
                  ).expand(),
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
                // Row(children: [
                //   Icon(
                //     Icons.access_time_rounded,
                //     color: AppColor.primaryColor,
                //   ),
                //   SizedBox(
                //     width: 5,
                //   ),
                //   Text(
                //     reservation['reservation_data']["time"],
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                // ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(
                        Icons.groups,
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
                        Icons.bedroom_child_outlined,
                        color: AppColor.primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        reservation['reservation_data']["rooms"]
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
            flex: 2,
            child: Text(
              reservation["reservation_data"]["status"],
              style: TextStyle(
                  color: reservation["reservation_data"]["status"] ==
                      "Accepted"
                      ? Colors.green
                      :reservation["reservation_data"]["status"] == "Rejected" ? Colors.red:reservation["reservation_data"]["status"] == "Pending"?Colors.amber:Colors.grey,
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
