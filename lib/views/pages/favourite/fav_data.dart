import 'package:huops/models/vendor.dart';

class FavVendor {
  int id;
  int userId;
  int vendorId;
  DateTime updatedAt;
  DateTime createdAt;
  Vendor vendor;

  FavVendor({
    required this.id,
    required this.userId,
    required this.vendor,
    required this.vendorId,
    required this.updatedAt,
    required this.createdAt,
  });

  factory FavVendor.fromJson(Map<String, dynamic> json) {
    return FavVendor(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      vendorId: json['vendor_id'] as int,
      vendor: Vendor.fromJson(json["vendor"]),
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vendor_id': vendorId,
      "vendor": vendor.toJson(),
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
