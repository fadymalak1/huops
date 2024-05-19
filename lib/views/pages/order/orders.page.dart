import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/services/order.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/orders.vm.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/list_items/order.list_item.dart';
import 'package:huops/widgets/list_items/taxi_order.list_item.dart';
import 'package:huops/widgets/states/empty.state.dart';
import 'package:huops/widgets/states/error.state.dart';
import 'package:huops/widgets/states/order.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with AutomaticKeepAliveClientMixin<OrdersPage>, WidgetsBindingObserver {
  //
  late OrdersViewModel vm;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      vm.fetchMyOrders();
    }
  }


  @override
  Widget build(BuildContext context) {
    vm = OrdersViewModel(context);
    super.build(context);
    return ViewModelBuilder<OrdersViewModel>.reactive(
        viewModelBuilder: () => vm,
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: "Orders".tr().text.xl2.semiBold.color(Colors.white).make(),
                elevation: 0,
                backgroundColor: AppColor.primaryColor,
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Orders'.tr()),
                    Tab(text: 'Orders Completed'.tr()),
                  ],
                ),
              ),
              body: TabBarView(children: [
                vm.isAuthenticated()
                    ? CustomListView(
                  canRefresh: true,
                  canPullUp: true,
                  refreshController: vm.refreshController,
                  onRefresh: vm.fetchMyOrders,
                  onLoading: () => vm.fetchMyOrders(initialLoading: false),
                  isLoading: vm.isBusy,
                  dataSet: vm.orders,
                  hasError: vm.hasError,
                  errorWidget: LoadingError(
                    onrefresh: vm.fetchMyOrders,
                  ),
                  //
                  emptyWidget: EmptyOrder(),
                  itemBuilder: (context, index) {
                    //
                    final order = vm.orders[index];
                    //for taxi tye of order
                    if (order.taxiOrder != null) {
                      return TaxiOrderListItem(
                        order: order,
                        orderPressed: () => vm.openOrderDetails(order),
                      );
                    }
                    return OrderListItem(
                      order: order,
                      orderPressed: () => vm.openOrderDetails(order),
                      onPayPressed: () =>
                          OrderService.openOrderPayment(order, vm),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      UiSpacer.verticalSpace(space: 15),
                )
                    : EmptyState(
                  auth: true,
                  showAction: true,
                  actionPressed: vm.openLogin,
                ).py12().centered().expand(),
                vm.isAuthenticated()?
                CustomListView(
                  // canRefresh: true,
                  // canPullUp: true,
                  refreshController: vm.refreshController,
                  // onRefresh: vm.fetchMyOrders,
                  onLoading: () => vm.fetchMyOrders(initialLoading: false),
                  isLoading: vm.isBusy,
                  dataSet: vm.ordersCompleted,
                  hasError: vm.hasError,
                  errorWidget: LoadingError(
                    onrefresh: vm.fetchMyOrders,
                  ),
                  //
                  emptyWidget: EmptyOrder(),
                  itemBuilder: (context, index) {
                    //
                    final order = vm.ordersCompleted[index];
                    //for taxi tye of order
                    if (order.taxiOrder != null) {
                      return TaxiOrderListItem(
                        order: order,
                        orderPressed: () => vm.openOrderDetails(order),
                      );
                    }
                    return OrderListItem(
                      order: order,
                      orderPressed: () => vm.openOrderDetails(order),
                      onPayPressed: () =>
                          OrderService.openOrderPayment(order, vm),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      UiSpacer.verticalSpace(space: 15),
                )
                    : EmptyState(
                  auth: true,
                  showAction: true,
                  actionPressed: vm.openLogin,
                ).py12().centered().expand()
              ]).pOnly(top: Vx.dp20),
            ),
          );
        });
  }
  @override
  bool get wantKeepAlive => true;
}
