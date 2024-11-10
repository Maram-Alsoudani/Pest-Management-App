class SiteEntity {
  static const String collectionName = 'site';

  String? siteId;
  String? siteLocation;
  String? siteName;

  SiteEntity({
    required this.siteId,
    required this.siteLocation,
    required this.siteName,
  });
}
