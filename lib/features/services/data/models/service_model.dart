import 'package:flutter/foundation.dart';

/// Commission type for a service.
enum CommissionType {
  percentage,
  amount;

  String get label {
    switch (this) {
      case CommissionType.percentage:
        return 'Percentage';
      case CommissionType.amount:
        return 'Amount';
    }
  }
}

/// Immutable data model representing a single service.
@immutable
class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.categoryId,
    required this.serviceName,
    this.serviceNameArb = '',
    required this.baseRate,
    this.shortDescription = '',
    this.shortDescriptionArb = '',
    required this.duration,
    this.displayOrder = 0,
    this.commissionType = CommissionType.percentage,
    this.commissionValue = 0.0,
    this.allowAtCustomerLocation = false,
    this.branch = '',
  });

  final String id;
  final String categoryId;

  /// English service name (required).
  final String serviceName;

  /// Arabic service name — RTL.
  final String serviceNameArb;

  /// Base rate in SAR (required).
  final double baseRate;

  final String shortDescription;
  final String shortDescriptionArb;

  /// Duration in minutes (required).
  final int duration;

  final int displayOrder;
  final CommissionType commissionType;
  final double commissionValue;
  final bool allowAtCustomerLocation;
  final String branch;

  ServiceModel copyWith({
    String? id,
    String? categoryId,
    String? serviceName,
    String? serviceNameArb,
    double? baseRate,
    String? shortDescription,
    String? shortDescriptionArb,
    int? duration,
    int? displayOrder,
    CommissionType? commissionType,
    double? commissionValue,
    bool? allowAtCustomerLocation,
    String? branch,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      serviceName: serviceName ?? this.serviceName,
      serviceNameArb: serviceNameArb ?? this.serviceNameArb,
      baseRate: baseRate ?? this.baseRate,
      shortDescription: shortDescription ?? this.shortDescription,
      shortDescriptionArb: shortDescriptionArb ?? this.shortDescriptionArb,
      duration: duration ?? this.duration,
      displayOrder: displayOrder ?? this.displayOrder,
      commissionType: commissionType ?? this.commissionType,
      commissionValue: commissionValue ?? this.commissionValue,
      allowAtCustomerLocation:
          allowAtCustomerLocation ?? this.allowAtCustomerLocation,
      branch: branch ?? this.branch,
    );
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      serviceName: json['serviceName'] as String,
      serviceNameArb: json['serviceNameArb'] as String? ?? '',
      baseRate: (json['baseRate'] as num).toDouble(),
      shortDescription: json['shortDescription'] as String? ?? '',
      shortDescriptionArb: json['shortDescriptionArb'] as String? ?? '',
      duration: json['duration'] as int,
      displayOrder: json['displayOrder'] as int? ?? 0,
      commissionType: CommissionType.values.byName(
        json['commissionType'] as String? ?? 'percentage',
      ),
      commissionValue:
          (json['commissionValue'] as num?)?.toDouble() ?? 0.0,
      allowAtCustomerLocation:
          json['allowAtCustomerLocation'] as bool? ?? false,
      branch: json['branch'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'serviceName': serviceName,
        'serviceNameArb': serviceNameArb,
        'baseRate': baseRate,
        'shortDescription': shortDescription,
        'shortDescriptionArb': shortDescriptionArb,
        'duration': duration,
        'displayOrder': displayOrder,
        'commissionType': commissionType.name,
        'commissionValue': commissionValue,
        'allowAtCustomerLocation': allowAtCustomerLocation,
        'branch': branch,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
