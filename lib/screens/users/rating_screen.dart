import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/widgets/show_dialog.dart';

class RateScreen extends StatelessWidget {
  RateScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();

  final TextEditingController _ratingController =
      TextEditingController(text: '0.0');

  IconData? _selectedIcon;
  void showDialogToUpdateRating(context, CareerCubit cubit) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const ProgressDialog(message: 'الرجاء الانتظار');
        });
    await cubit.ratingModel(
        uId: cubit.filterUserModel!.uId!, rate: _ratingController.text);
    await cubit.filterUsers(cubit.filterUserModel!.literal);
    await cubit.filterUser(cubit.filterUserModel!.name!);
    await cubit.getUserForRating();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: ((context) {
        // CareerCubit.get(context).getUserForRating();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: BlocConsumer<CareerCubit, CareerStates>(
            listener: (context, state) {
              if (state is UpdateUserDataSuccessState) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              var rateCubit = CareerCubit.get(context);
              Future<bool> _onWillPop() async {
                await CareerCubit.get(context).getUserForRating();
                await Navigator.of(context)
                    .pushNamedAndRemoveUntil(detailRoute, (route) => true);

                return true;
              }

              return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('تقييم العامل'),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 160.0),
                        RatingBarIndicator(
                          rating: rateCubit.userRating,
                          itemBuilder: (context, index) => Icon(
                            _selectedIcon ?? Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 50.0,
                          unratedColor: Colors.amber.withAlpha(50),
                        ),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _ratingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'أدخل التقييم',
                                      labelText: 'أدخل التقييم',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'الرجاء أدخل التقييم';
                                      }
                                      return null;
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        showDialogToUpdateRating(
                                            context, rateCubit);
                                      }
                                    },
                                    child: const Text(
                                      'اضغط',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
