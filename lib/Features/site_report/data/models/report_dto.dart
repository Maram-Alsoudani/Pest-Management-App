import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  ReportModel({
    required super.id,
    super.siteName = 'Unknown',
    required super.siteId,
    super.notes = 'No notes',
    super.conditions = 'No conditions',
    super.recommendations = const ['No recommendations'],
    super.materialUsages = const {'No material usages': 0},
    super.photos = const ['No photos'],
    super.devices = const ['No devices'],
    super.signatures = const ['No signatures'],
    required super.userId,
    required super.createdBy,
    required super.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      siteName: json['siteName'] ?? 'Unknown',
      siteId: json['siteId'] ?? 'site id not found',
      notes: json['notes'] ?? 'No notes',
      conditions: json['conditions'] ?? 'No conditions',
      recommendations:
          List<String>.from(json['recommendations'] ?? ['No recommendations']),
      materialUsages: Map<String, int>.from(
          json['materialUsages'] ?? {'No material usages': 0}),
      photos: List<String>.from(json['photos'] ?? ['No photos']),
      devices: List<String>.from(json['devices'] ?? ['No devices']),
      signatures: List<String>.from(json['signatures'] ?? ['No signatures']),
      userId: json['userId'] ?? '',
      createdBy: json['createdBy'] ?? 'Unknown',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siteName': siteName,
      'siteId': siteId,
      'notes': notes,
      'conditions': conditions,
      'recommendations': recommendations,
      'materialUsages': materialUsages,
      'photos': photos,
      'devices': devices,
      'signatures': signatures,
      'userId': userId,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
