import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:wazzaf/cache/cache_helper.dart';

import 'package:wazzaf/components/components.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/login/login_cubit.dart';
import 'package:wazzaf/cubit/login/login_states.dart';

import 'package:wazzaf/widgets/widgets.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          showToast(message: state.error, state: ToastStates.ERROR);
        }
        if (state is LoginSuccessState) {
          CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
            uId = state.uId;

            navigateAndFinish(context, mainRoute);
          });
        }
      },
      builder: (context, state) {
        var _cubit = LoginCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.amber[100],
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '?????????? ????????????',
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.black),
                          ),
                          Text(
                            '???????? ?????????? ???? ???????? ???????????? ????????????????!',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 30.0),
                          defaultFormFeild(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              returnValidate: '???????????? ?????????? ??????????????!',
                              onSubmit: (text) {},
                              label: '??????????????',
                              prefix: Icons.email_outlined),
                          const SizedBox(height: 15.0),
                          defaultFormFeild(
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              suffix: LoginCubit.get(context).suffix,
                              isPassword: LoginCubit.get(context).isPassword,
                              suffixPressed: () {
                                LoginCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              onSubmit: (text) {},
                              returnValidate: "???????? ???????? ?????????? ??????",
                              label: '???????? ????????',
                              prefix: Icons.lock_outline),
                          const SizedBox(height: 30.0),
                          Conditional.single(
                              context: context,
                              conditionBuilder: (context) {
                                return state is! LoginLoadingState;
                              },
                              widgetBuilder: (context) => defaultButton(
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                        LoginCubit.get(context)
                                            .userLoginWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                      }
                                    },
                                    text: '????????????',
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
                                  '???? ???????? ??????????',
                                ),
                                defaultTextButton(
                                    function: () {
                                      navigateAndFinish(context, registerRoute);
                                    },
                                    text: '????????'),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '???????????? ?????? ????????????',
                                ),
                                IconButton(
                                  onPressed: () async {
                                    navigateTo(context, phoneRoute);
                                  },
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Colors.amber,
                                  ),
                                ),
                              ]),
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
    );
  }
}
