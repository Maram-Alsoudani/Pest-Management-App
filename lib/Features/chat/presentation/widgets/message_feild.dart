import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/chat/presentation/manager/chat_view_model_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bug_away/Core/utils/colors.dart';

class MessageTextFeild extends StatelessWidget {
  const MessageTextFeild({
    super.key,
    required this.bloc,
  });

  final ChatViewModelCubit bloc;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.greyShade6,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: TextFormField(
          style: const TextStyle(color: ColorManager.whiteColor),
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: StringManager.typeMessage,
            hintStyle: const TextStyle(color: ColorManager.whiteColor),
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 10.w,
            ),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.r),
              borderSide: const BorderSide(
                color: ColorManager.greyShade2,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.r),
              borderSide: const BorderSide(
                color: ColorManager.primaryColor,
                width: 2.0,
              ),
            ),
            suffixIcon: BlocBuilder<ChatViewModelCubit, ChatViewModelState>(
              builder: (context, state) {
                return IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.solidPaperPlane,
                    size: 20.sp,
                    color: bloc.messageController.isEmpty
                        ? ColorManager.greyShade4
                        : ColorManager.primaryColor,
                  ),
                  onPressed: bloc.messageController.isEmpty
                      ? null
                      : () {
                          bloc.sendMessage();
                        },
                );
              },
            ),
          ),
          controller: bloc.clearMessageController,
          onChanged: (text) {
            bloc.funcButton(text);
          },
        ),
      ),
    );
  }
}
