import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/user_model.dart';
import 'package:wazzaf/screens/chat/chat_details.dart';
import 'package:wazzaf/widgets/widgets.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Builder(
        builder: (context) {
          return BlocConsumer<CareerCubit, CareerStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var _cubit = CareerCubit.get(context);
              return SafeArea(
                child: Scaffold(
                  appBar: AppBar(title: const Text('صفحة الدردشة')),
                  body: Conditional.single(
                      context: (context),
                      conditionBuilder: (context) => _cubit.users.isNotEmpty,
                      widgetBuilder: (context) => ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _cubit.users.length,
                            separatorBuilder: (context, index) => myDivider(),
                            itemBuilder: (context, index) => buildChatItem(
                                context, _cubit.users[index], _cubit),
                          ),
                      fallbackBuilder: (context) =>
                          const Center(child: CircularProgressIndicator())),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildChatItem(context, UserModel receiver, CareerCubit careerCubit) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ChatDetails(
              receiver: receiver, sender: careerCubit.userModel!);
        }),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(receiver.image!),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Text(
                receiver.name!,
                style: const TextStyle(height: 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
