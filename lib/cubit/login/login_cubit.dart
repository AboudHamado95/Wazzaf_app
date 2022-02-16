import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/login/login_states.dart';
import 'package:wazzaf/models/career_model.dart';
import 'package:wazzaf/models/user_model.dart';
import 'package:wazzaf/models/worker_model.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  WorkerModel? workerModel;

  UserModel? userModel;

  UserModel? userModelForPhoneAuth;

  WorkerModel? workerModelForPhoneAuth;

  void getUserData() async {
    emit(GetUserLoadingState());

    await FirebaseFirestore.instance
        .collection('workers')
        .doc(uId)
        .get()
        .then((value) {
      print('data: ${value.data()}');
      workerModel = WorkerModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error.toString()));
    });
  }

  void getWorkerData() async {
    emit(GetUserLoadingState());

    await FirebaseFirestore.instance
        .collection('workers')
        .doc(uId)
        .get()
        .then((value) {
      print('data: ${value.data()}');
      workerModel = WorkerModel.fromJson(value.data()!);
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

  List<WorkerModel> workersList = [];

  void getWorkers() {
    workersList = [];
    emit(GetAllWorkersForPhoneLoadingState());
    FirebaseFirestore.instance.collection('workers').get().then((value) {
      for (var element in value.docs) {
        workersList.add(WorkerModel.fromJson(element.data()));
        print('workers List : ${workersList[0]}');
      }

      emit(GetAllWorkersForPhoneSuccessState());
    }).catchError((error) {
      emit(GetAllWorkersForPhoneErrorState(error.toString()));
    });
  }

//********************************** */
  void getWorker(String phone) {
    workerModel = workersList.firstWhere((worker) => worker.phone == phone);
    emit(GetWorkerSuccessState());
  }

  // void getUser(String phone) {
  //   userModel = usersList.firstWhere((user) => user.phone == phone);
  //   emit(GetUserSuccessState());
  // }

  void getUsers() {
    usersList = [];
    emit(GetAllUsersForPhoneLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        usersList.add(UserModel.fromJson(element.data()));
        print('${usersList[0]}');
      }
      print('user model for phone :${userModel!.name!}');
      emit(GetAllUsersForPhoneSuccessState());
    }).catchError((error) {
      emit(GetAllUsersForPhoneErrorState(error.toString()));
    });
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
      // await CareerCubit.get(context).getWorkersData();
      // await CareerCubit.get(context).getUserData();
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
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

  void workerLoginWithPhoneNumber({
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
      if (workerModel != null) {
        emit(LoginWithPhoneNumberSuccessState(workerModel!.uId!));
      } else {
        emit(LoginWithPhoneNumberSuccessState(userModel!.uId!));
      }
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
