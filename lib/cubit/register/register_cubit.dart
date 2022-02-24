import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wazzaf/cubit/register/register_states.dart';
import 'package:wazzaf/models/career_model.dart';
import 'package:wazzaf/models/user_model.dart';
import 'package:wazzaf/models/user_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  List<CareerModel> careersList = [];

  void getCareers() {
    careersList = [];
    emit(GetAllCareerForRegisterLoadingState());
    FirebaseFirestore.instance.collection('careers').get().then((value) {
      for (var element in value.docs) {
        careersList.add(CareerModel.fromJson(element.data()));
        print('${careersList[0]}');
      }
      emit(GetAllCareerForRegisterSuccessState());
    }).catchError((error) {
      emit(GetAllCareerForRegisterErrorState(error.toString()));
    });
  }

  double? latitude;
  double? longitude;
  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
    print('lat: $latitude long: $longitude');
    emit(LocationState());
  }

  void userRegister(
      {required String name,
      required String email,
      required String phone,
      required String password,
      required String city,
      double? lat,
      double? lan,
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
          lan: lan,
          lat: lat,
          literal: literal);
    }).catchError((error) {
      emit(RegisterErrorState(error));
    });
  }

  String? literalCheck;

  void changeDropDown(String value) {
    literalCheck = value;
    emit(ChangeDropDownState());
  }

  Future<void> userCreate(
      {required String uId,
      required String name,
      required String email,
      required String phone,
      required String city,
      required String literal,
      double? lat,
      double? lan}) async {
    bool isAdmin = false;
    String image =
        'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png';
    if (literal == '') {
      UserModel model = UserModel(
          uId: uId,
        name: name,
        email: email,
        phone: phone,
        city: city,
        literal: 'مستخدم عادي',
        image: image,
        isAdmin: isAdmin,
        latitude: lat,
        longitude: lan,);

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
      UserModel model = UserModel(
        uId: uId,
        name: name,
        email: email,
        phone: phone,
        city: city,
        literal: literal,
        image: image,
        isAdmin: isAdmin,
        latitude: lat,
        longitude: lan,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap())
          .then((value) {
        emit(CreateUserSuccessState(uId));
      }).catchError((error) {
        emit(CreateUserErrorState(error));
      });
    }
  }

  String? phoneAuth;
  void phone(String number) {
    phoneAuth = number;
    emit(ChangePhoneAuthState());
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
