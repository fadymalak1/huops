import 'package:huops/constants/api.dart';
import 'package:huops/models/api_response.dart';
import 'package:huops/models/product.dart';
import 'package:huops/models/user.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/services/http.service.dart';

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
  Future<ApiResponse> makeFavourite(int id) async {
    final apiResult = await post(
      Api.favourites,
      {
        "product_id": id,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> removeFavourite(int productId) async {
    final apiResult = await delete(Api.favourites + "/$productId");
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> removeFavouriteVendor(int vendorId) async {
    User currentUser = await AuthServices.getCurrentUser();

    final apiResult = await delete(Api.favourite + "/user/delete/${currentUser.id}/$vendorId");
    return ApiResponse.fromResponse(apiResult);
  }
}
