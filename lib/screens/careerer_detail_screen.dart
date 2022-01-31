import 'package:flutter/material.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/screens/location.dart';
import 'package:wazzaf/screens/main_screen.dart';
import 'dart:ui' as ui;

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber[100],
            title: Text('تفاصيل العامل'),
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
                              child: getCareerImage('omal'),
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
                          navigateTo(context, const Location());
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
                customContainer('ضرار مدحت قدحنون'),
                customContainer('0999454676'),
                customContainer('مقديشو'),
                customContainer('حداد'),
                ElevatedButton(
                  onPressed: () {},
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
    );
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
}
