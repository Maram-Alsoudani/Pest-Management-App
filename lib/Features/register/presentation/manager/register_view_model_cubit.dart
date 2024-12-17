import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/register/domain/use_cases/register_use_case.dart';

import '../../../../Core/errors/failures.dart';

part 'register_view_model_state.dart';

@injectable
class RegisterViewModelCubit extends Cubit<RegisterViewModelState> {
  RegisterUseCase registerUseCase;
  RegisterViewModelCubit({required this.registerUseCase})
      : super(RegisterViewModelInitial());
  static RegisterViewModelCubit get(context) =>
      BlocProvider.of<RegisterViewModelCubit>(context);

  //===============Variables Handle=======================
  List<String> list = ["admin", "user"];
  String? selectedValue;
  bool isLoaded = false;
  var fromKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //===============Image Profile Handle===================
  final ImagePicker picker = ImagePicker();
  File? image;
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(RegisterViewModelChangeImage());
    } else {
      image = null;
      emit(RegisterViewModelChangeImage());
    }
  }

  //===============Animation Handle=======================
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  double opacity = 0.0;

  void doAnimation(SingleTickerProviderStateMixin single) {
    animationController = AnimationController(
        vsync: single, duration: const Duration(seconds: 1));

    slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      opacity = 1.0;
      emit(RegisterViewModelAnimation());
      animationController.forward();
    });
  }

  //==========Defualt DropDownValue Handle===============
  void initValueDropDown() {
    selectedValue = list[0];
  }

  //===============Register Handle=======================
  Future<void> register() async {
    isLoaded = true;
    emit(RegisterViewModelLoading());
    var either = await registerUseCase.registerFireStore(
        image?.path ?? "",
        selectedValue ?? "admin",
        userNameController.text,
        phoneController.text,
        emailController.text,
        passwordController.text);
    either.fold((error) {
      isLoaded = false;
      emit(RegisterViewModelError(failure: error));
    }, (response) {
      isLoaded = false;
      emit(RegisterViewModelSuccess());
      clearData();
    });
  }

//===============Close Screen Handle=====================

  void clearData() {
    userNameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    image = null;
  }
//   @override
//   Future<void> close() {
//     return super.close();
//   }
}
