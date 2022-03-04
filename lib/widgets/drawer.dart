import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/cache/cache_helper.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';

import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/screens/chat/chat_details.dart';

class DrawerWidget extends StatelessWidget {
  final CareerCubit cubit;
  const DrawerWidget({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<CareerCubit, CareerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var _cubit = CareerCubit.get(context);
          return Container(
            color: Colors.amber,
            width: 255.0,
            child: Drawer(
              backgroundColor: _cubit.isDark
                  ? Theme.of(context).primaryColor
                  : Colors.amber[100],
              child: ListView(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    height: 165.0,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.7)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ClipOval(
                                child: CircleAvatar(
                                  radius: 32.0,
                                  child: CachedNetworkImage(
                                    imageUrl: cubit.userModel!.image!,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.error)),
                                    width: 65,
                                    height: 65.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                cubit.userModel!.name!,
                                style: const TextStyle(
                                    fontSize: 16.0, fontFamily: 'Brand Bold'),
                              ),
                              const SizedBox(height: 8.0),
                              Text(cubit.userModel!.email!),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.message_rounded),
                    title: const Text(
                      'صفحة الدردشة',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onTap: () async {
                      await CareerCubit.get(context).getUsersForChat();
                      navigateTo(context, chatsRoute);
                    },
                  ),
                  // ListTile(
                  //   leading: const Icon(Icons.edit),
                  //   title: const Text(
                  //     'البيانات الشخصية',
                  //     style: TextStyle(fontSize: 16.0),
                  //   ),
                  //   onTap: () async {
                  //     await _cubit.getCareers();
                  //     Navigator.pushNamed(context, updateUserDataRoute,
                  //         arguments: _cubit.careersList);
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.dark_mode_outlined,
                  //     color: Colors.purpleAccent[900],
                  //   ),
                  //   title: const Text(
                  //     'الوضع الليلي',
                  //     style: TextStyle(fontSize: 16.0),
                  //   ),
                  //   onTap: () {
                  //     CareerCubit.get(context).changeAppMode();
                  //   },
                  // ),
                  if(_cubit.userModel!.name != 'إدارة التطبيق')
                  ListTile(
                    leading: Icon(
                      Icons.question_answer_outlined,
                      color: Colors.purpleAccent[900],
                    ),
                    title: const Text(
                      'الاستفسارات والملاحظات',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChatDetails(
                                receiver: _cubit.usersList
                                    .where((element) =>
                                        element.name == 'إدارة التطبيق')
                                    .first,
                                sender: _cubit.userModel!);
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text(
                      'حول التطبيق',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      navigateTo(context, aboutRoute);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    onTap: () {
                      Navigator.of(context).pop();
                      CacheHelper.signOut(context);
                    },
                    title: const Text(
                      'خروج',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
