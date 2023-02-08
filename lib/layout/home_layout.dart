import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              centerTitle: true,
            ),
            body:
                state is AppGetDatabaseLoadingState ? Center(child: CircularProgressIndicator()) :
                cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formkey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);

                    // insertToDatabase(
                    //         title: titleController.text,
                    //         date: dateController.text,
                    //         time: timeController.text)
                    //     .then((value) => {
                    //           getDataFromDatabase(database).then((value) => {
                    //                 Navigator.pop(context),
                    //                 // setState(() {
                    //                 //   isBottomSheetShown = false;
                    //                 //   fabicon = Icons.edit;
                    //                 //   tasks = value;
                    //                 // }),
                    //               }),
                    //         });
                  }
                } else {
                  scaffoldkey.currentState!
                      .showBottomSheet(
                          (context) => Container(
                                color: Colors.grey[100],
                                padding: EdgeInsets.all(20.0),
                                child: Form(
                                  key: formkey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: titleController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'title must not be empty';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Task Title',
                                          prefixIcon: Icon(
                                            Icons.title,
                                          ),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      TextFormField(
                                        controller: timeController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'time must not be empty';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) =>
                                                  timeController.text = value!
                                                      .format(context)
                                                      .toString());
                                        },
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Task Time',
                                          prefixIcon:
                                              Icon(Icons.watch_later_outlined),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      TextFormField(
                                        controller: dateController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'date must not be empty';
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2025-12-30'),
                                          ).then((value) => {
                                                dateController.text =
                                                    DateFormat.yMMMd()
                                                        .format(value!),
                                              });
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Task Date',
                                          prefixIcon:
                                              Icon(Icons.calendar_today),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20.0)
                      .closed
                      .then((value) => {
                            cubit.changeBottomSheetState(
                                isShow: false, icon: Icons.edit)
                            // isBottomSheetShown = false;
                            // setState(() {
                            //   fabicon = Icons.edit;
                            // }),
                          });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  // isBottomSheetShown = true;
                  // setState(() {
                  //   fabicon = Icons.add;
                  // });
                }
              },
              child: Icon(
                cubit.fabicon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: "Archived",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
