import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesticides/Core/utils/SharedPrefsLocal.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/register/data/models/user_model_dto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial()) {
    _loadUserData();
  }

  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  String? userProfileImage;

  void _loadUserData() {
    UserAndAdminModelDto? user =
        SharedPrefsLocal.getData(key: StringManager.keyUserAdmin);
    if (user != null) {
      typeController.text = user.type ?? 'N/A';
      userNameController.text = user.userName ?? 'N/A';
      phoneController.text = user.phone ?? 'N/A';
      emailController.text = user.email ?? 'N/A';
      userProfileImage = user.image ?? '';
      emit(ProfileLoaded(userProfileImage));
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      emit(ProfileUploading());
      String? imageUrl = await _uploadImageToFirebase(image);
      if (imageUrl != null) {
        userProfileImage = imageUrl;
        emit(ProfileLoaded(userProfileImage));
        _updateUserProfileImage(imageUrl);
      } else {
        emit(ProfileError("Error uploading image"));
      }
    }
  }

  Future<String?> _uploadImageToFirebase(XFile image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void _updateUserProfileImage(String imageUrl) async {
    UserAndAdminModelDto updatedUser = UserAndAdminModelDto(
      id: SharedPrefsLocal.getData(key: StringManager.keyUserAdmin)?.id,
      userName: userNameController.text,
      phone: phoneController.text,
      email: emailController.text,
      type: typeController.text,
      image: imageUrl,
    );
    SharedPrefsLocal.saveData(
      key: StringManager.keyUserAdmin,
      model: updatedUser,
    );
    await FirebaseUtils.getUserCollection(updatedUser.type ?? "")
        .doc(updatedUser.id)
        .update(updatedUser.toFireStore());
    emit(ProfileLoaded(imageUrl));
  }
}
