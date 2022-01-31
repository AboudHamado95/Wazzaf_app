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
