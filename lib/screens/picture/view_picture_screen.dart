import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';

class ViewPicturesScreen extends StatelessWidget {
  const ViewPicturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<CareerCubit, CareerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final routeArg = ModalRoute.of(context)?.settings.arguments as String;

          return SafeArea(
            child: Scaffold(
                appBar: AppBar(),
                body: CachedNetworkImage(
                  imageUrl: routeArg,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                  width: double.infinity,
                  fit: BoxFit.cover,
                )),
          );
        },
      ),
    );
  }
}
