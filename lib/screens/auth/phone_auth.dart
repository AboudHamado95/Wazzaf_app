import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:wazzaf/cache/cache_helper.dart';

import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/login/login_cubit.dart';
import 'package:wazzaf/cubit/login/login_states.dart';
import 'package:wazzaf/screens/auth/verification_screen.dart';
import 'package:wazzaf/widgets/widgets.dart';

// ignore: must_be_immutable
class PhoneAuth extends StatelessWidget {
  PhoneAuth({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  PhoneAuthCredential? phoneAuthCredential;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginWithPhoneNumberSuccessStateWithoutId) {
          navigateAndFinish(context, verificationRoute);
        }
        if (state is LoginWithPhoneNumberErrorState) {
          showToast(message: state.error, state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        var _cubit = LoginCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        defaultFormFeild(
                            controller: phoneController,
                            type: TextInputType.phone,
                            returnValidate: 'الرجاء إدخال الرقم!',
                            onSubmit: (text) {},
                            label: 'الرقم',
                            prefix: Icons.phone),
                        const SizedBox(height: 15.0),
                        Conditional.single(
                            context: context,
                            conditionBuilder: (context) {
                              return state is! LoginWithPhoneNumberLoadingState;
                            },
                            widgetBuilder: (context) => defaultButton(
                                  function: () async {
                                    if (formKey.currentState!.validate()) {
                                      bool phoneUser;
                                      bool phoneWorker;
                                      phoneUser = _cubit.usersList.any(
                                          (element) =>
                                              element.phone ==
                                              phoneController.text);
                                      phoneWorker = _cubit.workersList.any(
                                          (element) =>
                                              element.phone! ==
                                              phoneController.text);
                                      if (phoneUser) {
                                        // _cubit.getUser(
                                        //     phoneController.text.trim());
                                        LoginCubit.get(context)
                                            .userLoginWithPhoneNumber(
                                                phoneNumber:
                                                    phoneController.text);
                                      } else if (phoneWorker) {
                                        _cubit.getWorker(
                                            phoneController.text.trim());
                                        LoginCubit.get(context)
                                            .workerLoginWithPhoneNumber(
                                                phoneNumber:
                                                    phoneController.text);
                                      } else {
                                        showToast(
                                            message: 'الرقم غير موجود',
                                            state: ToastStates.ERROR);
                                      }
                                    }
                                  },
                                  text: 'الدخول',
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
                              'لا تملك حساب؟',
                            ),
                            defaultTextButton(
                              function: () {
                                navigateAndFinish(context, registerRoute);
                              },
                              text: 'سجّل',
                            ),
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
