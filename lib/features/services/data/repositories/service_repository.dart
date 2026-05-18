import 'dart:math';

import '../models/service_model.dart';

/// Mock repository for [ServiceModel].
///
/// Simulates async network calls with artificial delays.
class ServiceRepository {
  static final List<ServiceModel> _store = [
    const ServiceModel(
      id: '1',
      categoryId: '1',
      serviceName: 'Haircut',
      serviceNameArb: 'قص الشعر',
      baseRate: 50,
      shortDescription: "Classic men's or women's haircut.",
      duration: 30,
      displayOrder: 1,
      commissionType: CommissionType.percentage,
      commissionValue: 10,
      branch: 'Main Branch',
    ),
    const ServiceModel(
      id: '2',
      categoryId: '1',
      serviceName: 'Hair Colouring',
      serviceNameArb: 'صبغ الشعر',
      baseRate: 150,
      shortDescription: 'Full colour or highlights treatment.',
      duration: 90,
      displayOrder: 2,
      commissionType: CommissionType.amount,
      commissionValue: 20,
      allowAtCustomerLocation: true,
      branch: 'Main Branch',
    ),
    const ServiceModel(
      id: '3',
      categoryId: '2',
      serviceName: 'Deep Facial',
      serviceNameArb: 'تنظيف الوجه العميق',
      baseRate: 120,
      shortDescription: 'Deep cleansing facial treatment.',
      duration: 60,
      displayOrder: 1,
      commissionType: CommissionType.percentage,
      commissionValue: 15,
      branch: 'City Centre',
    ),
    const ServiceModel(
      id: '4',
      categoryId: '3',
      serviceName: 'Swedish Massage',
      serviceNameArb: 'المساج السويدي',
      baseRate: 200,
      shortDescription: 'Full-body relaxation massage.',
      duration: 60,
      displayOrder: 1,
      commissionType: CommissionType.percentage,
      commissionValue: 12,
      branch: 'Main Branch',
    ),
    const ServiceModel(
      id: '5',
      categoryId: '4',
      serviceName: 'Gel Manicure',
      serviceNameArb: 'مناكير جل',
      baseRate: 80,
      shortDescription: 'Long-lasting gel nail application.',
      duration: 45,
      displayOrder: 1,
      commissionType: CommissionType.amount,
      commissionValue: 10,
      allowAtCustomerLocation: true,
      branch: 'City Centre',
    ),
    const ServiceModel(
      id: '6',
      categoryId: '5',
      serviceName: "Men's Shave",
      serviceNameArb: 'حلاقة الرجال',
      baseRate: 40,
      shortDescription: 'Traditional hot-towel shave.',
      duration: 25,
      displayOrder: 1,
      commissionType: CommissionType.percentage,
      commissionValue: 8,
      branch: 'Main Branch',
    ),
  ];

  Future<List<ServiceModel>> fetchAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return List<ServiceModel>.unmodifiable(_store);
  }

  Future<ServiceModel> add(ServiceModel service) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final saved = service.copyWith(
      id: (1000 + Random().nextInt(8999)).toString(),
    );
    _store.add(saved);
    return saved;
  }

  Future<ServiceModel> update(ServiceModel service) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final index = _store.indexWhere((s) => s.id == service.id);
    if (index == -1) throw Exception('Service not found: ${service.id}');
    _store[index] = service;
    return service;
  }

  Future<void> delete(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _store.removeWhere((s) => s.id == id);
  }
}
