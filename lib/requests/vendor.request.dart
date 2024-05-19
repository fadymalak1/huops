import 'dart:convert';
import 'dart:developer';

import 'package:huops/constants/api.dart';
import 'package:huops/models/api_response.dart';
import 'package:huops/models/order_stop.dart';
import 'package:huops/models/review.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/models/vendor_images.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/services/http.service.dart';
import 'package:huops/services/location.service.dart';
import 'package:http/http.dart' as http;
import 'package:huops/views/pages/favourite/fav_vendor_data.dart';

import '../models/user.dart';

class VendorRequest extends HttpService {
  //
  Future<List<Vendor>> vendorsRequest({
    int page = 1,
    bool byLocation = true,
    Map? params,
  }) async {
    Map<String, dynamic> queryParameters = {
      ...(params != null ? params : {}),
      "page": "$page",
    };
    //
    if (byLocation && LocationService.cLat != null) {
      queryParameters["latitude"] =
          LocationService.currenctAddress?.coordinates?.latitude;
      queryParameters["longitude"] =
          LocationService.currenctAddress?.coordinates?.longitude;
    }
    //
    final apiResult = await get(
      Api.vendors,
      queryParameters: queryParameters,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendors = [];
      apiResponse.data.forEach(
        (jsonObject) {
          try {
            vendors.add(Vendor.fromJson(jsonObject));
          } catch (error) {
            print("===============================");
            print("Fetching Vendor error ==> $error");
            print("Vendor Id ==> ${jsonObject['id']}");
            print("===============================");
          }
        },
      );
      return vendors;
    }

    throw apiResponse.message!;
  }

  //

  Future<VendorImages>getVendorImages(int vendorId)async{
    String token=await AuthServices.getAuthBearerToken();
    log(vendorId.toString());
    final response=await http.get(
      Uri.parse('http://huopsapp.it/api/panorama/images/$vendorId'),
    );
    log(response.body.toString());
    return VendorImages.fromJson(jsonDecode(response.body));
  }


  Future<List<FavVendor>>getFavVendors()async{
    User currentUser = await AuthServices.getCurrentUser();
    String token=await AuthServices.getAuthBearerToken();

    final response=await http.get(
      Uri.parse('http://huopsapp.it/api/favourite/user/${currentUser.id}'),   headers: {
    "Authorization": "Bearer $token"
      }
    );

      log(response.body.toString());
      return (jsonDecode(response.body)['data'] as List).map((e) => FavVendor.fromJson(e)).toList();
  }

  getFavStatus(int vendorId)async{
    try{
      User currentUser = await AuthServices.getCurrentUser();
      String token=await AuthServices.getAuthBearerToken();

      final response=await http.get(
        Uri.parse('http://huopsapp.it/api/favourite/user/${currentUser.id}')  ,   headers: {
        "Authorization": "Bearer $token"
        }
      );

      bool isVendorIdAvailable=false;

      if(response.statusCode==200){
        log(jsonDecode(response.body)['data'].toString());
        List<dynamic> dataList = jsonDecode(response.body)['data'];
        int vendorIdToSearch = vendorId;

        isVendorIdAvailable = dataList.any((data) => data['vendor_id'] == vendorIdToSearch);
      }
      return isVendorIdAvailable;

    }catch(e){
      print(e);
      return false;
    }
  }
  Future<bool> makeBookTable(int? vendorId, String? date, String? time, int? cont,int? countTable) async {
    Map<String, dynamic> map = Map<String, dynamic>();

    try{
      String token=await AuthServices.getAuthBearerToken();

      User currentUser = await AuthServices.getCurrentUser();
      map["date"] = "${date}";
      map["time"] = "${time}";
      map["count_of_people"] = "${cont}";
      map["tables"] = "${countTable}";
      final response=await http.post(
        Uri.parse('http://huopsapp.it/api/user/reservation/$vendorId/${currentUser.id}'),body: map,   headers: {
        "Authorization": "Bearer $token"
        }
      );


      return true;
    }catch(e){
      print(e);
      return false;
    }

  }

  Future<bool> addToFav(int vendorId)async{
    try{
      User currentUser = await AuthServices.getCurrentUser();
      String token=await AuthServices.getAuthBearerToken();

      final response=await http.post(
        Uri.parse('http://huopsapp.it/api/favourite/vendor/${currentUser.id}/$vendorId')  ,   headers: {
        "Authorization": "Bearer $token"
        }
      );

      return true;
    }catch(e){
      print(e);
      return false;
    }
  }
  Future<List<Vendor>> topVendorsRequest({
    int page = 1,
    bool byLocation = false,
    Map? params,
  }) async {
    final apiResult = await get(
      Api.vendors,
      queryParameters: {
        ...(params != null ? params : {}),
        "page": "$page",
        "latitude": byLocation ? LocationService.getFetchByLocationLat() : null,
        "longitude":
            byLocation ? LocationService.getFetchByLocationLng() : null,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendors = [];
      vendors = apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
      return vendors;
    }

    throw apiResponse.message!;
  }

  Future<List<Vendor>> nearbyVendorsRequest({
    int page = 1,
    bool byLocation = false,
    Map? params,
  }) async {
    final apiResult = await get(
      Api.vendors,
      queryParameters: {
        ...(params != null ? params : {}),
        "page": "$page",
        "latitude": byLocation ? LocationService.getFetchByLocationLat() : null,
        "longitude":
            byLocation ? LocationService.getFetchByLocationLng() : null,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message!;
  }

  Future<Vendor> vendorDetails(
    int id, {
    Map<String, String>? params,
  }) async {
    //
    final apiResult = await get(
      "${Api.vendors}/$id",
      queryParameters: params,
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      log(apiResult.data.toString());
      return Vendor.fromJson(apiResponse.body);
    }

    throw apiResponse.message!;
  }

  Future<List<Vendor>> fetchParcelVendors({
    required int packageTypeId,
    int? vendorTypeId,
    required List<OrderStop> stops,
  }) async {
    final apiResult = await post(
      Api.packageVendors,
      {
        "vendor_type_id": vendorTypeId,
        "package_type_id": "$packageTypeId",
        "locations": stops.map(
          (stop) {
            return {
              "lat": stop.deliveryAddress?.latitude,
              "long": stop.deliveryAddress?.longitude,
              "city": stop.deliveryAddress?.city,
              "state": stop.deliveryAddress?.state,
              "country": stop.deliveryAddress?.country,
            };
          },
        ).toList(),
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendors = (apiResponse.body['vendors'] as List)
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
      return vendors;
    }

    throw apiResponse.message!;
  }

  //
  Future<ApiResponse> rateVendor({
    required int rating,
    required String review,
    required int orderId,
    required int vendorId,
  }) async {
    //
    final apiResult = await post(
      Api.rating,
      {
        "order_id": orderId,
        "vendor_id": vendorId,
        "rating": rating,
        "review": review,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> rateDriver({
    required int rating,
    required String review,
    required int orderId,
    required int driverId,
  }) async {
    //
    final apiResult = await post(
      Api.rating,
      {
        "order_id": orderId,
        "driver_id": driverId,
        "rating": rating,
        "review": review,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<List<Review>> getReviews({
    int? page,
    int? vendorId,
  }) async {
    final apiResult = await get(
      Api.vendorReviews,
      queryParameters: {
        "vendor_id": vendorId,
        "page": "$page",
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Review> reviews = apiResponse.data.map(
        (jsonObject) {
          return Review.fromJson(jsonObject);
        },
      ).toList();

      return reviews;
    }

    throw apiResponse.message!;
  }
}
