import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/video_model.dart';
import 'package:wazzaf/screens/video/video_item.dart';
import 'package:wazzaf/styles/colors/colors.dart';
import 'package:wazzaf/widgets/video.dart';
import 'package:wazzaf/widgets/widgets.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<CareerCubit, CareerStates>(
        listener: ((context, state) {}),
        builder: (context, state) {
          var _cubit = CareerCubit.get(context);

          return SafeArea(
            child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: defaultAppBar(
                    context: context,
                    title: 'نماذج',
                    actions: [
                      if (_cubit.userModel!.isAdmin! ||
                          _cubit.userModel!.uId == _cubit.filterUserModel!.uId!)
                        Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: IconButton(
                              onPressed: () => navigateTo(context, addVideoRoute),
                              icon: const Icon(Icons.video_camera_back_outlined),
                              color: defaultColor,
                            )),
                    ],
                  ),
                ),
                body: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _cubit.videosList.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return itemList(context, _cubit.videosList[index], _cubit);
                  },
                )),
          );

          //************************** */
        },
      ),
    );
  }
}

Widget itemList(context, VideoModel videoModel, CareerCubit _cubit) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(4.0),
    child: InkWell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: VideoItems(
              videoPlayerController:
                  VideoPlayerController.network(videoModel.videoLink!),
            ),
            // Video.blocProvider(File(videoModel.videoLink!),
            //     aspectRatio: 1 / 1),
          ),
        ),
      ),
    ),
  );
}
