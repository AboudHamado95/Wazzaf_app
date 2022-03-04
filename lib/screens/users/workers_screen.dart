import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:wazzaf/cache/cache_helper.dart';
import 'package:wazzaf/components/components.dart';
import 'dart:ui' as ui;

import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/user_model.dart';
import 'package:wazzaf/widgets/drawer.dart';

class WorkersScreen extends StatelessWidget {
  const WorkersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<CareerCubit, CareerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var _cubit = CareerCubit.get(context);
          final routeArg = ModalRoute.of(context)?.settings.arguments as String;
          Future<bool> _onWillPop() async {
            await Navigator.of(context)
                .pushNamedAndRemoveUntil(mainRoute, (route) => false);
            return true;
          }

          return WillPopScope(
              onWillPop: _onWillPop,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SafeArea(
                  child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        title: const Text('العمال'),
                        actions: [
                          IconButton(
                            onPressed: () async {
                              await _cubit.cleanSearchUser();
                              Navigator.pushNamed(context, searchWorkerRoute,
                                  arguments: routeArg);
                            },
                            icon: const Icon(Icons.search),
                            padding: const EdgeInsets.all(16.0),
                          ),
                        ],
                      ),
                      floatingActionButton: FloatingActionButton(
                        tooltip: 'أقرب عامل',
                        onPressed: () async {
                          await _cubit.distanceCalculation(
                            _cubit.usersFilterList,
                          );
                          Navigator.pushNamed(
                            context,
                            nearbyRoute,
                          );
                        },
                        child: const Icon(Icons.location_searching_rounded),
                      ),
                      drawer: DrawerWidget(
                        cubit: _cubit,
                      ),
                      body: workerBuilder(context, _cubit.usersList, _cubit,
                          _cubit.usersFilterList)),
                ),
              ));
        },
      );
    });
  }
}

Widget buildWorkerItem(context, UserModel worker, CareerCubit _cubit) =>
    InkWell(
      onTap: () async {
        await _cubit.filterUser(worker.name!);
        await _cubit.locationFunction();
        await _cubit.getPicturesJob();
        Navigator.pushNamed(context, detailRoute);
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: worker.image!,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                  width: 100,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: SizedBox(
                height: 120.0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${worker.name}',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            worker.rating!.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

Widget workerBuilder(
    context, List wList, CareerCubit cCubit, List<UserModel> workerlist,
    {isSearch = false}) {
  return Conditional.single(
    context: context,
    conditionBuilder: (context) => workerlist.isNotEmpty,
    widgetBuilder: (context) => ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return buildWorkerItem(context, workerlist[index], cCubit);
      },
      itemCount: workerlist.length,
    ),
    fallbackBuilder: (context) => isSearch
        ? Container()
        : const Center(
            child: CircularProgressIndicator(),
          ),
  );
}
