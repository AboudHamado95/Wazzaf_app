import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/constants/constants.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/screens/users/workers_screen.dart';

// ignore: must_be_immutable
class SearchWorkerScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final routeArg = ModalRoute.of(context)?.settings.arguments as String;
          var _cubit = CareerCubit.get(context);

          Future<bool> _onWillPop() async {
            await Navigator.of(context).pushNamedAndRemoveUntil(
                workersRoute, (route) => false,
                arguments: routeArg);
            return true;
          }

          return WillPopScope(
            onWillPop: _onWillPop,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0.0,
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: IconButton(
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                              context, workersRoute, (route) => false,
                              arguments: routeArg),
                          icon: const Icon(Icons.arrow_back)),
                    ),
                  ),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: TextFormField(
                            controller: searchController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) async {
                              await _cubit.getUserSearch(
                                  name: value, nameCareer: routeArg);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'يرجى تعبئة الحقل';
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'بحث',
                              prefixIcon: const Icon(Icons.search),
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: workerBuilder(context, _cubit.searchUser, _cubit,
                            _cubit.searchUser,
                            isSearch: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
