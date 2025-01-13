import 'package:bug_away/Core/component/empty_pages.dart';
import 'package:bug_away/Features/chat/presentation/widgets/date_seperator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/images.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/chat/presentation/manager/chat_view_model_cubit.dart';
import 'package:bug_away/Features/chat/presentation/widgets/message_feild.dart';
import 'package:bug_away/Features/chat/presentation/widgets/message_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ChatViewModelCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => bloc.getMessage());
    bloc.user = bloc.getUser()!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          StringManager.companyGroup,
          style:
              Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20.sp),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
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
          Column(
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
                        return Padding(
                          padding: EdgeInsets.only(top: 100.h),
                          child: const EmptyStateWidget(
                              lottiePath: ImageManager.emptyChatLottie,
                              message: StringManager.noMessage),
                        );
                      }

                      return ListView.builder(
                        controller: bloc.scrollController,
                        itemCount: bloc.messages.length,
                        itemBuilder: (context, index) {
                          final message = bloc.messages[index];
                          final previousMessage =
                              index > 0 ? bloc.messages[index - 1] : null;
                          final showDateSeparator = previousMessage == null ||
                              message.dateTime.day !=
                                  previousMessage.dateTime.day;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showDateSeparator)
                                Center(
                                    child:
                                        DateSeparator(date: message.dateTime)),
                              MessageWidget(
                                message: message,
                                userId: bloc.user.id ?? "",
                                dateTime: bloc.formatDateTime(message.dateTime),
                                bloc: bloc,
                              ),
                            ],
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
              Container(
                color: ColorManager.backgroundColor,
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  top: 10.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom == 0
                      ? MediaQuery.of(context).padding.bottom + 10.h
                      : 10.h,
                ),
                child: Row(
                  children: [
                    MessageTextFeild(bloc: bloc),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
