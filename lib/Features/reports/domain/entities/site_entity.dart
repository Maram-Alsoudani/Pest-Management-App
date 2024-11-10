class SiteEntity {
  static const String collectionName = 'site';

  String? siteId;
  String? siteLocation;
  String? siteName;

  SiteEntity({
     this.siteId,
    required this.siteLocation,
    required this.siteName,
  });
}
