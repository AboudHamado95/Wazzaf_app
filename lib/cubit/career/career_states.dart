abstract class CareerStates {}

//************Initial state */

class CareerInitialState extends CareerStates {}

//************Get user data state */

class GetUserLoadingState extends CareerStates {}

class GetUserSuccessState extends CareerStates {}

class GetUserErrorState extends CareerStates {
  final String error;

  GetUserErrorState(this.error);
}

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

//*************Search career state */

class CareerSearchLoadingState extends CareerStates {}

class CareerSearchSuccessState extends CareerStates {}

class CareerSearchErrorState extends CareerStates {
  final String error;

  CareerSearchErrorState(this.error);
}

//*************Search User state */

class UserSearchLoadingState extends CareerStates {}

class UserSearchSuccessState extends CareerStates {}

class UserSearchErrorState extends CareerStates {
  final String error;

  UserSearchErrorState(this.error);
}

//************Add image User state */

class UserImagePickedSuccessState extends CareerStates {}

class UserImagePickedErrorState extends CareerStates {}

//*************Remove image User state */

class UserRemoveImageState extends CareerStates {}

//************Upload image User states */

class UploadUserImageLoadingState extends CareerStates {}

class UploadUserImageErrorState extends CareerStates {}

class UploadUserImageSuccessState extends CareerStates {}

//************Add picture job state */

class PictureJobSuccessState extends CareerStates {}

class PictureJobErrorState extends CareerStates {}

//*************Remove picture job state */

class PictureJobRemoveState extends CareerStates {}

//************Upload picture job states */

class UploadPictureJobLoadingState extends CareerStates {}

class UploadPictureJobErrorState extends CareerStates {}

class UploadPictureJobSuccessState extends CareerStates {}

//*************Get picture job state */

class GetPictureJobLoadingState extends CareerStates {}

class GetPictureJobSuccessState extends CareerStates {}

class GetPictureJobErrorState extends CareerStates {}

//*************Create picture model state */

class CreatePictureLoadingState extends CareerStates {}

class CreatePictureSuccessState extends CareerStates {}

class CreatePictureErrorState extends CareerStates {}

//**************Add picture to list state */

class AddPictureToListState extends CareerStates {}

//************Add Video job state */

class VideoJobSuccessState extends CareerStates {}

class VideoJobErrorState extends CareerStates {}

//*************Remove Video job state */

class VideoJobRemoveState extends CareerStates {}

//************Upload Video job states */

class UploadVideoJobLoadingState extends CareerStates {}

class UploadVideoJobErrorState extends CareerStates {}

class UploadVideoJobSuccessState extends CareerStates {}

//*************Get Video job state */

class GetVideoJobLoadingState extends CareerStates {}

class GetVideoJobSuccessState extends CareerStates {}

class GetVideoJobErrorState extends CareerStates {}

//*************Show Video state */

class ShowVideoLoadingState extends CareerStates {}

class ShowVideoSuccessState extends CareerStates {}

class ShowVideoErrorState extends CareerStates {}

//*************Create Video model state */

class CreateVideoLoadingState extends CareerStates {}

class CreateVideoSuccessState extends CareerStates {}

class CreateVideoErrorState extends CareerStates {}

//**************Add Video to list state */

class AddVideoToListState extends CareerStates {}

//*************Get all Users state */

class CareerGetUsersDataLoadingState extends CareerStates {}

class CareerGetUsersDataSuccessState extends CareerStates {}

class CareerGetUsersDataErrorState extends CareerStates {
  final String error;

  CareerGetUsersDataErrorState(this.error);
}

//*************Get User state */

class FilterUserState extends CareerStates {}

//**************Get location state */

class SelectLocationState extends CareerStates {}

//**************Marker state */

class ChangeMarkerState extends CareerStates {}

//**************Update location state */

class UpdateLocationState extends CareerStates {}

//**************Update Users data state */

class UpdateUserDataSuccessState extends CareerStates {}

class UpdateUserDataLoadingState extends CareerStates {}

class UpdateUserDataErrorState extends CareerStates {
  final String error;

  UpdateUserDataErrorState(this.error);
}

//**************Change Rate Worker state */

class ChangeRateWorkerState extends CareerStates {}

//**************Add Rate Worker state */

class AddRateWorkerLoadingState extends CareerStates {}

class AddRateWorkerSuccessState extends CareerStates {}

class AddRateWorkerErrorState extends CareerStates {}

//**************Get Rating Worker List state */

class GetRatingWorkerLoadingState extends CareerStates {}

class GetRatingWorkerSuccessState extends CareerStates {}

class GetRatingWorkerErrorState extends CareerStates {}


//**************Change Drop down state */

class ChangeDropDownState extends CareerStates {}

//**************Filter User data state  */

class FilterUserSuccessState extends CareerStates {}

class FilterUserErrorState extends CareerStates {
  final String error;

  FilterUserErrorState(this.error);
}

//***************Chat state */

class CareerSendMessageSuccessState extends CareerStates {}

class CareerSendMessageErrorState extends CareerStates {}

class CareerGetMessagesSuccessState extends CareerStates {}

//****************Get User for chat state */

class CareerGetAllUsersLoadingState extends CareerStates {}

class CareerGetAllUsersSuccessState extends CareerStates {}

class CareerGetAllUsersErrorState extends CareerStates {
  final String error;

  CareerGetAllUsersErrorState(this.error);
}
