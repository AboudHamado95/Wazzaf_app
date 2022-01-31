import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/screens/careerer_detail_screen.dart';
import 'package:wazzaf/screens/main_screen.dart';

class CareerScreen extends StatefulWidget {
  const CareerScreen({Key? key}) : super(key: key);

  @override
  _CareerScreenState createState() => _CareerScreenState();
}

List careerList = ['ضرار', 'ظافر', 'تيسير', 'زهير', 'تحسين', 'توفيق'];
List imageList = [
  'nijara',
  'sibaka',
  'bilata',
  'hidada',
  'dihana',
  'electricity'
];

class _CareerScreenState extends State<CareerScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('العمال'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return buildArticleItem(
                context, careerList, careerList[index], imageList[index]);
          },
          itemCount: careerList.length,
        ),
      ),
    );
  }

  
  }

  Widget buildArticleItem(context, List article, nameCareer, imageCareer) =>
      InkWell(
        onTap: () {
          navigateTo(context, const DetailScreen());
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
                  child: getCareerImage('omal'),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Container(
                  height: 120.0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$nameCareer',
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

