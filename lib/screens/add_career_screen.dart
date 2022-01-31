import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/widgets/widgets.dart';

class AddCareerScreen extends StatelessWidget {
  AddCareerScreen({Key? key}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(listener: (context, state) {
      if (state is AddCareerSuccessState) {
        showToast(message: 'تم إضافة المهنة بنجاح', state: ToastStates.SUCCESS);
        nameController.clear();
      }
    }, builder: (context, state) {
      var _cubit = CareerCubit.get(context);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: defaultAppBar(
              context: context,
              title: 'إضافة مهنة',
              actions: [
                defaultTextButton(
                    function: () async {
                      if (formKey.currentState!.validate()) {
                        if (_cubit.careerImage != null) {
                          _cubit.uploadCareerImage(text: nameController.text);
                        } else {
                          showToast(
                              message: 'الرجاء إدخال صورة المهنة',
                              state: ToastStates.WARNING);
                        }
                      }
                    },
                    text: 'إضافة',
                    color: Colors.black),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is AddCareerLoadingState ||
                    state is UploadimageCareerLoadingState)
                  const LinearProgressIndicator(),
                if (state is AddCareerLoadingState ||
                    state is UploadimageCareerLoadingState)
                  const SizedBox(
                    height: 10.0,
                  ),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال اسم المهنة';
                        }
                      },
                      onFieldSubmitted: (text) {},
                      decoration: const InputDecoration(
                          hintText: 'إضافة اسم المهنة ...'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                if (_cubit.careerImage != null)
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                            height: 200.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              image: DecorationImage(
                                  image: FileImage(_cubit.careerImage!),
                                  fit: BoxFit.cover),
                            )),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(top: 44.0),
                          child: IconButton(
                            onPressed: () => _cubit.removeCareerImage(),
                            icon: const CircleAvatar(
                              radius: 20.0,
                              child: Icon(
                                Icons.close,
                                size: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _cubit.getCareerImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('إضافة صورة المهنة'),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(Icons.photo),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
