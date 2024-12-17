import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';

import '../../domin/use_case/read_user_or_admin_from_fireStore_use_case.dart';

part 'category_state.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  ReadUserOrAdminFromFireStoreUseCase readUserOrAdminFromFireStoreUseCase;
  CategoryCubit({required this.readUserOrAdminFromFireStoreUseCase})
      : super(CategoryInitial());

  bool isLoading = false;

  Future<void> getUserData() async {
    isLoading = true;
    emit(CategoryLoadingState());

    var either = await readUserOrAdminFromFireStoreUseCase.invoke();
    either.fold(
      (f) {
        isLoading = false;
        emit(
            CategoryFaluireState(error: Failure(errorMessage: f.errorMessage)));
      },
      (r) {
        isLoading = false;
        emit(CategorySuccessState(
            userAndAdminModelEntity: UserAndAdminModelEntity(
                image: r.image,
                type: r.type,
                userName: r.userName,
                phone: r.phone,
                email: r.phone)));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (animationController != null &&
              !animationController!.isAnimating) {
            animationController!.forward();
          }
        });
      },
    );
  }

  //===============Animation Handle=======================
  AnimationController? animationController;
  late Animation<Offset> slideAnimation;

  void doAnimation(SingleTickerProviderStateMixin single) {
    animationController = AnimationController(
        vsync: single, duration: const Duration(seconds: 1));

    slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Future<void> close() {
    animationController?.dispose();
    return super.close();
  }
}
