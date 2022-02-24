abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

//register state

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);
}

//************Get all career states*/

class GetAllCareerForRegisterLoadingState extends RegisterStates {}

class GetAllCareerForRegisterSuccessState extends RegisterStates {}

class GetAllCareerForRegisterErrorState extends RegisterStates {
  final String error;

  GetAllCareerForRegisterErrorState(this.error);
}

//**************Change Drop down state */

class ChangeDropDownState extends RegisterStates {}

//**************Change phone auth state */

class ChangePhoneAuthState extends RegisterStates {}

//**************Location state */

class LocationState extends RegisterStates {}

//create user state

class CreateUserSuccessState extends RegisterStates {
  final String uId;

  CreateUserSuccessState(this.uId);
}

class CreateUserErrorState extends RegisterStates {
  final String error;

  CreateUserErrorState(this.error);
}

//password visibility state

class RegisterChangePasswordVisibilityState extends RegisterStates {}

//career textFormField state

class RegisterChangeCareerVisibilityState extends RegisterStates {}
