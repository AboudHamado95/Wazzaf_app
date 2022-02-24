import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wazzaf/cache/cache_helper.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';

import 'package:wazzaf/cubit/career/career_cubit.dart';

class DrawerWidget extends StatelessWidget {
  final CareerCubit cubit;
  const DrawerWidget({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[100],
      width: 255.0,
      child: Drawer(
        backgroundColor: Colors.amber[50],
        child: ListView(
          children: [
            Container(
              color: Colors.amber[100],
              height: 165.0,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.amber[100]),
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
  }
}
