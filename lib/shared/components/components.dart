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
      validator: validateFunction,
      keyboardType: textInputType,
      controller: controller,
      onTap: functionOnTap,
      obscureText: obscureText,
      onFieldSubmitted: functionOnFieldSubmitted,
      onChanged: functionOnChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        suffix: suffixIcon != null
            ? IconButton(
                constraints: const BoxConstraints(maxHeight: 10, minHeight: 5),
                onPressed: suffixFuncion,
                icon: Icon(suffixIcon),
              )
            : null,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            raduis!,
          ),
        ),
      ),
    );




Widget defaultTaskItem (Map model)
{
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Text('${model['time']}'),
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
                fontSize: 18.0 ,
                fontWeight: FontWeight.bold ,
              ),
            ),
            Text(
              '${model['date']}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}