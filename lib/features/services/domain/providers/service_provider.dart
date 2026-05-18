import 'package:flutter/foundation.dart';

import '../../data/models/service_model.dart';
import '../../data/repositories/service_repository.dart';
import '../../../../core/utils/app_logger.dart';

/// Provider managing state for the Services feature.
///
/// Supports CRUD operations, client-side filtering, and filter bar visibility.
class ServiceProvider extends ChangeNotifier {
  ServiceProvider(this._repository);

  final ServiceRepository _repository;

  List<ServiceModel> _all = [];
  List<ServiceModel> _filtered = [];
  bool _isLoading = false;
  String? _error;
  bool _showFilterBar = true;

  // Filter state
  String _filterCategory = '';
  String _filterServiceName = '';

  /// The current filtered list of services to display.
  List<ServiceModel> get services =>
      List<ServiceModel>.unmodifiable(_filtered);

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get showFilterBar => _showFilterBar;
  String get filterCategory => _filterCategory;
  String get filterServiceName => _filterServiceName;
  bool get hasActiveFilter =>
      _filterCategory.isNotEmpty || _filterServiceName.isNotEmpty;

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadServices() async {
    _setLoading(true);
    _error = null;
    try {
      _all = List<ServiceModel>.from(await _repository.fetchAll());
      _applyFilter();
      appLogger.i('Loaded ${_all.length} services');
    } catch (e, st) {
      appLogger.e('loadServices failed', error: e, stackTrace: st);
      _error = 'Failed to load services. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  // ── Filter Bar ────────────────────────────────────────────────────────────

  /// Toggles the filter bar visibility.
  void toggleFilterBar() {
    _showFilterBar = !_showFilterBar;
    notifyListeners();
  }

  /// Applies the filter with the given [categoryName] and [serviceName] text.
  ///
  /// [categoryNames] is a map of categoryId → categoryName used for lookup.
  void applyFilter({
    required String categoryName,
    required String serviceName,
    Map<String, String> categoryNames = const {},
  }) {
    _filterCategory = categoryName;
    _filterServiceName = serviceName;
    _applyFilterWithMap(categoryNames);
    notifyListeners();
  }

  /// Clears all active filters.
  void clearFilter() {
    _filterCategory = '';
    _filterServiceName = '';
    _applyFilter();
    notifyListeners();
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  Future<bool> addService(ServiceModel service) async {
    try {
      final saved = await _repository.add(service);
      _all = [..._all, saved];
      _applyFilter();
      _error = null;
      notifyListeners();
      appLogger.i('Added service: ${saved.id}');
      return true;
    } catch (e, st) {
      appLogger.e('addService failed', error: e, stackTrace: st);
      _error = 'Failed to add service. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateService(ServiceModel service) async {
    try {
      final updated = await _repository.update(service);
      _all = [
        for (final s in _all)
          if (s.id == updated.id) updated else s,
      ];
      _applyFilter();
      _error = null;
      notifyListeners();
      appLogger.i('Updated service: ${updated.id}');
      return true;
    } catch (e, st) {
      appLogger.e('updateService failed', error: e, stackTrace: st);
      _error = 'Failed to update service. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteService(String id) async {
    try {
      await _repository.delete(id);
      _all = _all.where((s) => s.id != id).toList();
      _applyFilter();
      _error = null;
      notifyListeners();
      appLogger.i('Deleted service: $id');
      return true;
    } catch (e, st) {
      appLogger.e('deleteService failed', error: e, stackTrace: st);
      _error = 'Failed to delete service. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _applyFilter() => _applyFilterWithMap(const {});

  void _applyFilterWithMap(Map<String, String> categoryNames) {
    _filtered = _all.where((s) {
      final resolvedCatName =
          categoryNames[s.categoryId]?.toLowerCase() ?? s.categoryId.toLowerCase();

      final matchCat = _filterCategory.isEmpty ||
          resolvedCatName.contains(_filterCategory.toLowerCase());

      final matchName = _filterServiceName.isEmpty ||
          s.serviceName
              .toLowerCase()
              .contains(_filterServiceName.toLowerCase());

      return matchCat && matchName;
    }).toList();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
