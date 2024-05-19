import 'dart:async';

import 'package:flutter/material.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/models/order.dart';
import 'package:huops/requests/order.request.dart';
import 'package:huops/services/app.service.dart';
import 'package:huops/view_models/payment.view_model.dart';
import 'package:huops/views/pages/order/taxi_order_details.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class OrdersViewModel extends PaymentViewModel {
  //
  OrdersViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  OrderRequest orderRequest = OrderRequest();
  List<Order> orders = [];
  List<Order> ordersCompleted = [];
  //
  int queryPage = 1;
  RefreshController refreshController = RefreshController();
  StreamSubscription? homePageChangeStream;
  StreamSubscription? refreshOrderStream;

  void initialise() async {
    await fetchMyOrders();

    homePageChangeStream = AppService().homePageIndex.stream.listen(
      (index) {
        //
        fetchMyOrders();
      },
    );

    refreshOrderStream = AppService().refreshAssignedOrders.listen((refresh) {
      if (refresh) {
        fetchMyOrders();
      }
    });
  }

  //
  dispose() {
    super.dispose();
    homePageChangeStream?.cancel();
    refreshOrderStream?.cancel();
  }

  //
  fetchMyOrders({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      refreshController.refreshCompleted();
      queryPage = 1;
    } else {
      queryPage++;
    }

    try {
      final mOrders = await orderRequest.getOrders(page: queryPage);
      print("#####THIS IS MY ORDERS########${mOrders[0].status}");
      if (!initialLoading) {
        for(int i = 0 ; i < mOrders.length ; i++){
          if(mOrders[i].status == "cancelled"||mOrders[i].status == "delivered"){
            ordersCompleted.add(mOrders[i]);
            refreshController.loadComplete();

          }else{
            orders.add(mOrders[i]);
            refreshController.loadComplete();

          }
        }
        // orders.addAll(mOrders);
        // refreshController.loadComplete();
      } else {
        ordersCompleted=[];
        orders =[];
        for(int i = 0 ; i < mOrders.length ; i++){
          if(mOrders[i].status == "cancelled"||mOrders[i].status == "delivered"){
            ordersCompleted.add(mOrders[i]);
            refreshController.loadComplete();
          }else{
            orders.add(mOrders[i]);
            refreshController.loadComplete();
          }
        }
        // orders = mOrders;
      }
      clearErrors();
    } catch (error) {
      print("Order Error ==> $error");
      setError(error);
    }

    setBusy(false);
  }

  refreshDataSet() {
    initialise();
  }

  openOrderDetails(Order order) async {
    //
    if (order.taxiOrder != null) {
      await viewContext.push(
        (context) => TaxiOrderDetailPage(order: order),
      );
      return;
    }

    final result = await Navigator.of(viewContext).pushNamed(
      AppRoutes.orderDetailsRoute,
      arguments: order,
    );

    //
    if (result != null && (result is Order || result is bool)) {
      if (result is Order) {
        final orderIndex = orders.indexWhere((e) => e.id == result.id);
        orders[orderIndex] = result;
        notifyListeners();
      } else {
        fetchMyOrders();
      }
    }
  }

  void openLogin() async {
    await Navigator.of(viewContext).pushNamed(AppRoutes.loginRoute);
    notifyListeners();
    fetchMyOrders();
  }
}
