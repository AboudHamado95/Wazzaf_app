import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:wazzaf/cache/cache_helper.dart';
import 'dart:ui' as ui;

import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/worker_model.dart';

class WorkersScreen extends StatelessWidget {
  const WorkersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = CareerCubit.get(context);
        Future<bool> _onWillPop() async {
          await Navigator.of(context)
              .pushNamedAndRemoveUntil(mainRoute, (route) => false);
          return true;
        }

        return WillPopScope(
          onWillPop: _onWillPop,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('العمال'),
                ),
                drawer: Drawer(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.logout_outlined),
                        onTap: () => CacheHelper.signOut(context),
                      )
                    ],
                  ),
                ),
                body: workerBuilder(context, _cubit.workersList, _cubit,
                    _cubit.workersFilterList!)),
          ),
        );
      },
    );
  }
}

Widget buildWorkerItem(context, WorkerModel worker) => InkWell(
      onTap: () {
        Navigator.pushNamed(context, detailRoute,
            arguments: {'literal': worker.literal!});
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
                // getCareerImage('omal'),
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
                  child: Text(
                    '${worker.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

Widget workerBuilder(
    context, List wList, CareerCubit cCubit, List<WorkerModel> workerlist,
    {isSearch = false}) {
  return Conditional.single(
    context: context,
    conditionBuilder: (context) => workerlist.isNotEmpty,
    widgetBuilder: (context) => ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return buildWorkerItem(context, workerlist[index]);
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
