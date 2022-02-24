import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:wazzaf/cache/cache_helper.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/register/register_cubit.dart';
import 'package:wazzaf/cubit/register/register_states.dart';
import 'package:wazzaf/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  void locatePoistion(RegisterCubit reCubit) async {
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
    reCubit.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit()..getCareers(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
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
            child: SafeArea(
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
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
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
            
                            // defaultFormFeild(
                            //     controller: phoneController,
                            //     type: TextInputType.phone,
                            //     returnValidate: 'الرجاء إدخال رقم الهاتف',
                            //     onSubmit: (text) {},
                            //     label: 'رقم الهاتف',
                            //     prefix: Icons.phone),
                            // const SizedBox(height: 15.0),
            
                            const SizedBox(height: 15.0),
                            IntlPhoneField(
                              textAlign: TextAlign.start,
                              searchText: 'ابحث عن الدولة',
                              decoration: const InputDecoration(
                                labelText: 'رقم الهاتف',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                              initialCountryCode: 'IN',
                              onChanged: (phone) {
                                _cubit.phoneAuth = phone.completeNumber;
                                print(phone.completeNumber);
                              },
                            ),
                            defaultFormFeild(
                                controller: cityController,
                                type: TextInputType.emailAddress,
                                returnValidate: 'الرجاء إدخال المدينة',
                                label: 'المدينة',
                                prefix: Icons.location_city,
                                onSubmit: (text) {}),
                            const SizedBox(height: 15.0),
                            if (RegisterCubit.get(context).literal)
                              Column(
                                children: [
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
                                      customWidgets:
                                          _cubit.careersList.map((element) {
                                        return customRowForDropDawn(
                                            element.name!);
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
                                ],
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
                            ),
                            const SizedBox(height: 15.0),
                            Conditional.single(
                                context: context,
                                conditionBuilder: (context) {
                                  return state is! RegisterLoadingState;
                                },
                                widgetBuilder: (context) => defaultButton(
                                      function: () {
                                        if ((_cubit.latitude == null &&
                                                _cubit.longitude == null) &&
                                            _cubit.phoneAuth != null) {
                                          showToast(
                                              message: 'يرجى تحديد الموقع',
                                              state: ToastStates.WARNING);
                                        } else {
                                          if (formKey.currentState!.validate()) {
                                            if (RegisterCubit.get(context)
                                                .literal) {
                                              RegisterCubit.get(context)
                                                  .userRegister(
                                                      name: nameController.text
                                                          .trim(),
                                                      email: emailController.text
                                                          .trim(),
                                                      phone: _cubit.phoneAuth!,
                                                      password: passwordController
                                                          .text
                                                          .trim(),
                                                      city: cityController.text
                                                          .trim(),
                                                      lan: _cubit.longitude!,
                                                      lat: _cubit.latitude!,
                                                      literal:
                                                          _cubit.literalCheck!);
                                            } else {
                                              RegisterCubit.get(context)
                                                  .userRegister(
                                                name: nameController.text.trim(),
                                                email:
                                                    emailController.text.trim(),
                                                password: passwordController.text
                                                    .trim(),
                                                phone: _cubit.phoneAuth!,
                                                city: cityController.text.trim(),
                                                lan: _cubit.longitude!,
                                                lat: _cubit.latitude!,
                                              );
                                            }
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
            ),
          );
        },
      ),
    );
  }
}
