import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:wazzaf/cache/cache_helper.dart';
import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/login/login_cubit.dart';
import 'package:wazzaf/cubit/login/login_states.dart';
import 'package:wazzaf/cubit/register/register_cubit.dart';
import 'package:wazzaf/screens/main_screen.dart';
import 'package:wazzaf/widgets/widgets.dart';

class VertificationScreen extends StatelessWidget {
  VertificationScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginWithPhoneNumberSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = state.uId;
              navigateAndFinish(context, const MainScreen());
            });
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Spacer(),
                      defaultFormFeild(
                          controller: otpController,
                          type: TextInputType.number,
                          returnValidate: 'الرجاء إدخال رمز التأكيد!',
                          onSubmit: (text) {},
                          label: 'رمز التفعيل',
                          prefix: Icons.lock_open_outlined),
                      const SizedBox(
                        height: 16,
                      ),
                      Conditional.single(
                          context: context,
                          conditionBuilder: (context) {
                            return state is! LoginWithPhoneNumberLoadingState;
                          },
                          widgetBuilder: (context) => defaultButton(
                                function: () async {
                                  if (formKey.currentState!.validate()) {
                                    PhoneAuthCredential phoneAuth =
                                        await LoginCubit.get(context)
                                            .phoneAuthCredentialFunction(
                                                otpController.text);
                                    LoginCubit.get(context)
                                        .signInWithPhoneAuthCredential(
                                            phoneAuth);
                                  }
                                },
                                text: 'تأكيد الرمز',
                                isUpperCase: true,
                              ),
                          fallbackBuilder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              )),
                      const Spacer(),
                    ],
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
