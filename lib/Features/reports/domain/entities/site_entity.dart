class SiteEntity {
  static const String collectionName = 'site';

  String? siteId;
  String? siteLocation;
  String? siteName;
  String? userId;

  SiteEntity({
     this.siteId,
    required this.siteLocation,
    required this.siteName,
    this.userId,
  });
}
