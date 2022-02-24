import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'dart:ui' as ui;

import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/career_model.dart';
import 'package:wazzaf/widgets/show_dialog.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);
  void showDialogToLocation(context, CareerCubit cubit, route) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const ProgressDialog(message: 'الرجاء الانتظار');
        });
    await cubit.getUserData();
    await cubit.getUsersData();
    await cubit.filterUsers(cubit.userModel!.literal);
    await cubit.handleTap(LatLng(cubit.filterUserModel!.latitude!,
        cubit.filterUserModel!.longitude!));
    Navigator.of(context).pop();
    navigateTo(context, locationRoute);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = CareerCubit.get(context);
        final routeArg = ModalRoute.of(context)?.settings.arguments as String;
        String literalRoute = routeArg;

        Future<bool> _onWillPop() async {
          await _cubit.filterUsers(routeArg);
          await Navigator.of(context)
              .pushNamedAndRemoveUntil(workersRoute, (route) => false);

          return true;
        }

        return WillPopScope(
          onWillPop: _onWillPop,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.amber[100],
                    title: const Text('تفاصيل العامل'),
                    elevation: 0.0,
                  ),
                  backgroundColor: Colors.amber[100],
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 190.0,
                              child: Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                        height: 140.0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.amber[200],
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(32.0),
                                            bottomRight: Radius.circular(32.0),
                                          ),
                                        )),
                                  ),
                                  CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor:
                                        Theme.of(context).scaffoldBackgroundColor,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            _cubit.filterUserModel!.image!,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                                child: Icon(Icons.error)),
                                        width: 100,
                                        height: 100.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 45.0,
                              left: 25.0,
                              child: GestureDetector(
                                onTap: () async {
                                  showDialogToLocation(
                                      context, _cubit, locationRoute);
                                  // await _cubit.filterWorker(
                                  //     _cubit.filterWorkerModel!.name!);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 6.0,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.7, 0.7),
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.amber[300],
                                    ),
                                    radius: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        customContainer(_cubit.filterUserModel!.name!),
                        customContainer(_cubit.filterUserModel!.phone!),
                        customContainer(_cubit.filterUserModel!.city!),
                        customContainer(_cubit.filterUserModel!.literal!),
                        if (_cubit.userModel!.isAdmin! ||
                            _cubit.userModel!.uId ==
                                _cubit.filterUserModel!.uId!)
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(
                                context, updateDataRoute,
                                arguments: literalRoute),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.edit),
                                Text('تعديل'),
                              ],
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            state is GetPictureJobLoadingState
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pushNamed(context, picturesRoute,
                                          arguments: literalRoute);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.picture_in_picture_rounded),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Center(child: Text('صور عن العمل')),
                                      ],
                                    ),
                                  ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, videosRoute,
                                    arguments: literalRoute);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.video_collection_rounded),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Center(child: Text('فيديوهات عن العمل')),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget customContainer(String text) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      height: 50.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.amber[300],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
