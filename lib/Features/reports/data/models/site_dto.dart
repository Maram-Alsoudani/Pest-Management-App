import 'package:pesticides/Features/reports/domain/entities/site_entity.dart';

class SiteDto extends SiteEntity {
  SiteDto({
     super.siteId,
    required super.siteLocation,
    required super.siteName,
  });

  SiteDto.fromFireStore(Map<String, dynamic> data)
      : this(
          siteId: data["siteId"] as String?,
          siteLocation: data["siteLocation"] as String?,
          siteName: data["siteName"] as String?,
        );

  Map<String, dynamic> toFireStore() {
    return {
      "siteId": siteId,
      "siteLocation": siteLocation,
      "siteName": siteName,
    };
  }
}
