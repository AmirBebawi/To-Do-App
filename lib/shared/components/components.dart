import 'package:flutter/material.dart';

Widget defaultTextForm({
  @required validateFunction,
  @required TextInputType? textInputType,
  functionOnTap,
  bool obscureText = false,
  @required TextEditingController? controller,
  functionOnFieldSubmitted,
  functionOnChanged,
  @required IconData? prefixIcon,
  IconData? suffixIcon,
  @required String? labelText,
  @required double? raduis,
  suffixFuncion,
}) =>
    TextFormField(
      style: TextStyle(color: Colors.white),
      validator: validateFunction,
      keyboardType: textInputType,
      controller: controller,
      onTap: functionOnTap,
      obscureText: obscureText,
      onFieldSubmitted: functionOnFieldSubmitted,
      onChanged: functionOnChanged,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(prefixIcon ,color: Colors.white),
        labelText: labelText,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(raduis!),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(raduis),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
    );

Widget defaultTaskItem(Map model) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.amber,
          radius: 40.0,
          child: Text(
            '${model['time']}',
            style: TextStyle(
              color: Colors.white ,
              fontWeight: FontWeight.w900
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${model['title']}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '${model['date']}',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
