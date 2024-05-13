import 'package:huops/constants/api.dart';
import 'package:huops/models/api_response.dart';
import 'package:huops/models/order_stop.dart';
import 'package:huops/models/package_checkout.dart';
import 'package:huops/models/package_type.dart';
import 'package:huops/services/http.service.dart';

class PackageRequest extends HttpService {
  //
  Future<List<PackageType>> fetchPackageTypes() async {
    final apiResult = await get(Api.packageTypes);
    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return (apiResponse.body as List).map((jsonObject) {
        return PackageType.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message!;
    }
  }

  //
  Future<PackageCheckout> parcelSummary({
    int? vendorId,
    int? packageTypeId,
    String? packageWeight,
    List<OrderStop>? stops,
    String? couponCode,
  }) async {
    //
    final locationStops = stops != null
        ? stops.map((e) => {"id": e.deliveryAddress?.id}).toList()
        : [];

    final params = {
      "ignore_check": true,
      "vendor_id": "${vendorId}",
      "package_type_id": "${packageTypeId}",
      "weight": "${packageWeight}",
      "stops": stops != null ? locationStops : [],
      "coupon_code": couponCode ?? "",
    };

    // print("Params ==> $params");
    //
    final apiResult = await get(
      Api.packageOrderSummary,
      queryParameters: params,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      print("Response ==> ${apiResponse.body}");
      return PackageCheckout.fromJson(apiResponse.body);
    }

    throw apiResponse.message!;
  }
}
