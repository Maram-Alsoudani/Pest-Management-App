
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/chat/presentation/manager/chat_view_model_cubit.dart';

class MessageTextFeild extends StatelessWidget {
  const MessageTextFeild({
    super.key,
    required this.bloc,
  });

  final ChatViewModelCubit bloc;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          hintText: StringManager.typeYourMessage,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 10.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        onChanged: (text) {
          bloc.funcButton(text);
        },
      ),
    );
  }
}
