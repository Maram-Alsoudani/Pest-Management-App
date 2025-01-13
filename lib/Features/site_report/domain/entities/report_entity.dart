class ReportEntity {
  String id;
  final String siteName;
  final String siteId;
  final String notes;
  final String conditions;
  final List<String> recommendations;
  final Map<String, int> materialUsages;
  final List<String> photos;
  final List<String> devices;
  final List<String> signatures;
  final String userId;
  final String createdBy;
  final DateTime createdAt;

  ReportEntity({
    required this.id,
    this.siteName = 'Unknown',
    this.siteId = 'Unknown',
    this.notes = 'No notes',
    this.conditions = 'No conditions',
    this.recommendations = const ['No recommendations'],
    this.materialUsages = const {'No material usages': 0},
    this.photos = const ['No photos'],
    this.devices = const ['No devices'],
    this.signatures = const ['No signatures'],
    required this.userId,
    required this.createdBy,
    required this.createdAt,
  });

  ReportEntity copyWith({
    String? id,
    String? siteName,
    String? siteId,
    String? notes,
    String? conditions,
    List<String>? recommendations,
    Map<String, int>? materialUsages,
    List<String>? photos,
    List<String>? devices,
    List<String>? signatures,
    String? userId,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return ReportEntity(
      id: id ?? this.id,
      siteName: siteName ?? this.siteName,
      siteId: siteId ?? this.siteId,
      notes: notes ?? this.notes,
      conditions: conditions ?? this.conditions,
      recommendations: recommendations ?? this.recommendations,
      materialUsages: materialUsages ?? this.materialUsages,
      photos: photos ?? this.photos,
      devices: devices ?? this.devices,
      signatures: signatures ?? this.signatures,
      userId: userId ?? this.userId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
