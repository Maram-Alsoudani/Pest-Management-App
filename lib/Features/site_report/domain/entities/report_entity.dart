class ReportEntity {
  String id;
  final String siteName;
  final String notes;
  final String conditions;
  final List<String> recommendations;
  final Map<String, int> materialUsages;
  final List<String> photos;
  final List<String> devices;
  final List<String> signatures;
  final String userId;
  final DateTime createdAt;

  ReportEntity({
    required this.id,
    this.siteName = 'Unknown',
    this.notes = 'No notes',
    this.conditions = 'No conditions',
    this.recommendations = const ['No recommendations'],
    this.materialUsages = const {'No material usages': 0},
    this.photos = const ['No photos'],
    this.devices = const ['No devices'],
    this.signatures = const ['No signatures'],
    required this.userId,
    required this.createdAt,
  });
}
