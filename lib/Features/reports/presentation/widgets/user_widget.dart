import 'package:bug_away/Core/component/loading_items_widget.dart';
import 'package:bug_away/Core/utils/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Core/utils/colors.dart';

class UserWidget extends StatelessWidget {
  final String userName;
  final String imageUrl;
  final String email;

  const UserWidget({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          color: ColorManager.whiteColor,
          child: ListTile(
            leading: Container(
              width: 70.w,
              height: 70.h,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.greyShade4,
              ),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => const ItemsLoadingWidget(),
                      errorWidget: (context, url, error) =>
                          Image.asset(ImageManager.avatar),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      ImageManager.avatar,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
            ),
            title: Text(
              userName,
              style: Theme.of(context).textTheme.headlineLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle:
                Text(email, style: Theme.of(context).textTheme.headlineMedium),
            trailing: Text(
              StringManager.view,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: ColorManager.redColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
