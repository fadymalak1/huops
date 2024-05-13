import 'package:huops/constants/api.dart';
import 'package:huops/models/api_response.dart';
import 'package:huops/models/flash_sale.dart';
import 'package:huops/models/product.dart';
import 'package:huops/services/http.service.dart';
import 'package:huops/services/location.service.dart';

class FlashSaleRequest extends HttpService {
  Future<List<FlashSale>> getFlashSales({
    Map<String, dynamic>? queryParams,
  }) async {
    Map<String, dynamic> params = {
      ...(queryParams != null ? queryParams : {}),
      //add lat and lng
      "latitude": LocationService.getFetchByLocationLat(),
      "longitude": LocationService.getFetchByLocationLng(),
    };

    final apiResult = await get(
      Api.flashSales,
      queryParameters: params,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List)
          .map((jsonObject) => FlashSale.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message!;
  }

  //
  Future<List<Product>> getProdcuts({
    Map<String, dynamic>? queryParams,
    int page = 1,
  }) async {
    Map<String, dynamic> params = {
      ...(queryParams != null ? queryParams : {}),
      "page": "$page",
      //add lat and lng
      "latitude": LocationService.getFetchByLocationLat(),
      "longitude": LocationService.getFetchByLocationLng(),
    };

    final apiResult = await get(
      Api.flashSales,
      queryParameters: params,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return List<Product>.from(
        ((apiResponse.body is List) ? apiResponse.body : apiResponse.data).map(
          (jsonObject) {
            return Product.fromJson(jsonObject["item"]);
          },
        ),
      );
    }

    throw apiResponse.message!;
  }
}
