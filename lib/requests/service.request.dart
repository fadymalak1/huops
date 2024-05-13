import 'dart:convert';
import 'dart:developer';

import 'package:huops/constants/api.dart';
import 'package:huops/models/api_response.dart';
import 'package:huops/models/service.dart';
import 'package:huops/services/http.service.dart';
import 'package:huops/services/location.service.dart';

class ServiceRequest extends HttpService {
  //
  Future<List<Service>> getServices({
    Map<String, dynamic>? queryParams,
    int? page = 1,
    bool byLocation = false,
  }) async {
    Map<String, dynamic>? qParams = {
      ...(queryParams != null ? queryParams : {}),
      "page": "$page",
    };

    //
    if (byLocation &&
        LocationService.currenctAddress?.coordinates?.latitude != null) {
      qParams["latitude"] =
          LocationService.currenctAddress?.coordinates?.latitude;
      qParams["longitude"] =
          LocationService.currenctAddress?.coordinates?.longitude;
    }

    final apiResult = await get(
      Api.services,
      queryParameters: qParams,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Service> services = [];
      List<dynamic> serviceJsonList;
      if (page == null || page == 0) {
        serviceJsonList = (apiResponse.body as List);
      } else {
        serviceJsonList = apiResponse.data;
      }

      serviceJsonList.forEach((jsonObject) {
        try {
          services.add(Service.fromJson(jsonObject));
        } catch (error) {
          print("ServiceRequest getServices Error ==> $error");
          print("Service ID ==> ${jsonObject['id']}");
          log("service ==> ${jsonEncode(jsonObject)}");
        }
      });

      return services;
    }

    throw apiResponse.message!;
  }

  //
  Future<Service> serviceDetails(int id) async {
    //
    final apiResult = await get("${Api.services}/$id");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Service.fromJson(apiResponse.body);
    }

    throw apiResponse.message!;
  }
}
