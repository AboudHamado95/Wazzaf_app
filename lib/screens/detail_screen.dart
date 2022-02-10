import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'dart:ui' as ui;

import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = CareerCubit.get(context);
        final routeArg = ModalRoute.of(context)?.settings.arguments as Map;

        Future<bool> _onWillPop() async {
          await _cubit.filterWorker(routeArg['literal']);
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
                                          _cubit.filterWorkerModel!.image!,
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
                                    //  getCareerImage('omal'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 45.0,
                            left: 25.0,
                            child: GestureDetector(
                              onTap: () {
                                navigateTo(context, locationRoute);
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
                      customContainer(_cubit.filterWorkerModel!.name!),
                      customContainer(_cubit.filterWorkerModel!.phone!),
                      customContainer(_cubit.filterWorkerModel!.city!),
                      customContainer(_cubit.filterWorkerModel!.literal!),
                      if (_cubit.userModel!.isAdmin! ||
                          _cubit.userModel!.uId ==
                              _cubit.filterWorkerModel!.uId!)
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            updateDataRoute,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.edit),
                              Text('تعديل'),
                            ],
                          ),
                        ),
                    ],
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
