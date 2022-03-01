import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';
import 'package:wazzaf/models/message_model.dart';
import 'package:wazzaf/models/user_model.dart';
import 'package:wazzaf/styles/colors/colors.dart';

// ignore: must_be_immutable
class ChatDetails extends StatelessWidget {
  final UserModel receiver;
  final UserModel sender;

  ChatDetails({
    Key? key,
    required this.receiver,
    required this.sender,
  }) : super(key: key);
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Builder(
        builder: (context) {
          CareerCubit.get(context).getMessages(receivedId: receiver.uId!);
          return BlocConsumer<CareerCubit, CareerStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var _cubit = CareerCubit.get(context);
              return SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    titleSpacing: 0.0,
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(receiver.image!),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Text(receiver.name!),
                      ],
                    ),
                  ),
                  body: Conditional.single(
                    context: context,
                    conditionBuilder: (context) => true,
                    // _cubit.messages.isNotEmpty,
                    widgetBuilder: (context) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  var message =
                                      CareerCubit.get(context).messages[index];
                                  if (_cubit.userModel!.uId ==
                                      message.senderId) {
                                    return buildMessage(message);
                                  } else {
                                    return buildMyMessage(message);
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 15.0),
                                itemCount: _cubit.messages.length),
                          ),
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey[400]!, width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: messageController,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'أدخل الرسالة...'),
                                    ),
                                  ),
                                  Container(
                                    color: defaultColor,
                                    width: 50.0,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        await _cubit.sendMessage(
                                            receiver: receiver.name!,
                                            receivedId: receiver.uId!,
                                            dateTime: DateTime.now().toString(),
                                            text: messageController.text);
                                        messageController.clear();
                                      },
                                      child: const Icon(Icons.send,
                                          size: 16.0, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    fallbackBuilder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration:const BoxDecoration(
                color: Color.fromARGB(255, 6, 241, 17),
                borderRadius:  BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(10.0),
                    bottomStart: Radius.circular(10.0),
                    topEnd: Radius.circular(10.0))),
            child: Text(model.text!)),
      );
  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
                color: defaultColor.withOpacity(0.2),
                borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(10.0),
                    bottomStart: Radius.circular(10.0),
                    topStart: Radius.circular(10.0))),
            child: Text(model.text!)),
      );
}

class MyMessage extends StatelessWidget {
  MessageModel model;

  MyMessage({
    required this.model,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10.0),
                bottomEnd: Radius.circular(10.0),
                bottomStart: Radius.circular(10.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              model.text!,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
