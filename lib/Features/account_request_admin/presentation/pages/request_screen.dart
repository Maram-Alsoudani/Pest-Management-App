import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/images.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/account_request_admin/presentation/widgets/button_icon.dart';
import 'package:pesticides/Features/account_request_admin/presentation/widgets/label_widget.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});
  final String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageManager.background),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                        StringManager.accountRequests,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 20.sp),
                      ),
              
            ),
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(15.r),
                        padding: EdgeInsets.all(8.r),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorManager.whiteColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                imageUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(ImageManager.avatar),
                                        width: 80.w,
                                        height: 80.h,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        ImageManager.avatar,
                                        width: 80.w,
                                        height: 80.h,
                                        fit: BoxFit.cover,
                                      ),
                              ],
                            ),
                            LabelText(label: "Name:"),
                            LabelText(label: "Email:"),
                            LabelText(label: "Phone:"),
                            LabelText(label: "Type:"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonAndIcon(
                                    color: ColorManager.primaryColor,
                                    title: StringManager.decline,
                                    onTap: () {},
                                    icon: Icons.highlight_remove_rounded),
                                ButtonAndIcon(
                                    color: ColorManager.dialogGreenColor,
                                    title: StringManager.accept,
                                    onTap: () {},
                                    icon: Icons.done),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
