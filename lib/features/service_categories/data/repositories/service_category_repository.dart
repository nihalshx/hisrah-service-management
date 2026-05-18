import 'dart:math';

import '../models/service_category_model.dart';

/// Mock repository for [ServiceCategoryModel].
///
/// Simulates async network calls with artificial delays.
/// Replace with Dio-based implementation for production.
class ServiceCategoryRepository {
  static final List<ServiceCategoryModel> _store = [
    const ServiceCategoryModel(
      id: '1',
      categoryName: 'Hair Care',
      categoryNameArb: 'العناية بالشعر',
      displayName: 'Hair Care Services',
      shortDescription: 'All hair-related treatments and styling.',
      categoryFor: 'All',
    ),
    const ServiceCategoryModel(
      id: '2',
      categoryName: 'Skin Care',
      categoryNameArb: 'العناية بالبشرة',
      displayName: 'Skin & Face Treatments',
      shortDescription: 'Facial and skin care procedures.',
      categoryFor: 'Female',
    ),
    const ServiceCategoryModel(
      id: '3',
      categoryName: 'Massage',
      categoryNameArb: 'تدليك',
      displayName: 'Massage Therapy',
      shortDescription: 'Relaxation and therapeutic massages.',
      categoryFor: 'All',
    ),
    const ServiceCategoryModel(
      id: '4',
      categoryName: 'Nail Care',
      categoryNameArb: 'العناية بالأظافر',
      displayName: 'Nail Art & Manicure',
      shortDescription: 'Manicure, pedicure, and nail art.',
      categoryFor: 'Female',
    ),
    const ServiceCategoryModel(
      id: '5',
      categoryName: 'Barbering',
      categoryNameArb: 'الحلاقة',
      displayName: 'Barber Services',
      shortDescription: "Men's cuts, shaves, and grooming.",
      categoryFor: 'Male',
    ),
  ];

  /// Fetches all categories with a simulated network delay.
  Future<List<ServiceCategoryModel>> fetchAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return List<ServiceCategoryModel>.unmodifiable(_store);
  }

  /// Creates a new category and returns the persisted model.
  Future<ServiceCategoryModel> add(ServiceCategoryModel category) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final saved = category.copyWith(
      id: (1000 + Random().nextInt(8999)).toString(),
    );
    _store.add(saved);
    return saved;
  }

  /// Updates an existing category by [ServiceCategoryModel.id].
  Future<ServiceCategoryModel> update(ServiceCategoryModel category) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final index = _store.indexWhere((c) => c.id == category.id);
    if (index == -1) throw Exception('Category not found: ${category.id}');
    _store[index] = category;
    return category;
  }

  /// Deletes the category with the given [id].
  Future<void> delete(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _store.removeWhere((c) => c.id == id);
  }
}
