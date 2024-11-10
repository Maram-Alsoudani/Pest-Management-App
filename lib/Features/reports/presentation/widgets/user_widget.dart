import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/strings.dart';

import '../../../../Core/utils/colors.dart';

class UserWidget extends StatelessWidget {
  final String userName;
  final String imageUrl;
  final String email;

  UserWidget(
      {super.key,
      required this.imageUrl,
      required this.userName,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(
        bottom: 20.sp,
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
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
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/avatar.png"),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/avatar.png",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: ColorManager.greyShade4,
                      ),
                ),
              ],
            ),
          ),
          Text(
            StringManager.view,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: ColorManager.redColor,
                ),
          ),
        ],
      ),
    );
  }
}
