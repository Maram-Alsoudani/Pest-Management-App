import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/category/domin/use_case/edit_image.dart';
import 'package:bug_away/Features/category/domin/use_case/edit_user_data_use_case.dart';
import 'package:bug_away/Features/category/domin/use_case/read_user_or_admin_from_fireStore_use_case.dart';
import 'package:bug_away/Features/category/domin/use_case/removeFcm.dart';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ReadUserOrAdminFromFireStoreUseCase readUserOrAdminFromFireStoreUseCase;
  EditUserDataUserCase editUserDataUserCase;
  EditImageInFireStoreUseCase editImageInFireStoreUseCase;
  RemoveFcmFromFireStore removeFcmFromFireStore;

  ProfileCubit({
    required this.readUserOrAdminFromFireStoreUseCase,
    required this.editUserDataUserCase,
    required this.editImageInFireStoreUseCase,
    required this.removeFcmFromFireStore,
  }) : super(ProfileInitial());

  UserAndAdminModelDto? user;

  UserAndAdminModelEntity? getUser() {
    user = SharedPrefsLocal.getData(key: StringManager.userAdmin);
    return user;
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  bool isLoading = false;
  String? userProfileImage;

  Future<void> removeFcmUser() async {
    isLoading = true;
    emit(ProfileLogOutLoading());

    var either = await removeFcmFromFireStore.invoke();
    either.fold(
      (f) {
        isLoading = false;
        emit(ProfileLogOutError(error: f));
      },
      (_) {
        isLoading = false;
        SharedPrefsLocal.prefs.clear();
        FirebaseAuth.instance.signOut();
        clearData();
        emit(ProfileLogOutSuccess());
      },
    );
  }

  //todo====================Added by mohamed ali =======================
  static ProfileCubit get(context) => BlocProvider.of<ProfileCubit>(context);
  final dialogFormKey = GlobalKey<FormState>();
  final fromKey = GlobalKey<FormState>();
  //todo================================================================
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
  }

  Future<void> getUserData() async {
    isLoading = true;
    emit(ProfileLoading());

    var either = await readUserOrAdminFromFireStoreUseCase.invoke();
    either.fold(
      (f) {
        isLoading = false;
        emit(ProfileError(error: f));
      },
      (user) {
        isLoading = false;
        emit(ProfileSuccess(user: user));
        typeController.text = user.type ?? 'N/A';
        userNameController.text = user.userName ?? 'N/A';
        phoneController.text = user.phone ?? 'N/A';
        emailController.text = user.email ?? 'N/A';
        userProfileImage = user.image ?? '';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          opacity = 1;
          emit(ProfileAnimationSuccess());
          animationController.forward();
        });
      },
    );
  }

  Future<void> editDataUser() async {
    isLoading = true;
    emit(ProfileUpdateLoading());
    UserAndAdminModelEntity user = UserAndAdminModelEntity(
        image: userProfileImage,
        type: typeController.text,
        userName: userNameController.text,
        phone: phoneController.text,
        email: emailController.text);
    var either = await editUserDataUserCase.invoke(user);
    either.fold(
      (f) {
        isLoading = false;
        emit(ProfileUpdateError(error: f));
      },
      (_) {
        isLoading = false;
        emit(ProfileUpdateSuccess());
      },
    );
  }

  Future<void> editDataImage() async {
    isLoading = true;
    emit(ProfileUpdateLoading());
    var either = await editImageInFireStoreUseCase.invoke(image?.path ?? "");
    either.fold(
      (f) {
        isLoading = false;
        emit(ProfileUpdateError(error: f));
      },
      (_) {
        isLoading = false;

        emit(ProfileUpdateSuccess());
      },
    );
  }

  //===============Image Profile Handle===================
  final ImagePicker picker = ImagePicker();
  File? image;
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      editDataImage();
      emit(ProfileChangeImage());
    } else {
      image = null;
      emit(ProfileChangeImage());
    }
  }

  void clearData() {
    userNameController.clear();
    phoneController.clear();
    emailController.clear();
    typeController.clear();
    image = null;
  }
}
