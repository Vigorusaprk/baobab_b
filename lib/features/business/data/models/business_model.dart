// lib/features/business/data/models/business_model.dart
import '../../domain/entities/business_entity.dart';

class BusinessModel extends Business {
  BusinessModel({
    required super.id,
    required super.name,
    required super.address,
    required super.description,
    required super.bgImg,
    required super.rating,
    required super.reviewCount,
    required super.openingHours,
    required super.type,
    required super.phone,
    super.email,
    super.website,
    required super.images,
    required super.specificData,
    required super.reviews,
    required super.isFavorite,
    super.latitude,
    super.longitude,
    super.stores,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      bgImg: json['bg_img'] ?? '',
      rating: _toDouble(json['rating']),
      reviewCount: _toInt(json['review_count']),
      openingHours: Map<String, String>.from(json['opening_hours'] ?? {}),
      type: _stringToBusinessType(json['type'] ?? 'other'),
      phone: json['phone'] ?? '',
      email: json['email'],
      website: json['website'],
      images: List<String>.from(json['images'] ?? []),
      specificData: json['specific_data'] ?? {},
      reviews: (json['reviews'] as List?)
          ?.map((r) => BusinessReview.fromJson(r))
          .toList() ?? [],
      isFavorite: json['is_favorite'] ?? false,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      stores: json['stores'] != null
          ? (json['stores'] as List).map((s) => BusinessModel.fromJson(s)).toList()
          : null,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static BusinessType _stringToBusinessType(String type) {
    switch (type.toLowerCase()) {
      case 'restaurant': return BusinessType.restaurant;
      case 'fastfood': return BusinessType.fastFood;
      case 'shopping': return BusinessType.shopping;
      case 'mall': return BusinessType.mall;
      case 'hotel': return BusinessType.hotel;
      case 'carrental': return BusinessType.carRental;
      case 'cinema': return BusinessType.cinema;
      case 'travelagency': return BusinessType.travelAgency;
      case 'spa': return BusinessType.spa;
      case 'tourism': return BusinessType.tourism;
      default: return BusinessType.other;
    }
  }
}