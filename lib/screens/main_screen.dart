import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/career_model.dart';

import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wazzaf/widgets/show_dialog.dart';
import 'package:wazzaf/widgets/widgets.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = CareerCubit.get(context);

        return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Conditional.single(
                context: context,
                conditionBuilder: (context) => _cubit.userModel != null,
                widgetBuilder: (context) {
                  return Column(
                    children: [
                      Container(
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32.0,
                                  left: 32.0,
                                  right: 32.0,
                                  bottom: 16.0),
                              child: Column(
                                children: [
                                  if (_cubit.userModel!.isAdmin!)
                                    Row(
                                      children: [
                                        const Icon(Icons.add_to_photos_rounded),
                                        const SizedBox(
                                          width: 12.0,
                                        ),
                                        defaultTextButton(
                                            function: () => navigateTo(
                                                  context,
                                                  addCareerRoute,
                                                ),
                                            text: 'إضافة مهنة جديدة',
                                            color: Colors.black)
                                      ],
                                    ),
                                  if (!_cubit.userModel!.isAdmin!)
                                    const SizedBox(
                                      height: 46.0,
                                      width: double.infinity,
                                    )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32.0, left: 32.0, right: 32.0),
                              child: searchFormfield(context, _cubit),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child:
                            careerBuilder(context, _cubit.careersList, _cubit),
                      ),
                    ],
                  );
                },
                fallbackBuilder: (context) {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ));
      },
    );
  }
}

Widget careerBuilder(context, List cList, CareerCubit cCubit,
    {isSearch = false}) {
  return Conditional.single(
    context: context,
    conditionBuilder: (context) => cList.isNotEmpty,
    widgetBuilder: (context) => GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2.8,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      itemCount: cList.length,
      itemBuilder: (BuildContext ctx, index) {
        return buildCareerItem(context, cList[index], cCubit);
      },
    ),
    fallbackBuilder: (context) => isSearch
        ? Container()
        : const Center(
            child: CircularProgressIndicator(),
          ),
  );
}

Widget searchFormfield(context, CareerCubit cCubit) {
  return Stack(
    children: [
      TextFormField(
        textDirection: ui.TextDirection.rtl,
        textAlignVertical: TextAlignVertical.top,
        cursorColor: Colors.amber,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'بحث',
          contentPadding: const EdgeInsets.only(left: 0.0, top: 10.0),
          fillColor: Colors.white54,
          filled: true,
          border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide.none),
        ),
      ),
      InkWell(
          onTap: () async {
            navigateTo(context, searchCareerRoute);
          },
          child: const SizedBox(
            height: 48.0,
            width: double.infinity,
          )),
    ],
  );
}

void showDialogToWorkers(
    context, CareerModel career, CareerCubit cubit, route) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const ProgressDialog(message: 'الرجاء الانتظار');
      });
  await cubit.getUserData();
  await cubit.filterWorkers(career.name!);
  Navigator.of(context).pop();
  Navigator.pushNamed(context, route);
}

Widget buildCareerItem(context, CareerModel career, CareerCubit cubit) {
  return InkWell(
    onTap: () async {
      showDialogToWorkers(context, career, cubit, workersRoute);
    },
    borderRadius: BorderRadius.circular(16.0),
    child: Padding(
      padding: const EdgeInsets.all(14.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              width: 250,
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: CachedNetworkImage(
                imageUrl: career.image!,
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
          Positioned(
            bottom: 4.0,
            right: 4.0,
            child: Container(
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.black12,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
              child: Text(
                '${career.name}',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
