import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/cubit/register/register_states.dart';
import 'package:wazzaf/models/worker__model.dart';
import 'package:wazzaf/models/user_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister(
      {required String name,
      required String email,
      required String phone,
      required String password,
      required String city,
      String literal = ''}) async {
    emit(RegisterLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
          uId: value.user!.uid,
          name: name,
          email: email,
          phone: phone,
          city: city,
          literal: literal);
    }).catchError((error) {
      emit(RegisterErrorState(error));
    });
  }

  Future<void> userCreate({
    required String uId,
    required String name,
    required String email,
    required String phone,
    required String city,
    required String literal,
  }) async {
    bool isAdmin = false;
    if (literal == '') {
      UserModel model = UserModel(
          uId: uId,
          name: name,
          email: email,
          phone: phone,
          city: city,
          isAdmin: isAdmin);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap())
          .then((value) {
        emit(CreateUserSuccessState(uId));
      }).catchError((error) {
        emit(CreateUserErrorState(error));
      });
    } else {
      WorkerModel model = WorkerModel(
          uId: uId,
          name: name,
          email: email,
          phone: phone,
          city: city,
          literal: literal,
          isAdmin: isAdmin);

      await FirebaseFirestore.instance
          .collection('workers')
          .doc(uId)
          .set(model.toMap())
          .then((value) {
        emit(CreateUserSuccessState(uId));
      }).catchError((error) {
        emit(CreateUserErrorState(error));
      });
    }
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }

  bool literal = false;
  void changeCareerVisibility() {
    literal = !literal;
    emit(RegisterChangeCareerVisibilityState());
  }
}
