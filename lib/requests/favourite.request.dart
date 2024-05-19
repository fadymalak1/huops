import 'dart:convert';
import 'dart:developer';

import 'package:huops/constants/api.dart';
import 'package:huops/models/api_response.dart';
import 'package:huops/models/product.dart';
import 'package:huops/models/user.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/services/http.service.dart';
import 'package:huops/views/pages/favourite/fav_service_data.dart';

class FavouriteRequest extends HttpService {
  //
  Future<List<Product>> favourites() async {
    final apiResult = await get(Api.favourites);
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Product> products = [];
      (apiResponse.body as List).forEach(
        (jsonObject) {
          try {
            products.add(Product.fromJson(jsonObject["product"]));
          } catch (error) {
            print("error: $error");
          }
        },
      );
      return products;
    }

    throw apiResponse.message!;
  }

  //
  Future<ApiResponse> makeFavouriteProduct(int productId) async {
    final apiResult = await post(
      Api.favourites,
      {
        "product_id": productId,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  Future<bool> makeFavouriteService(int serviceId) async {
    User currentUser = await AuthServices.getCurrentUser();

    final apiResult = await post(
      "${Api.favouritesService}/${currentUser.id}/$serviceId",
      {},
      includeHeaders: true
    );
    log(apiResult.toString());
    if(apiResult.statusCode == 200) {
      return true;
    }else {
      return false;
    }
  }

  //
  Future<ApiResponse> removeFavouriteProduct(int productId) async {
    final apiResult = await delete(Api.favourites + "/$productId");
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> removeFavouriteVendor(int vendorId) async {
    User currentUser = await AuthServices.getCurrentUser();

    final apiResult = await delete(Api.favourite + "/user/delete/${currentUser.id}/$vendorId");
    return ApiResponse.fromResponse(apiResult);
  }

  Future<bool> removeFavouriteService(int serviceId) async {
    User currentUser = await AuthServices.getCurrentUser();

    final apiResult = await delete(Api.favourite + "/user/service/delete/${currentUser.id}/$serviceId");
    log(apiResult.toString());
    if(apiResult.statusCode == 200) {
      return false;
    }else {
      return true;
    }
  }

  getFavServiceStatus(int serviceId)async{
    try{
      User currentUser = await AuthServices.getCurrentUser();
      String token=await AuthServices.getAuthBearerToken();

      final response=await get(
          '/favourite/user/services/${currentUser.id}'  , includeHeaders: true
      );

      bool isServiceIdAvailable=false;
      if(response.statusCode==200){
        log("hhhhhhhhhhhhhhhhhhhh"+response.data['data'].toString());

        List<dynamic> dataList = response.data['data'];
        int serviceIdToSearch = serviceId;

        isServiceIdAvailable = dataList.any((data) => data['service_id'] == serviceIdToSearch);
      }
      return isServiceIdAvailable;

    }catch(e){
      print(e);
      return false;
    }
  }
  Future<List<FavService>>getFavService()async{
    try{
      User currentUser = await AuthServices.getCurrentUser();
      String token=await AuthServices.getAuthBearerToken();

      final response=await get(
          '/favourite/user/services/${currentUser.id}'  , includeHeaders: true
      );

      return (response.data['data'] as List).map((e) => FavService.fromJson(e)).toList();


    }catch(e){
      print(e);
      return List<FavService>.empty();
    }
  }


}
