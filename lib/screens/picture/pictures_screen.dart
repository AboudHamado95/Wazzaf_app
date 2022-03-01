import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';
import 'package:flutter/material.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/picture_model.dart';
import 'package:wazzaf/styles/colors/colors.dart';
import 'package:wazzaf/widgets/widgets.dart';

class PicturesScreen extends StatelessWidget {
  const PicturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<CareerCubit, CareerStates>(
        listener: ((context, state) {}),
        builder: (context, state) {
          var _cubit = CareerCubit.get(context);
         
          return SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: defaultAppBar(
                  context: context,
                  title: 'نماذج',
                  actions: [
                    if (_cubit.userModel!.isAdmin! ||
                        _cubit.userModel!.uId == _cubit.filterUserModel!.uId!)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: IconButton(
                          onPressed: () => navigateTo(context, addPictureRoute),
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          color: defaultColor,
                        ),
                      ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2.8,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1),
                  itemCount: _cubit.picturesList.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return itemList(
                        context, _cubit.picturesList[index], _cubit);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget itemList(context, PictureModel pictureModel, CareerCubit _cubit) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(4.0),
    child: Card(
      color: Colors.amber[100],
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, viewPictureRoute,
            arguments: pictureModel.image!),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: CachedNetworkImage(
                imageUrl: pictureModel.image!,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
                width: 150,
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
