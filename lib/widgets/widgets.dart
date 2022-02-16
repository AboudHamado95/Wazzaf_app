import 'package:flutter/material.dart';

Widget defaultButton(
        {double width = double.infinity,
        Color backgound = Colors.blue,
        bool isUpperCase = true,
        double radius = 3.0,
        required Function function,
        required String text}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: backgound,
          gradient: LinearGradient(colors: [
            Colors.amber,
            Colors.amber[200] as Color,
            Colors.amber[200] as Color,
            Colors.amber,
          ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
    );

Widget defaultFormFeild({
  required TextEditingController controller,
  required TextInputType type,
  required String returnValidate,
  Function? onSubmit,
  Function? onChanged,
  required String label,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
  Function? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (value) {
        if (value!.isEmpty) {
          return returnValidate;
        }
      },
      onFieldSubmitted: (text) {
        onSubmit!(text);
      },
      obscureText: isPassword,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: () {
                    suffixPressed!();
                  },
                  icon: Icon(suffix))
              : null,
          border: const OutlineInputBorder()),
    );

Widget defaultTextButton({
  required Function function,
  required String text,
  Color color = Colors.amber,
}) =>
    TextButton(
      onPressed: () {
        function();
      },
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold, fontSize: 15.0),
      ),
    );

Widget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        title: Text(title!),
        actions: actions!,
        titleSpacing: 5.0);

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Image getCareerImage(String image) {
  String path = 'assets/images/';
  String imageExtension = ".jpg";
  return Image.asset(
    path + image + imageExtension,
    width: 100.0,
    height: 100.0,
    fit: BoxFit.cover,
  );
}

Row customRowForDropDawn(String nameCareer) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(nameCareer),
      ],
    );
