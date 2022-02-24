abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String uId;

  LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}


//************Get all career states*/

class GetAllCareerLoadingState extends LoginStates {}

class GetAllCareerSuccessState extends LoginStates {}

class GetAllCareerErrorState extends LoginStates {
  final String error;

  GetAllCareerErrorState(this.error);
}


//**************Change phone auth state */

class ChangePhoneAuthState extends LoginStates {}


//************Get all Users states*/

class GetAllUsersForPhoneLoadingState extends LoginStates {}

class GetAllUsersForPhoneSuccessState extends LoginStates {}

class GetAllUsersForPhoneErrorState extends LoginStates {
  final String error;

  GetAllUsersForPhoneErrorState(this.error);
}

// /
//************Get user data state */

class GetUserLoadingState extends LoginStates {}

class GetUserSuccessState extends LoginStates {}

class GetUserErrorState extends LoginStates {
  final String error;

  GetUserErrorState(this.error);
}



//******************** */

class LoginWithPhoneNumberLoadingState extends LoginStates {}

class LoginWithPhoneNumberSuccessState extends LoginStates {
  final String uId;

  LoginWithPhoneNumberSuccessState(this.uId);
}

class LoginWithPhoneNumberSuccessStateWithoutId extends LoginStates {}

class LoginWithPhoneNumberErrorStateWithoutId extends LoginStates {}

class LoginWithPhoneNumberErrorState extends LoginStates {
  final String error;

  LoginWithPhoneNumberErrorState(this.error);
}

class ChangeVertificationIdState extends LoginStates {
  final String vertificationId;

  ChangeVertificationIdState(this.vertificationId);
}

class ChangePhoneAuthCredentialState extends LoginStates {}

class ChangePasswordVisibilityState extends LoginStates {}
