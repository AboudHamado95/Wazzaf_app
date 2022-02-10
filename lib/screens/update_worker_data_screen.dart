// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/career_model.dart';
import 'package:wazzaf/models/worker_model.dart';
import 'package:wazzaf/widgets/show_dialog.dart';
import 'package:wazzaf/widgets/widgets.dart';

class UpdateDataScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController literalController = TextEditingController();
  showDialogToWorkersDetails(context, CareerCubit cubit) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const ProgressDialog(message: 'الرجاء الانتظار');
        });
    await cubit.updateWorker(
        id: cubit.filterWorkerModel!.uId!,
        name: nameController.text.trim(),
        email: cubit.filterWorkerModel!.email!,
        image: cubit.filterWorkerModel!.image!,
        phone: phoneController.text.trim(),
        city: cityController.text.trim(),
        literal: literalController.text.trim(),
        isAdmin: cubit.filterWorkerModel!.isAdmin!);
  }

  showDialogToWorkersDetailsAndImage(context, CareerCubit cubit) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const ProgressDialog(message: 'الرجاء الانتظار');
        });
    await cubit.uploadWorkerImage(
        id: cubit.filterWorkerModel!.uId!,
        name: nameController.text.trim(),
        email: cubit.filterWorkerModel!.email!,
        phone: phoneController.text.trim(),
        city: cityController.text.trim(),
        literal: literalController.text.trim(),
        isAdmin: cubit.filterWorkerModel!.isAdmin!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(
      listener: (context, state) {
        if (state is FilterWorkerSuccessState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        var _cubit = CareerCubit.get(context);
        nameController.text = _cubit.filterWorkerModel!.name!;
        phoneController.text = _cubit.filterWorkerModel!.phone!;
        cityController.text = _cubit.filterWorkerModel!.city!;
        literalController.text = _cubit.filterWorkerModel!.literal!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: defaultAppBar(
                context: context,
                title: 'البيانات الشخصية',
                actions: [
                  defaultTextButton(
                      function: () async {
                        _cubit.workerImage == null
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
                                  child: _cubit.workerImage == null
                                      ? CircleAvatar(
                                          radius: 60.0,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(60.0),
                                            child: CachedNetworkImage(
                                              imageUrl: _cubit
                                                  .filterWorkerModel!.image!,
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
                                              FileImage(_cubit.workerImage!)),
                                ),
                                Align(
                                  heightFactor: 0.5,
                                  child: IconButton(
                                    onPressed: () => _cubit.getWokerImage(),
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
                    if (_cubit.workerImage != null)
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
                    defaultFormFeild(
                      controller: literalController,
                      type: TextInputType.name,
                      returnValidate: 'الرجاء إدخال المهنة',
                      label: 'المهنة',
                      prefix: Icons.work_rounded,
                      onSubmit: (text) {},
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
