import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String message;
  const ProgressDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.amber,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 32.0, bottom: 32.0, right: 4.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(width: 6.0),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
                const SizedBox(width: 12.0),
                Text(
                  message,
                  style: const TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ));
  }
}
