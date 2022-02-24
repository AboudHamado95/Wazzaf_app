import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/screens/career/view_careers_screen.dart';

// ignore: must_be_immutable
class SearchCareerScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = CareerCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: TextFormField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _cubit.getCareerSearch(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى تعبئة الحقل!';
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
                    child: careerBuilder(context, _cubit.searchCareers, _cubit,
                        isSearch: true))
              ],
            ),
          ),
        );
      },
    );
  }
}
