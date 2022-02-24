import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/cubit/video/video_bloc.dart';
import 'package:wazzaf/cubit/video/video_state.dart';
import 'package:wazzaf/styles/colors/colors.dart';
import 'package:wazzaf/widgets/show_dialog.dart';
import 'package:wazzaf/widgets/video.dart';
import 'package:wazzaf/widgets/widgets.dart';

class AddVideoScreen extends StatelessWidget {
  AddVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(listener: (context, state) {
      if (state is UploadVideoJobSuccessState) {
        showToast(
            message: 'تم إضافة الفيديو بنجاح', state: ToastStates.SUCCESS);
      }
    }, builder: (context, state) {
      var _cubit = CareerCubit.get(context);
      void showDialogToWorkers(
        context,
        CareerCubit cubit,
      ) async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const ProgressDialog(message: 'الرجاء الانتظار');
            });
        await cubit.getVideos();
        Navigator.of(context).pop();
      }

      Future<bool> _onWillPop() async {
        showDialogToWorkers(context, _cubit);
        await Navigator.of(context)
            .pushNamedAndRemoveUntil(picturesRoute, (route) => false);

        return true;
      }

      return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: defaultTextButton(
                      function: () async {
                        if (_cubit.videoFile != null) {
                          _cubit.uploadVideo();
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
                          state is UploadVideoJobLoadingState)
                        const LinearProgressIndicator(),
                      if (state is AddCareerLoadingState ||
                          state is UploadVideoJobLoadingState)
                        const SizedBox(
                          height: 10.0,
                        ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (_cubit.videoFile != null)
                        Expanded(
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Video.blocProvider(
                                _cubit.videoFile!,
                                aspectRatio: 1 / 1.565,
                                autoPlay: false,
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
                              _cubit.selectVideo();
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
