abstract class CareerStates {}

//************Initial state */

class CareerInitialState extends CareerStates {}

//************Add career image state */

class CareerImagePickedSuccessState extends CareerStates {}

class CareerImagePickedErrorState extends CareerStates {}

//*************Remove career image state */

class CareerRemoveImageState extends CareerStates {}

//************Upload image career states */

class UploadimageCareerLoadingState extends CareerStates {}

class UploadimageCareerErrorState extends CareerStates {}

class UploadimageCareerSuccessState extends CareerStates {}

//************Get all career states*/

class GetAllCareerLoadingState extends CareerStates {}

class GetAllCareerSuccessState extends CareerStates {}

class GetAllCareerErrorState extends CareerStates {
  final String error;

  GetAllCareerErrorState(this.error);
}

//************Add career states */

class AddCareerLoadingState extends CareerStates {}

class AddCareerErrorState extends CareerStates {}

class AddCareerSuccessState extends CareerStates {}

//***************Change radio button state */

class ChangeRadioButtonState extends CareerStates {}

//*************Search career state */

class CareerSearchLoadingState extends CareerStates {}

class CareerSearchSuccessState extends CareerStates {}

class CareerSearchErrorState extends CareerStates {
  final String error;

  CareerSearchErrorState(this.error);
}

//*************Search worker state */

class WorkerSearchLoadingState extends CareerStates {}

class WorkerSearchSuccessState extends CareerStates {}

class WorkerSearchErrorState extends CareerStates {
  final String error;

  WorkerSearchErrorState(this.error);
}

//************Add image worker state */

class WorkerImagePickedSuccessState extends CareerStates {}

class WorkerImagePickedErrorState extends CareerStates {}

//*************Remove image worker state */

class WorkerRemoveImageState extends CareerStates {}

//************Upload image worker states */

class UploadWorkerImageLoadingState extends CareerStates {}

class UploadWorkerImageErrorState extends CareerStates {}

class UploadWorkerImageSuccessState extends CareerStates {}

//*************Get all workers state */

class CareerGetWorkersDataLoadingState extends CareerStates {}

class CareerGetWorkersDataSuccessState extends CareerStates {}

class CareerGetWorkersDataErrorState extends CareerStates {
  final String error;

  CareerGetWorkersDataErrorState(this.error);
}

//**************Update workers data state */

class UpdateWorkerDataSaccessState extends CareerStates {}

class UpdateWorkerDataLoadingState extends CareerStates {}

class UpdateWorkerDataErrorState extends CareerStates {
  final String error;

  UpdateWorkerDataErrorState(this.error);
}

//**************Filter worker data state  */

class FilterWorkerSuccessState extends CareerStates {}

class FilterWorkerErrorState extends CareerStates {
  final String error;

  FilterWorkerErrorState(this.error);
}

