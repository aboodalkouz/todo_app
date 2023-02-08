import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).donetasks;

        return tasks.length < 1
            ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.menu,
                      size: 100.0,
                      color: Colors.grey,
                    ),
                    Text(
                      'NO Tasks Yet, Please Add Some Tasks',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
            )
            : ListView.separated(
                itemBuilder: (context, index) => Dismissible(
                  key: Key(tasks[index]['id'].toString()),
                  onDismissed: (direction) {
                    AppCubit.get(context).deleteData(id: tasks[index]['id']);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          child: Text(tasks[index]['time'].toString()),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tasks[index]['title'].toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                tasks[index]['date'].toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        IconButton(
                          onPressed: () {
                            AppCubit.get(context).updateData(
                                status: 'done', id: tasks[index]['id']);
                          },
                          icon: Icon(
                            Icons.check_box,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            AppCubit.get(context).updateData(
                                status: 'archive', id: tasks[index]['id']);
                          },
                          icon: Icon(
                            Icons.archive,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 20.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
                itemCount: tasks.length,
              );
      },
    );
  }
}
