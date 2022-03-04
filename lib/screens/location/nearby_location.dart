import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wazzaf/constants/constants.dart';

import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/models/user_model.dart';
import 'package:wazzaf/screens/users/workers_screen.dart';

class NearbyLocation extends StatelessWidget {
  final CareerCubit cubit;
  const NearbyLocation({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: const Text('أقرب عامل'),
          ),
          body: buildNearbyWorkerItem(context, cubit.destinationlist[0], cubit),
        ),
      ),
    );
  }

  Widget buildNearbyWorkerItem(
          context, UserModel worker, CareerCubit careerCubit) =>
      InkWell(
        onTap: () async {
          await careerCubit.filterUser(worker.name!);
          await careerCubit.locationFunction();
          await careerCubit.getPicturesJob();
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
                      //  Text('${worker.distance}')
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
