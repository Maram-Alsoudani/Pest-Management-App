import 'package:pesticides/Features/site/domain/entities/site_entitiy.dart';

class SitedDTO extends SiteEntitiy {
  static String collectionName = 'site';

  SitedDTO({super.id, required super.siteName, super.siteLocation});

  SitedDTO.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data['id'] as String,
          siteName: data['siteName'] as String,
          siteLocation: data['siteLocation'] as String,
        );

  Map<String, dynamic> toFireStore() {
    return {"id": id, "siteName": siteName, "siteLocation": siteLocation};
  }
}
