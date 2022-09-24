import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../shared/components/constants.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDataToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: color,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                cubit.titels[cubit.currentIndex],
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataFromDatabaseLoadingState,
              builder: (context) => cubit.screen[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: backGroundColor,
              unselectedItemColor: iconsColor,
              backgroundColor: color,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              elevation: 0.0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.task,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archied',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
