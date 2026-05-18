import 'package:flutter/foundation.dart';

/// Immutable data model representing a single service category.
@immutable
class ServiceCategoryModel {
  const ServiceCategoryModel({
    required this.id,
    required this.categoryName,
    required this.categoryNameArb,
    this.displayName = '',
    this.shortDescription = '',
    this.categoryFor = 'All',
  });

  final String id;

  /// English category name (required).
  final String categoryName;

  /// Arabic category name — RTL (required).
  final String categoryNameArb;

  final String displayName;
  final String shortDescription;

  /// Target audience: "All" | "Male" | "Female".
  final String categoryFor;

  /// Returns a copy with the provided fields replaced.
  ServiceCategoryModel copyWith({
    String? id,
    String? categoryName,
    String? categoryNameArb,
    String? displayName,
    String? shortDescription,
    String? categoryFor,
  }) {
    return ServiceCategoryModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      categoryNameArb: categoryNameArb ?? this.categoryNameArb,
      displayName: displayName ?? this.displayName,
      shortDescription: shortDescription ?? this.shortDescription,
      categoryFor: categoryFor ?? this.categoryFor,
    );
  }

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id'] as String,
      categoryName: json['categoryName'] as String,
      categoryNameArb: json['categoryNameArb'] as String,
      displayName: json['displayName'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      categoryFor: json['categoryFor'] as String? ?? 'All',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryName': categoryName,
        'categoryNameArb': categoryNameArb,
        'displayName': displayName,
        'shortDescription': shortDescription,
        'categoryFor': categoryFor,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceCategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
