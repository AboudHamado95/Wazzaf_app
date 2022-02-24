import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/login/login_states.dart';
import 'package:wazzaf/models/career_model.dart';
import 'package:wazzaf/models/user_model.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() async {
    emit(GetUserLoadingState());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      print('data: ${value.data()}');
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error.toString()));
    });
  }

  void getuserData() async {
    emit(GetUserLoadingState());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      print('data: ${value.data()}');
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error.toString()));
    });
  }

  List<CareerModel> careersList = [];

  void getCareers() {
    careersList = [];
    emit(GetAllCareerLoadingState());
    FirebaseFirestore.instance.collection('careers').get().then((value) {
      for (var element in value.docs) {
        careersList.add(CareerModel.fromJson(element.data()));
      }
      emit(GetAllCareerSuccessState());
    }).catchError((error) {
      emit(GetAllCareerErrorState(error.toString()));
    });
  }

  List<UserModel> usersList = [];

  //************************* */

  void getUsers() {
    usersList = [];
    emit(GetAllUsersForPhoneLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        usersList.add(UserModel.fromJson(element.data()));
        print('users List : ${usersList[0]}');
      }

      emit(GetAllUsersForPhoneSuccessState());
    }).catchError((error) {
      emit(GetAllUsersForPhoneErrorState(error.toString()));
    });
  }

//********************************** */
  void getUser(String phone) {
    userModel = usersList.firstWhere((user) => user.phone == phone);
    emit(GetUserSuccessState());
  }

  PhoneAuthCredential? phoneAuthCredential;
  void userLoginWithEmailAndPassword(
      {required String email, required String password}) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      print(value.user!.email);
      print(value.user!.uid);

      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  String? phoneAuth;
  void phone(String number) {
    phoneAuth = number;
    emit(ChangePhoneAuthState());
  }

  void userLoginWithPhoneNumber({
    required String phoneNumber,
  }) async {
    emit(LoginWithPhoneNumberLoadingState());
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) async {
        emit(LoginWithPhoneNumberSuccessStateWithoutId());
      },
      verificationFailed: (verificationFailed) async {
        emit(LoginWithPhoneNumberErrorStateWithoutId());
        showToast(
            message: verificationFailed.message.toString(),
            state: ToastStates.ERROR);
      },
      codeSent: (verId, resendingToken) async {
        verificationId = verId;
        print('verificationId: $verificationId');
        emit(ChangeVertificationIdState(verificationId!));
        emit(LoginWithPhoneNumberLoadingState());
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    )
        .catchError((error) {
      emit(LoginWithPhoneNumberErrorState(error));
    });
  }

  Future<PhoneAuthCredential> phoneAuthCredentialFunction(
      String smsCode) async {
    phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: smsCode);
    emit(ChangePhoneAuthCredentialState());
    return phoneAuthCredential!;
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    emit(LoginWithPhoneNumberLoadingState());

    await FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((value) {
      if (userModel != null) {
        emit(LoginWithPhoneNumberSuccessState(userModel!.uId!));
      }
      // else {
      //   emit(LoginWithPhoneNumberSuccessState(userModel!.uId!));
      // }
    }).catchError((error) {
      emit(LoginWithPhoneNumberErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }
}
