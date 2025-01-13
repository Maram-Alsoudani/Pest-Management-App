import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/chat/presentation/manager/chat_view_model_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.bloc,
  });

  final ChatViewModelCubit bloc;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      onPressed: bloc.messageController.isEmpty
          ? null
          : () {
              bloc.sendMessage();
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            StringManager.sendMessage,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 5),
          FaIcon(
            FontAwesomeIcons.solidPaperPlane,
            size: 15.sp,
            color: ColorManager.whiteColor,
          ),
        ],
      ),
    );
  }
}
