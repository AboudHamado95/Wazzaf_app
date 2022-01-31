abstract class CareerStates {}

class CareerInitialState extends CareerStates {}

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

//************Add career states */

class UploadimageCareerLoadingState extends CareerStates {}

class UploadimageCareerErrorState extends CareerStates {}

class UploadimageCareerSuccessState extends CareerStates {}

//************Add career image state */

class CareerImagePickedSuccessState extends CareerStates {}

class CareerImagePickedErrorState extends CareerStates {}

//*************Remove career image state */

class CareerRemovePostImageState extends CareerStates {}


// class SocialGetUserLoadingState extends SocialStates {}

// class SocialGetUserSuccessState extends SocialStates {}

// class SocialGetUserErrorState extends SocialStates {
//   final String error;

//   SocialGetUserErrorState(this.error);
// }


// class SocialGetPostLoadingState extends SocialStates {}

// class SocialGetPostSuccessState extends SocialStates {}

// class SocialGetPostErrorState extends SocialStates {
//   final String error;

//   SocialGetPostErrorState(this.error);
// }

// class SocialLikePostSuccessState extends SocialStates {}

// class SocialLikePostErrorState extends SocialStates {
//   final String error;

//   SocialLikePostErrorState(this.error);
// }

// class SocialCommentPostSuccessState extends SocialStates {}

// class SocialCommentPostErrorState extends SocialStates {
//   final String error;

//   SocialCommentPostErrorState(this.error);
// }

// class SocialChangeBottomNavState extends SocialStates {}

// class SocialNewPostState extends SocialStates {}

// class SocialProfileImagePickedSuccessState extends SocialStates {}

// class SocialProfileImagePickedErrorState extends SocialStates {}

// class SocialCoverPickedSuccessState extends SocialStates {}

// class SocialCoverPickedErrorState extends SocialStates {}

// class SocialUploadProfileImageSuccessState extends SocialStates {}

// class SocialUploadProfileImageErrorState extends SocialStates {}

// class SocialUploadCoverSuccessState extends SocialStates {}

// class SocialUploadCoverErrorState extends SocialStates {}

// class SocialUserUpdateLoadingState extends SocialStates {}

// class SocialUserUpdateErrorState extends SocialStates {}

// class SocialPostImagePickedSuccessState extends SocialStates {}

// class SocialPostImagePickedErrorState extends SocialStates {}

// class SocialRemovePostImageState extends SocialStates {}

// class SocialCreatePostLoadingState extends SocialStates {}

// class SocialCreatePostErrorState extends SocialStates {}

// class SocialCreatePostSuccessState extends SocialStates {}

// class SocialSendMessageSuccessState extends SocialStates {}

// class SocialSendMessageErrorState extends SocialStates {}

// class SocialGetMessagesSuccessState extends SocialStates {}



