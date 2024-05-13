import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:huops/models/notification.dart';
import 'package:huops/models/vendor_type.dart';
import 'package:huops/requests/vendor_type.request.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/services/notification.service.dart';
import 'package:huops/view_models/base.view_model.dart';

class WelcomeViewModel extends MyBaseViewModel {
  //
  WelcomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  Widget? selectedPage;
  List<VendorType> vendorTypes = [];
  VendorTypeRequest vendorTypeRequest = VendorTypeRequest();
  bool showGrid = true;
  List<NotificationModel> notifications = [];
  int count =0;
  StreamSubscription? authStateSub;

  //
  //
  initialise({bool initial = true}) async {
    //
    preloadDeliveryLocation();
    getNotifications();

    //
    if (refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }

    if (!initial) {
      pageKey = GlobalKey();
      notifyListeners();
    }

    await getVendorTypes();
    listenToAuth();
  }
  void getNotifications() async {
    count = 0;
    notifications = await NotificationService.getNotifications();
    notifications.forEach((element) {
      element.read == false?count++:null;
    });
    notifyListeners();
  }

  listenToAuth() {
    authStateSub = AuthServices.listenToAuthState().listen((event) {
      genKey = GlobalKey();
      notifyListeners();
    });
  }

  getVendorTypes() async {
    setBusy(true);
    try {
      vendorTypes = await vendorTypeRequest.index();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }
}
