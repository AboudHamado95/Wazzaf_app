import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/career_model.dart';
import 'package:wazzaf/models/message_model.dart';
import 'package:wazzaf/models/picture_model.dart';
import 'package:wazzaf/models/rating_model.dart';
import 'package:wazzaf/models/video_model.dart';
import 'package:wazzaf/models/user_model.dart';

class CareerCubit extends Cubit<CareerStates> {
  CareerCubit() : super(CareerInitialState());

  static CareerCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  Future getUserData() async {
    emit(GetUserLoadingState());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      print('data: ${value.data()}');
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error.toString()));
    });
  }

//***************************************** */
  List<Marker> myMarker = [];
  Future handleTap(LatLng tappedPoint) async {
    myMarker = [];
    myMarker.add(
      Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position:
              LatLng(filterUserModel!.latitude!, filterUserModel!.longitude!)),
    );
    emit(ChangeMarkerState());
  }

  CameraPosition? kGooglePlex;
  Future locationFunction() async {
    kGooglePlex = CameraPosition(
      target: LatLng(filterUserModel!.latitude!, filterUserModel!.longitude!),
      zoom: 14.4746,
    );
    emit(SelectLocationState());
  }

  Position? position;
  double? updateLong;
  double? updateLat;
  Future updateLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    updateLong = position!.longitude;
    updateLat = position!.latitude;
    print('lat: $updateLat long: $updateLong');
    emit(UpdateLocationState());
  }

//***************************** */
  List<UserModel> usersList = [];

  Future getUsersData() async {
    usersList = [];
    emit(CareerGetUsersDataLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        usersList.add(UserModel.fromJson(element.data()));
      }
      emit(CareerGetUsersDataSuccessState());
    }).catchError((error) {
      emit(CareerGetUsersDataErrorState(error.toString()));
    });
  }

  ImagePicker imagePicker = ImagePicker();

  File? userImage;

  Future getUserImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      emit(UserImagePickedErrorState());
      return 'No image selected.';
    }
    final imageTemporary = File(pickedFile.path);
    userImage = imageTemporary;
    emit(UserImagePickedSuccessState());
  }

  UserModel? filterUserModel;
  Future filterUser(String name) async {
    filterUserModel = usersList.firstWhere((user) => user.name == name);
    // emit(FilterUserState());
  }

  List<UserModel>? usersFilterList;
  Future filterUsers(name) async {
    usersFilterList = [];
    emit(CareerSearchLoadingState());
    return FirebaseFirestore.instance
        .collection('careers')
        .where('name', isEqualTo: name)
        .get()
        .then((value) async {
      usersFilterList = usersList
          .where((element) => element.literal == value.docs[0].data()['name'])
          .toList();
      print('sssssssssssssssssssssss${usersFilterList![0].rating}');
      emit(FilterUserSuccessState());
    }).catchError((error) {
      emit(FilterUserErrorState(error.toString()));
    });
  }

  void removeUserImage() {
    careerImage = null;
    emit(UserRemoveImageState());
  }

  Future uploadUserImage({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String city,
    required String literal,
    required bool isAdmin,
    required double rating,
    double? latitude,
    double? longitude,
  }) async {
    emit(UploadUserImageLoadingState());
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    storage
        .ref()
        .child('users/${Uri.file(userImage!.path).pathSegments.last}')
        .putFile(userImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) async {
        print(value.toString());
        await updateUser(
          id: id,
          name: name,
          email: email,
          phone: phone,
          city: city,
          literal: literal,
          isAdmin: isAdmin,
          latitude: filterUserModel!.latitude!,
          longitude: filterUserModel!.longitude!,
          image: value.toString(),
          rating: rating,
        );
      }).catchError((error) {
        emit(UploadUserImageErrorState());
      });
    }).catchError((error) {
      emit(UploadUserImageErrorState());
    });
  }

  ImagePicker pictureForJob = ImagePicker();

  File? jobImage;

  Future pictureJob() async {
    final pickedFile =
        await pictureForJob.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      emit(PictureJobErrorState());
      return 'No image selected.';
    }
    final imageTemporary = File(pickedFile.path);
    jobImage = imageTemporary;
    emit(PictureJobSuccessState());
  }
//************************************************ */

  FilePickerResult? resultVideo;
  File? videoFile;
  Future selectVideo() async {
    resultVideo = await FilePicker.platform.pickFiles();
    if (resultVideo != null) {
      videoFile = File(resultVideo!.files.single.path!);
      emit(VideoJobSuccessState());
    } else {
      emit(VideoJobErrorState());
      return 'No video selected.';
    }
  }

  void removeVideo() {
    videoFile = null;
    emit(VideoJobRemoveState());
  }

  Future uploadVideo() async {
    emit(UploadVideoJobLoadingState());
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    storage
        .ref()
        .child(
            'videos/${filterUserModel!.name}/${Uri.file(videoFile!.path).pathSegments.last}')
        .putFile(videoFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) async {
        print(value.toString());
        createVideoModel(videoLink: value.toString());
        removeVideo();
        emit(UploadVideoJobSuccessState());
      }).catchError((error) {
        emit(UploadVideoJobErrorState());
      });
    }).catchError((error) {
      emit(UploadVideoJobErrorState());
    });
  }

  Future createVideoModel({required String videoLink}) async {
    emit(CreatePictureLoadingState());
    VideoModel model = VideoModel(
      uId: filterUserModel!.uId,
      videoLink: videoLink,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(filterUserModel!.uId)
        .collection('videos')
        .add(model.toMap())
        .then((value) async {
      await getUsersData();
      await filterUsers(filterUserModel!.literal);
      await filterUser(filterUserModel!.name!);
      await getVideos();
      emit(CreateVideoSuccessState());
    }).catchError((error) {
      emit(CreateVideoErrorState());
    });
  }

  List<VideoModel> videosList = [];
  Future<List<VideoModel>> getVideos() async {
    videosList = [];
    emit(GetVideoJobLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(filterUserModel!.uId)
        .collection('videos')
        .get()
        .then((value) {
      for (var element in value.docs) {
        videosList.add(VideoModel.fromJson(element.data()));
      }

      print('videooooooooo: ${videosList[0].videoLink!}');
      emit(GetVideoJobSuccessState());
    });
    return videosList;
  }

  VideoPlayerController? controller;
  Future showVideo() async {
    emit(ShowVideoLoadingState());
    controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        emit(ShowVideoSuccessState());
      }).catchError((error) {
        emit(ShowVideoErrorState());
      });
  }
  //*********************************** */

  void removePictureImage() {
    jobImage = null;
    emit(PictureJobRemoveState());
  }

  Future uploadPictureForJob() async {
    emit(UploadPictureJobLoadingState());
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    storage
        .ref()
        .child(
            'picturesJob/${filterUserModel!.name}/${Uri.file(jobImage!.path).pathSegments.last}')
        .putFile(jobImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) async {
        print(value.toString());
        createPictureModel(image: value.toString());
        removePictureImage();
        emit(UploadPictureJobSuccessState());
      }).catchError((error) {
        emit(UploadPictureJobErrorState());
      });
    }).catchError((error) {
      emit(UploadUserImageErrorState());
    });
  }

  Future createPictureModel({required String image}) async {
    emit(CreatePictureLoadingState());
    PictureModel model = PictureModel(
      uId: filterUserModel!.uId,
      image: image,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(filterUserModel!.uId)
        .collection('picturesOfJob')
        .add(model.toMap())
        .then((value) async {
      await getUsersData();
      await filterUsers(filterUserModel!.literal);
      await filterUser(filterUserModel!.name!);
      await getPicturesJob();
      emit(CreatePictureSuccessState());
    }).catchError((error) {
      emit(CreatePictureErrorState());
    });
  }

  List<PictureModel> picturesList = [];
  Future getPicturesJob() async {
    picturesList = [];
    emit(GetPictureJobLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(filterUserModel!.uId)
        .collection('picturesOfJob')
        .get()
        .then((value) {
      for (var element in value.docs) {
        picturesList.add(PictureModel.fromJson(element.data()));
      }
      emit(GetPictureJobSuccessState());
    });
  }

  double userRating = 3.0;

  Future ratingModel({required String uId, required String rate}) async {
    var rating = double.parse(rate);
    if (rating > 5) {
      userRating = 5;
    } else if (rating < 0) {
      userRating = 0;
    } else {
      userRating = rating;
    }
    emit(AddRateWorkerLoadingState());

    RatingModel model = RatingModel(
      uId: uId,
      rate: userRating,
    );

    if (idRatingList.any((element) => element == userModel!.uId)) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(filterUserModel!.uId)
          .collection('rate')
          .doc(userModel!.uId)
          .update(model.toMap())
          .then((value) async {
        emit(AddRateWorkerSuccessState());
      }).catchError((error) {
        emit(AddRateWorkerErrorState());
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(filterUserModel!.uId)
          .collection('rate')
          .doc(userModel!.uId)
          .set(model.toMap())
          .then((value) async {
        emit(AddRateWorkerSuccessState());
      }).catchError((error) {
        emit(AddRateWorkerErrorState());
      });
    }
  }

  List<double> rateList = [];
  List<String> idRatingList = [];

  Future getUserForRating() async {
    rateList = [];
    idRatingList = [];
    emit(GetRatingWorkerLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(filterUserModel!.uId)
        .collection('rate')
        .get()
        .then((value) {
      for (var item in value.docs) {
        rateList.add(item['rate']);
        idRatingList.add(item['uId']);
      }
      List ratings = value.docs.map((e) => e['rate']!).toList();
      double sum = ratings.fold(0, (p, c) => p + c);
      double? average;
      if (sum > 0) {
        average = sum / ratings.length;
      }
      userRating = average!;
      UserModel model = UserModel(
        uId: filterUserModel!.uId,
        name: filterUserModel!.name,
        email: filterUserModel!.email,
        phone: filterUserModel!.phone,
        city: filterUserModel!.city,
        literal: filterUserModel!.literal,
        isAdmin: filterUserModel!.isAdmin,
        latitude: filterUserModel!.latitude!,
        longitude: filterUserModel!.longitude!,
        image: filterUserModel!.image,
        rating: userRating,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(filterUserModel!.uId)
          .update(model.toMap())
          .then((value) async {
        emit(UpdateUserDataSuccessState());
      }).catchError((error) {
        emit(UpdateUserDataErrorState(error.toString()));
      });

      emit(GetRatingWorkerSuccessState());
    }).catchError((error) {
      emit(GetRatingWorkerErrorState());
    });
  }
  // FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(filterUserModel!.uId)
  //     .collection('rate')
  //     .get()
  //     .then((value) {
  //   for (var item in value.docs) {
  //     rateList.add(RatingModel.fromJson(item.data()));
  //   }
  // });
  // await getUsersData();
  // await filterUsers(filterUserModel!.literal);
  // await filterUser(filterUserModel!.name!);
  // updateUser(
  //   id: filterUserModel!.uId!,
  //   name: filterUserModel!.name!,
  //   email: filterUserModel!.email!,
  //   phone: filterUserModel!.phone!,
  //   city: filterUserModel!.city!,
  //   literal: filterUserModel!.literal!,
  //   isAdmin: filterUserModel!.isAdmin!,
  //   latitude: filterUserModel!.latitude!,
  //   longitude: filterUserModel!.longitude!,
  //   image: filterUserModel!.image!,
  //   rating: userRating,
  // );

  double changeUserRate(String rate) {
    print('$userRating');

    emit(ChangeRateWorkerState());
    return userRating;
  }

  Future updateUser(
      {required String id,
      required String name,
      required String email,
      required String phone,
      required String city,
      required String literal,
      required bool isAdmin,
      required double latitude,
      required double longitude,
      required double rating,
      String? image}) async {
    emit(UpdateUserDataLoadingState());
    UserModel model = UserModel(
      uId: id,
      name: name,
      email: email,
      phone: phone,
      city: city,
      literal: literal,
      image: image,
      isAdmin: isAdmin,
      latitude: latitude,
      longitude: longitude,
      rating: rating,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update(model.toMap())
        .then((value) async {
      await updateLocation();
      await locationFunction();
      await getUsersData();
      await getUserData();
      await filterUsers(literal);
      await filterUser(filterUserModel!.name!);
      emit(UpdateUserDataSuccessState());
    }).catchError((error) {
      emit(UpdateUserDataErrorState(error));
    });
  }

  CareerModel? careerModel;

  File? careerImage;

  Future getCareerImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      emit(CareerImagePickedErrorState());
      return 'No image selected.';
    }
    final imageTemporary = File(pickedFile.path);
    careerImage = imageTemporary;
    emit(CareerImagePickedSuccessState());
  }

  void removeCareerImage() {
    careerImage = null;
    emit(CareerRemoveImageState());
  }

  Future uploadCareerImage({
    required String text,
  }) async {
    emit(UploadimageCareerLoadingState());
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    storage
        .ref()
        .child('careers/${Uri.file(careerImage!.path).pathSegments.last}')
        .putFile(careerImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) async {
        await createCareer(name: text, image: value.toString());
      }).catchError((error) {
        emit(UploadimageCareerErrorState());
      });
    }).catchError((error) {
      emit(UploadimageCareerErrorState());
    });
  }

  Future createCareer({required String name, required String image}) async {
    emit(AddCareerLoadingState());
    CareerModel model = CareerModel(
      name: name,
      image: image,
    );
    FirebaseFirestore.instance
        .collection('careers')
        .add(model.toMap())
        .then((value) {
      emit(AddCareerSuccessState());
      removeCareerImage();
      getCareers();
    }).catchError((error) {
      emit(AddCareerErrorState());
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

  List<CareerModel> searchCareers = [];

  void getCareerSearch(String name) {
    searchCareers = [];
    emit(CareerSearchLoadingState());
    FirebaseFirestore.instance.collection('careers').get().then((value) {
      List<CareerModel> searchQuery = value.docs
          .where((element) =>
              element['name'].toString().toLowerCase().contains(name))
          .map((data) {
        CareerModel searchCareerModel = CareerModel();
        searchCareerModel.name = data.get('name');
        searchCareerModel.image = data.get('image');
        return searchCareerModel;
      }).toList();
      searchCareers = searchQuery;
      emit(CareerSearchSuccessState());
    }).catchError((error) {
      emit(CareerSearchErrorState(error.toString()));
    });
  }

  List<UserModel> searchUser = [];

  void getUserSearch(String name) {
    searchUser = [];
    emit(UserSearchLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        // .where('literal', isEqualTo: name)
        .get()
        .then((value) {
      List<UserModel> searchQuery = value.docs
          .where((element) =>
              element['name'].toString().toLowerCase().contains(name))
          .map((data) {
        UserModel searchUserModel = UserModel();
        searchUserModel.uId = data.get('uId');
        searchUserModel.name = data.get('name');
        searchUserModel.phone = data.get('phone');
        searchUserModel.city = data.get('city');
        searchUserModel.literal = data.get('literal');
        searchUserModel.image = data.get('image');
        searchUserModel.isAdmin = data.get('isAdmin');
        searchUserModel.email = data.get('email');
        searchUserModel.rating = data.get('rating');

        return searchUserModel;
      }).toList();
      searchUser = searchQuery;
      emit(UserSearchSuccessState());
    }).catchError((error) {
      emit(UserSearchErrorState(error.toString()));
    });
  }

  String? literalCheck;

  void changeDropDown(String value) {
    literalCheck = value;
    emit(ChangeDropDownState());
  }

  List<UserModel> users = [];
  Future getUsersForChat() async {
    users = [];
    emit(CareerGetAllUsersLoadingState());
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) async {
        // List<UserModel> usersSearch = [];
        for (var value in value.docs) {
          if (value.data()['uId'] != userModel!.uId) {
            users.add(UserModel.fromJson(value.data()));
            // var user = value.data()['uId'];
            // await getMessages(receivedId: user);
            // messages
            //     .where((element) =>
            //         element.receiverId == user || element.senderId == user)
            //     .map((e) {
            //   e.receiverId;
            //   e.senderId;
            //   users.add(usersSearch.firstWhere((user) =>
            //       user.uId == e.receiverId || user.uId == e.senderId));
            // }).toList();
          }
        }
        //********** */
        //*********** */
        emit(CareerGetAllUsersSuccessState());
      }).catchError((error) {
        emit(CareerGetAllUsersErrorState(error.toString()));
      });
    }
  }

  void chatUserScreen() {}

  Future sendMessage({
    required String receivedId,
    required String dateTime,
    required String text,
    required String receiver,
  }) async {
    MessageModel messageModel = MessageModel(
        senderId: userModel!.uId,
        receiverId: receivedId,
        receiver: receiver,
        sendBy: userModel!.name!,
        dateTime: dateTime,
        text: text);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receivedId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(CareerSendMessageSuccessState());
    }).catchError((error) {
      emit(CareerSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receivedId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(CareerSendMessageSuccessState());
    }).catchError((error) {
      emit(CareerSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  Future getMessages({required String receivedId}) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receivedId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(CareerGetMessagesSuccessState());
    });
  }
}
