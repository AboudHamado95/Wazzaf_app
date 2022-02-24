import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/career_model.dart';
import 'package:wazzaf/styles/colors/colors.dart';
import 'package:wazzaf/widgets/show_dialog.dart';
import 'package:wazzaf/widgets/widgets.dart';

class AddPictureScreen extends StatelessWidget {
  AddPictureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(listener: (context, state) {
      if (state is UploadPictureJobSuccessState) {
        showToast(message: 'تم إضافة الصورة بنجاح', state: ToastStates.SUCCESS);
      }
    }, builder: (context, state) {
      var _cubit = CareerCubit.get(context);

      Future<bool> _onWillPop() async {
        await _cubit.getPicturesJob();
        await Navigator.of(context)
            .pushNamedAndRemoveUntil(picturesRoute, (route) => false);

        return true;
      }

      return WillPopScope(
        onWillPop: _onWillPop,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('النماذج'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: defaultTextButton(
                      function: () async {
                        if (_cubit.jobImage != null) {
                          _cubit.uploadPictureForJob();
                        } else {
                          showToast(
                              message: 'الرجاء إدخال صورة',
                              state: ToastStates.WARNING);
                        }
                      },
                      text: 'إضافة',
                      color: defaultColor),
                ),
              ],
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20.0, bottom: 56.0),
                  child: Column(
                    children: [
                      if (state is AddCareerLoadingState ||
                          state is UploadPictureJobLoadingState)
                        const LinearProgressIndicator(),
                      if (state is AddCareerLoadingState ||
                          state is UploadPictureJobLoadingState)
                        const SizedBox(
                          height: 10.0,
                        ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (_cubit.jobImage != null)
                        Expanded(
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    image: DecorationImage(
                                        image: FileImage(_cubit.jobImage!),
                                        fit: BoxFit.cover),
                                  )),
                              Container(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () => _cubit.removePictureImage(),
                                  color: defaultColor,
                                  icon: const CircleAvatar(
                                    radius: 20.0,
                                    child: Icon(
                                      Icons.close,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              _cubit.pictureJob();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('إضافة نموذج'),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(Icons.photo),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
