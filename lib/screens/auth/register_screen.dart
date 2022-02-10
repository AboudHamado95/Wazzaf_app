import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:wazzaf/cache/cache_helper.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/register/register_cubit.dart';
import 'package:wazzaf/cubit/register/register_states.dart';
import 'package:wazzaf/widgets/widgets.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is CreateUserSuccessState) {
          CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
            uId = state.uId;
            navigateAndFinish(context, mainRoute);
          });
        }
      },
      builder: (context, state) {
        var _cubit = RegisterCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'التسجيل',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.black),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'صاحب مهنة؟',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Switch(
                                  value: RegisterCubit.get(context).literal,
                                  onChanged: (value) {
                                    RegisterCubit.get(context)
                                        .changeCareerVisibility();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        defaultFormFeild(
                            controller: nameController,
                            type: TextInputType.name,
                            returnValidate: 'الرجاء إدخال الاسم',
                            label: 'الاسم الثلاثي',
                            prefix: Icons.person,
                            onSubmit: (text) {}),
                        const SizedBox(height: 15.0),
                        defaultFormFeild(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            returnValidate: 'الرجاء إدخال الإيميل',
                            onSubmit: (text) {},
                            label: 'الإيميل',
                            prefix: Icons.email),
                        const SizedBox(height: 15.0),
                        defaultFormFeild(
                            controller: phoneController,
                            type: TextInputType.phone,
                            returnValidate: 'الرجاء إدخال رقم الهاتف',
                            onSubmit: (text) {},
                            label: 'رقم الهاتف',
                            prefix: Icons.phone),
                        const SizedBox(height: 15.0),
                        defaultFormFeild(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: RegisterCubit.get(context).suffix,
                            isPassword: RegisterCubit.get(context).isPassword,
                            suffixPressed: () {
                              RegisterCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            onSubmit: (text) {},
                            returnValidate: "كلمة السر صغيرة جدا",
                            label: 'كلمة السر',
                            prefix: Icons.lock_outline),
                        const SizedBox(height: 15.0),
                        defaultFormFeild(
                            controller: cityController,
                            type: TextInputType.emailAddress,
                            returnValidate: 'الرجاء إدخال المدينة',
                            label: 'المدينة',
                            prefix: Icons.location_city,
                            onSubmit: (text) {}),
                        const SizedBox(height: 15.0),
                        if (RegisterCubit.get(context).literal)
                          Container(
                            height: 60.0,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(),
                            ),
                            child: DropDown<String>(
                              showUnderline: false,
                              isExpanded: true,
                              items: _cubit.careersList.map((element) {
                                return element.name!;
                              }).toList(),
                              icon: const Icon(Icons.expand_more,
                                  color: Colors.amber),
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
                        const SizedBox(height: 15.0),
                        Conditional.single(
                            context: context,
                            conditionBuilder: (context) {
                              return state is! RegisterLoadingState;
                            },
                            widgetBuilder: (context) => defaultButton(
                                  function: () {
                                    if (RegisterCubit.get(context).literal) {
                                      if (formKey.currentState!.validate()) {
                                        RegisterCubit.get(context).userRegister(
                                            name: nameController.text.trim(),
                                            email: emailController.text.trim(),
                                            phone: phoneController.text.trim(),
                                            password:
                                                passwordController.text.trim(),
                                            city: cityController.text.trim(),
                                            literal: _cubit.literalCheck!);
                                      }
                                    } else {
                                      if (formKey.currentState!.validate()) {
                                        RegisterCubit.get(context).userRegister(
                                            name: nameController.text.trim(),
                                            email: emailController.text.trim(),
                                            password:
                                                passwordController.text.trim(),
                                            phone: phoneController.text.trim(),
                                            city: cityController.text.trim());
                                      }
                                    }
                                  },
                                  text: 'سجل ',
                                  isUpperCase: true,
                                ),
                            fallbackBuilder: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                )),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'تملك حساب بالفعل؟',
                            ),
                            defaultTextButton(
                                function: () {
                                  navigateAndFinish(context, loginRoute);
                                },
                                text: 'الدخول'),
                          ],
                        ),
                      ],
                    ),
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
