import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/career_model.dart';
import 'package:wazzaf/models/worker_model.dart';

class CareerCubit extends Cubit<CareerStates> {
  CareerCubit() : super(CareerInitialState());

  static CareerCubit get(context) => BlocProvider.of(context);
  WorkerModel? workerModel;
  List<WorkerModel> workersList = [];

  Future getWorkersData() async {
    emit(CareerGetWorkersDataLoadingState());
    FirebaseFirestore.instance.collection('workers').get().then((value) {
      workersList = [];
      for (var element in value.docs) {
        workersList.add(WorkerModel.fromJson(element.data()));
      }
      emit(CareerGetWorkersDataSuccessState());
    }).catchError((error) {
      emit(CareerGetWorkersDataErrorState(error.toString()));
    });
  }

  ImagePicker imagePicker = ImagePicker();

  File? workerImage;

  Future getWokerImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      emit(WorkerImagePickedErrorState());
      return 'No image selected.';
    }
    final imageTemporary = File(pickedFile.path);
    workerImage = imageTemporary;
    emit(WorkerImagePickedSuccessState());
  }

  WorkerModel? filterWorkerModel;
  List<WorkerModel>? workersFilterList;
  Future filterWorker(name) async {
    workersFilterList = [];
    emit(CareerSearchLoadingState());
    return FirebaseFirestore.instance
        .collection('careers')
        .where('name', isEqualTo: name)
        .get()
        .then((value) async {
      workersFilterList = workersList
          .where((element) => element.literal == value.docs[0].data()['name'])
          .toList();
      filterWorkerModel = workersList.firstWhere(
          (worker) => worker.literal == value.docs[0].data()['name']);
      emit(FilterWorkerSuccessState());
    }).catchError((error) {
      emit(FilterWorkerErrorState(error.toString()));
    });
  }

  void removeWorkerImage() {
    careerImage = null;
    emit(WorkerRemoveImageState());
  }

  Future uploadWorkerImage({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String city,
    required String literal,
    required bool isAdmin,
  }) async {
    emit(UploadWorkerImageLoadingState());
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    storage
        .ref()
        .child('workers/${Uri.file(workerImage!.path).pathSegments.last}')
        .putFile(workerImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) async {
        print(value.toString());
        await updateWorker(
          id: id,
          name: name,
          email: email,
          phone: phone,
          city: city,
          literal: literal,
          isAdmin: isAdmin,
          image: value.toString(),
        );
      }).catchError((error) {
        emit(UploadWorkerImageErrorState());
      });
    }).catchError((error) {
      emit(UploadWorkerImageErrorState());
    });
  }

  Future updateWorker(
      {required String id,
      required String name,
      required String email,
      required String phone,
      required String city,
      required String literal,
      required bool isAdmin,
      String? image}) async {
    emit(UpdateWorkerDataLoadingState());
    WorkerModel model = WorkerModel(
        uId: id,
        name: name,
        email: email,
        phone: phone,
        city: city,
        literal: literal,
        image: image,
        isAdmin: isAdmin);
    FirebaseFirestore.instance
        .collection('workers')
        .doc(id)
        .update(model.toMap())
        .then((value) async {
      await getWorkersData();
      await filterWorker(literal);
      emit(UpdateWorkerDataSaccessState());
    }).catchError((error) {
      emit(UpdateWorkerDataErrorState(error));
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

  ChangeRadioEnum? valueRadio = ChangeRadioEnum.career;

  void changeRadioEnumButton(ChangeRadioEnum value) {
    valueRadio = value;
    emit(ChangeRadioButtonState());
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

  List<WorkerModel> searchWorker = [];

  void getWorkerSearch(String name) {
    searchWorker = [];
    emit(WorkerSearchLoadingState());
    FirebaseFirestore.instance.collection('workers').get().then((value) {
      List<WorkerModel> searchQuery = value.docs
          .where((element) =>
              element['name'].toString().toLowerCase().contains(name))
          .map((data) {
        WorkerModel searchWorkerModel = WorkerModel();
        searchWorkerModel.uId = data.get('uId');
        searchWorkerModel.name = data.get('name');
        searchWorkerModel.phone = data.get('phone');
        searchWorkerModel.city = data.get('city');
        searchWorkerModel.literal = data.get('literal');
        searchWorkerModel.image = data.get('image');
        searchWorkerModel.isAdmin = data.get('isAdmin');
        searchWorkerModel.email = data.get('email');

        return searchWorkerModel;
      }).toList();
      searchWorker = searchQuery;
      emit(WorkerSearchSuccessState());
    }).catchError((error) {
      emit(WorkerSearchErrorState(error.toString()));
    });
  }
}
