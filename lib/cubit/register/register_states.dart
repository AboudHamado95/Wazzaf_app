abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

//register state

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);
}

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
