import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Features/reports/presentation/manager/all_users_screen_view_model.dart';
import 'package:pesticides/Features/reports/presentation/manager/get_all_users_states.dart';
import 'package:pesticides/Features/reports/presentation/widgets/user_widget.dart';
import 'package:pesticides/di/di.dart';
import '../../../../Core/component/text_feild_custom.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/strings.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  AllUsersScreenViewModel allUsersViewModel = getIt<AllUsersScreenViewModel>();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      allUsersViewModel.searchUsers(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.reportsSubmittedBy),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CustomTextFormField(
              hint: StringManager.searchHint,
              controller: searchController,
              validator: (value) {
                return null;
              },
              borderRadius: BorderRadius.circular(26.0.r),
            ),
          ),
          Expanded(
            child: BlocBuilder<AllUsersScreenViewModel, GetAllUsersState>(
              bloc: allUsersViewModel..getUsers(),
              builder: (context, state) {
                if (state is GetAllUsersErrorState) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (state is NoSearchResultsState) {
                  return Center(
                    child: Text(
                      StringManager.noUsersFound,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: ColorManager.greyShade4),
                    ),
                  );
                } else if (state is GetAllUsersSuccessState) {
                  return Padding(
                    padding: EdgeInsets.all(15.sp),
                    child: ListView.builder(
                      itemCount: state.usersList.length,
                      itemBuilder: (context, index) {
                        final user = state.usersList[index];

                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesManger.routeNameSitesOfUser,
                                arguments: state.usersList[index]!.id);
                          },
                          child: UserWidget(
                            imageUrl: user?.image ?? "assets/images/avatar.png",
                            userName: user?.userName ?? "Unknown User",
                            email: user?.email ?? "",
                          ),
                        );
                      },
                    ),
                  );
                }
                return Center(
                    child: CircularProgressIndicator(
                        color: ColorManager.primaryColor));
              },
            ),
          ),
        ],
      ),
    );
  }
}
