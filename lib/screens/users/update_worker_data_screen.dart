// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/widgets/show_dialog.dart';
import 'package:wazzaf/widgets/widgets.dart';

class UpdateDataScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  void locatePoistion(CareerCubit cCubit) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }
    await cCubit.updateLocation();
  }

// 35.5083218
// 35.7882544
  showDialogToWorkersDetails(context, CareerCubit cubit) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const ProgressDialog(message: 'الرجاء الانتظار');
        });
    if (cubit.updateLat != null && cubit.updateLong != null) {
      await cubit.updateUser(
        id: cubit.filterUserModel!.uId!,
        name: nameController.text.trim(),
        image: cubit.filterUserModel!.image!,
        email: cubit.filterUserModel!.email!,
        phone: phoneController.text.trim(),
        city: cityController.text.trim(),
        literal: cubit.literalCheck ?? cubit.filterUserModel!.literal!,
        latitude: cubit.updateLat!,
        longitude: cubit.updateLong!,
        isAdmin: cubit.filterUserModel!.isAdmin!,
      );
    } else {
      await cubit.updateUser(
          id: cubit.filterUserModel!.uId!,
          name: nameController.text.trim(),
          email: cubit.filterUserModel!.email!,
          phone: phoneController.text.trim(),
          image: cubit.filterUserModel!.image!,
          city: cityController.text.trim(),
          literal: cubit.literalCheck ?? cubit.filterUserModel!.literal!,
          latitude: cubit.filterUserModel!.latitude!,
          longitude: cubit.filterUserModel!.longitude!,
          isAdmin: cubit.filterUserModel!.isAdmin!);
    }
  }

  showDialogToWorkersDetailsAndImage(context, CareerCubit cubit) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const ProgressDialog(message: 'الرجاء الانتظار');
        });
    if (cubit.updateLat != null && cubit.updateLong != null) {
      await cubit.uploadUserImage(
          id: cubit.filterUserModel!.uId!,
          name: nameController.text.trim(),
          email: cubit.filterUserModel!.email!,
          phone: phoneController.text.trim(),
          city: cityController.text.trim(),
          literal: cubit.literalCheck ?? cubit.filterUserModel!.literal!,
          latitude: cubit.updateLat,
          longitude: cubit.updateLong,
          isAdmin: cubit.filterUserModel!.isAdmin!);
    } else {
      await cubit.uploadUserImage(
          id: cubit.filterUserModel!.uId!,
          name: nameController.text.trim(),
          email: cubit.filterUserModel!.email!,
          phone: phoneController.text.trim(),
          city: cityController.text.trim(),
          literal: cubit.literalCheck ?? cubit.filterUserModel!.literal!,
          latitude: cubit.filterUserModel!.latitude,
          longitude: cubit.filterUserModel!.longitude,
          isAdmin: cubit.filterUserModel!.isAdmin!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(
      listener: (context, state) {
        if (state is UpdateUserDataSuccessState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        var _cubit = CareerCubit.get(context);

        // final routeArg = ModalRoute.of(context)?.settings.arguments as String;

        nameController.text = _cubit.filterUserModel!.name!;
        phoneController.text = _cubit.filterUserModel!.phone!;
        cityController.text = _cubit.filterUserModel!.city!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: defaultAppBar(
                  context: context,
                  title: 'البيانات الشخصية',
                  actions: [
                    defaultTextButton(
                        function: () async {
                          _cubit.userImage == null
                              ? showDialogToWorkersDetails(context, _cubit)
                              : null;
                        },
                        text: 'تحديث'),
                    const SizedBox(
                      width: 15.0,
                    )
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 190.0,
                        child: Stack(
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
                                    child: _cubit.userImage == null
                                        ? CircleAvatar(
                                            radius: 60.0,
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(60.0),
                                              child: CachedNetworkImage(
                                                imageUrl: _cubit
                                                    .filterUserModel!.image!,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Center(
                                                        child: Icon(Icons.error)),
                                                width: 100,
                                                height: 100.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ))
                                        : CircleAvatar(
                                            radius: 60.0,
                                            backgroundImage:
                                                FileImage(_cubit.userImage!)),
                                  ),
                                  Align(
                                    heightFactor: 0.5,
                                    child: IconButton(
                                      onPressed: () => _cubit.getUserImage(),
                                      icon: const CircleAvatar(
                                        radius: 20.0,
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      if (_cubit.userImage != null)
                        Row(
                          children: [
                            Expanded(
                                child: defaultButton(
                                    function: () {
                                      showDialogToWorkersDetailsAndImage(
                                          context, _cubit);
                                    },
                                    text: 'تحديث الصورة الشخصية')),
                            const SizedBox(
                              width: 5.0,
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormFeild(
                        controller: nameController,
                        type: TextInputType.name,
                        returnValidate: 'الرجاء إدخال الاسم',
                        label: 'الاسم',
                        prefix: Icons.person,
                        onSubmit: (text) {},
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultFormFeild(
                        controller: phoneController,
                        type: TextInputType.phone,
                        returnValidate: 'الرجاء إدخال رقم الهاتف',
                        label: 'الهاتف',
                        prefix: Icons.phone,
                        onSubmit: (text) {},
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultFormFeild(
                        controller: cityController,
                        type: TextInputType.text,
                        returnValidate: 'الرجاء إدخال المدينة',
                        label: 'المدينة',
                        prefix: Icons.location_city,
                        onSubmit: (text) {},
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 60.0,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(),
                        ),
                        child: DropDown<String>(
                          initialValue: _cubit.filterUserModel!.literal,
                          showUnderline: false,
                          isExpanded: true,
                          items: _cubit.careersList.map((element) {
                            return element.name!;
                          }).toList(),
                          icon:
                              const Icon(Icons.expand_more, color: Colors.amber),
                          customWidgets: _cubit.careersList.map((element) {
                            return customRowForDropDawn(element.name!);
                          }).toList(),
                          hint: Row(
                            children: const [
                              Icon(Icons.work, color: Colors.grey),
                              SizedBox(width: 8.0),
                              Text("اختر المهنة"),
                            ],
                          ),
                          onChanged: (value) {
                            _cubit.changeDropDown(value!);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 10.0),
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: defaultButton(
                                function: () => locatePoistion(_cubit),
                                text: 'حدد موقعك',
                                backgound: Colors.amber),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
