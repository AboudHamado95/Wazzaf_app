import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/login/login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  PhoneAuthCredential? phoneAuthCredential;
  void userLoginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  void userLoginWithPhoneNumber({required String phoneNumber}) async {
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
      emit(LoginWithPhoneNumberSuccessState(value.user!.uid));
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
