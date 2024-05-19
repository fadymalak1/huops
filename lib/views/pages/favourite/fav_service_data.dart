import 'package:huops/models/service.dart';
import 'package:huops/models/vendor.dart';

class FavService {
  int id;
  int userId;
  int serviceId;
  DateTime updatedAt;
  DateTime createdAt;
  Service service;

  FavService({
    required this.id,
    required this.userId,
    required this.service,
    required this.serviceId,
    required this.updatedAt,
    required this.createdAt,
  });

  factory FavService.fromJson(Map<String, dynamic> json) {
    return FavService(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      serviceId: json['service_id'] as int,
      service: Service.fromJson(json["service"]),
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      "service": service.toJson(),
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
