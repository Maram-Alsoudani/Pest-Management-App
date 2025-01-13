import 'package:bug_away/Features/reports/domain/entities/site_entity.dart';

class SiteDto extends SiteEntity {
  SiteDto({
    super.siteId,
    required super.siteLocation,
    required super.siteName,
    super.userId,
  });

  SiteDto.fromFireStore(Map<String, dynamic> data)
      : this(
            siteId: data["siteId"] as String?,
            siteLocation: data["siteLocation"] as String?,
            siteName: data["siteName"] as String?,
            userId: data['userId'] as String?);

  Map<String, dynamic> toFireStore() {
    return {
      "siteId": siteId,
      "siteLocation": siteLocation,
      "siteName": siteName,
      "userId": userId,
    };
  }

  SiteDto copyWith({
    String? id,
    String? siteName,
    String? siteLocation,
    String? userId,
  }) {
    return SiteDto(
      siteId: id ?? siteId,
      siteName: siteName ?? this.siteName,
      siteLocation: siteLocation ?? this.siteLocation,
      userId: userId ?? this.userId,
    );
  }
}
