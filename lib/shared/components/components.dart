import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/components/constants.dart';
import 'package:todoapp/shared/cubit/cubit.dart';

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
      style: TextStyle(color: iconsColor),
      validator: validateFunction,
      keyboardType: textInputType,
      controller: controller,
      onTap: functionOnTap,
      obscureText: obscureText,
      onFieldSubmitted: functionOnFieldSubmitted,
      onChanged: functionOnChanged,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: iconsColor),
        prefixIcon: Icon(prefixIcon, color: iconsColor),
        labelText: labelText,
        fillColor: iconsColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(raduis!),
          borderSide: BorderSide(
            color: iconsColor!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(raduis),
          borderSide: BorderSide(
            color: iconsColor!,
            width: 2.0,
          ),
        ),
      ),
    );

Widget defaultTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteDataFromDatabase(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 40.0,
            child: Text(
              '${model['time']}',
              style: TextStyle(color: iconsColor, fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    color: iconsColor,
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
          ),
          SizedBox(
            width: 20.0,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  AppCubit.get(context).updateDataInDatabase(
                    status: 'done',
                    id: model['id'],
                  );
                },
                icon: Icon(
                  Icons.check_circle_outline,
                  color: iconsColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  AppCubit.get(context).updateDataInDatabase(
                    status: 'archive',
                    id: model['id'],
                  );
                },
                icon: Icon(
                  Icons.archive_outlined,
                  color: iconsColor,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget tasksBuilder({
  @required List<Map>? tasks,
}) {
  return ConditionalBuilder(
    condition: tasks!.length > 0,
    builder: (context) => ListView.separated(
      itemBuilder: (context, index) => defaultTaskItem(tasks[index], context),
      separatorBuilder: (context, index) => Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
      itemCount: tasks.length,
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            color: Colors.white60,
            size: 100,
          ),
          Text(
            'No Tasks Yet , Please Add Some Tasks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    ),
  );
}
