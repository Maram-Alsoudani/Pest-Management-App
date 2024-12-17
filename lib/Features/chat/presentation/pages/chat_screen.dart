import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/images.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/chat/presentation/manager/chat_view_model_cubit.dart';
import 'package:bug_away/Features/chat/presentation/widgets/message_feild.dart';
import 'package:bug_away/Features/chat/presentation/widgets/message_widget.dart';
import 'package:bug_away/Features/chat/presentation/widgets/seach_button.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ChatViewModelCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => bloc.getMessage());
    bloc.user = bloc.getUser()!;

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
              title: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: ColorManager.backgroundColor,
                    radius: 30,
                    backgroundImage: AssetImage(ImageManager.engIcon),
                  ),
                  Column(
                    children: [
                      Text(
                        StringManager.theCompanyGroup,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 20.sp),
                      ),
                      Text(
                        "${bloc.user.userName}(${bloc.user.type})",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 20.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Container(
              margin: EdgeInsets.symmetric(
                vertical: 30.h,
                horizontal: 20.w,
              ),
              decoration: BoxDecoration(
                color: ColorManager.whiteColor,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<ChatViewModelCubit, ChatViewModelState>(
                      builder: (context, state) {
                        if (state is ChatViewModelFailGetMessage) {
                          return Center(
                            child: Text(
                              state.error.errorMessage.toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        } else if (state is ChatViewModelGetMessage ||
                            state is ChatViewModelAddMessage ||
                            state is ChatViewModelButtonState) {
                          if (bloc.messages.isEmpty) {
                            return const Center(
                              child: Text("No messages yet."),
                            );
                          }

                          return ListView.builder(
                            controller: bloc.scrollController,
                            itemCount: bloc.messages.length,
                            itemBuilder: (context, index) {
                              return MessageWidget(
                                message: bloc.messages[index],
                                userId: bloc.user.id ?? "",
                                dateTime: bloc.dateTime,
                              );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 10.w,
                    ),
                    child: Row(
                      children: [
                        MessageTextFeild(bloc: bloc),
                        SizedBox(width: 10.w),
                        BlocBuilder<ChatViewModelCubit, ChatViewModelState>(
                          builder: (context, state) {
                            return SearchButton(bloc: bloc);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
