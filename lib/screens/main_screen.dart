import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/screens/add_career_screen.dart';
import 'package:wazzaf/screens/career_screen.dart';
import 'dart:ui' as ui;

import 'package:wazzaf/widgets/widgets.dart';

List careerList = ['نجارة', 'سباكة', 'بلاطة', 'حدادة', 'دهانة', 'الكهرباء'];
List imageList = [
  'nijara',
  'sibaka',
  'bilata',
  'hidada',
  'dihana',
  'electricity'
];

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit,CareerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Column(
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
                              top: 32.0, left: 32.0, right: 32.0, bottom: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.add_to_photos_rounded),
                              const SizedBox(
                                width: 12.0,
                              ),
                              defaultTextButton(
                                  function: () => navigateTo(
                                        context,
                                        AddCareerScreen(),
                                      ),
                                  text: 'إضافة مهنة جديدة',
                                  color: Colors.black)
                            ],
                          ),
                        ),
                        // const SizedBox(
                        //   height: 18.0,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: searchFormfield(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2.8,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1),
                      itemCount: careerList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return buildArticleItem(context, careerList,
                            careerList[index], imageList[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

Image getCareerImage(String image) {
  String path = 'assets/images/';
  String imageExtension = ".jpg";
  return Image.asset(
    path + image + imageExtension,
    width: 100.0,
    height: 100.0,
    fit: BoxFit.cover,
  );
}

Widget searchFormfield() {
  return Container(
    child: TextFormField(
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
  );
}

Widget buildArticleItem(context, List article, nameCareer, imageCareer) =>
    InkWell(
      onTap: () {
        navigateTo(context, const CareerScreen());
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
                  child: getCareerImage(imageCareer)),
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
                  '$nameCareer',
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
