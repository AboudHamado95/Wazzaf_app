import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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
          child: SafeArea(
            child: Scaffold(
               backgroundColor: Colors.amber[100],
              appBar: AppBar(
                backgroundColor: Colors.amber,
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntlPhoneField(
                            textAlign: TextAlign.start,
                            searchText: '???????? ???? ????????????',
                            decoration: const InputDecoration(
                              labelText: '?????? ????????????',
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
                          const SizedBox(height: 15.0),
                          Conditional.single(
                              context: context,
                              conditionBuilder: (context) {
                                return state is! LoginWithPhoneNumberLoadingState;
                              },
                              widgetBuilder: (context) => defaultButton(
                                    function: () async {
                                      if (_cubit.phoneAuth != null) {
                                        if (formKey.currentState!.validate()) {
                                          bool phoneUser;
                                          phoneUser = _cubit.usersList.any(
                                              (element) =>
                                                  element.phone ==
                                                  _cubit.phoneAuth);
          
                                          if (phoneUser) {
                                            _cubit.getUser(_cubit.phoneAuth!);
                                            LoginCubit.get(context)
                                                .userLoginWithPhoneNumber(
                                                    phoneNumber:
                                                        _cubit.phoneAuth!);
                                          } else {
                                            showToast(
                                                message: '?????????? ?????? ??????????',
                                                state: ToastStates.ERROR);
                                          }
                                        }
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
                                text: '????????',
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
          ),
        );
      },
    );
  }
}
