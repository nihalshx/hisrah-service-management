import 'package:flutter/foundation.dart';

import '../../data/models/service_category_model.dart';
import '../../data/repositories/service_category_repository.dart';
import '../../../../core/utils/app_logger.dart';

/// Provider managing the state for the Service Categories feature.
///
/// Exposes loading, error, and list state.
/// All business logic lives here; widgets only call methods.
class ServiceCategoryProvider extends ChangeNotifier {
  ServiceCategoryProvider(this._repository);

  final ServiceCategoryRepository _repository;

  List<ServiceCategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  /// All loaded service categories.
  List<ServiceCategoryModel> get categories =>
      List<ServiceCategoryModel>.unmodifiable(_categories);

  /// True while a network operation is in progress.
  bool get isLoading => _isLoading;

  /// Non-null when the last operation failed.
  String? get error => _error;

  // ── Load ──────────────────────────────────────────────────────────────────

  /// Fetches all categories from the repository.
  Future<void> loadCategories() async {
    _setLoading(true);
    _error = null;
    try {
      _categories = List<ServiceCategoryModel>.from(
        await _repository.fetchAll(),
      );
      appLogger.i('Loaded ${_categories.length} categories');
    } catch (e, st) {
      appLogger.e('loadCategories failed', error: e, stackTrace: st);
      _error = 'Failed to load categories. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  /// Adds [category] to the store. Returns `true` on success.
  Future<bool> addCategory(ServiceCategoryModel category) async {
    try {
      final saved = await _repository.add(category);
      _categories = [..._categories, saved];
      _error = null;
      notifyListeners();
      appLogger.i('Added category: ${saved.id}');
      return true;
    } catch (e, st) {
      appLogger.e('addCategory failed', error: e, stackTrace: st);
      _error = 'Failed to add category. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  /// Updates [category] in the store. Returns `true` on success.
  Future<bool> updateCategory(ServiceCategoryModel category) async {
    try {
      final updated = await _repository.update(category);
      _categories = [
        for (final c in _categories)
          if (c.id == updated.id) updated else c,
      ];
      _error = null;
      notifyListeners();
      appLogger.i('Updated category: ${updated.id}');
      return true;
    } catch (e, st) {
      appLogger.e('updateCategory failed', error: e, stackTrace: st);
      _error = 'Failed to update category. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  /// Deletes the category with [id]. Returns `true` on success.
  Future<bool> deleteCategory(String id) async {
    try {
      await _repository.delete(id);
      _categories = _categories.where((c) => c.id != id).toList();
      _error = null;
      notifyListeners();
      appLogger.i('Deleted category: $id');
      return true;
    } catch (e, st) {
      appLogger.e('deleteCategory failed', error: e, stackTrace: st);
      _error = 'Failed to delete category. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
