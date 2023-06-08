// ignore_for_file: file_names, avoid_single_cascade_in_expression_statements
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:to_do_app/shared/cubit/cubit_cubit.dart';


class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  
  var scaffoldlKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      //creating database when creating cubit.
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {

          AppCubit cubit = BlocProvider.of(context);

          return Scaffold(
            key: scaffoldlKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              elevation: 0.0,
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text, 
                      date: dateController.text, 
                      time: timeController.text
                      );
                  }
                } else {
                  scaffoldlKey.currentState!.showBottomSheet((context) => Padding(
                    padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                          child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                      controller: titleController,
                                      keyboardType: TextInputType.text,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return "title must not be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Task title',
                                          prefixIcon: const Icon(Icons.title),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.0)))),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                      controller: timeController,
                                      keyboardType: TextInputType.text,
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text = (value!
                                              .format(context)
                                              .toString());
                                          print(value.format(context));
                                        });
                                      },
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return "time must not be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Task time',
                                          prefixIcon: const Icon(
                                              Icons.watch_later_outlined),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.0)))),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                      controller: dateController,
                                      keyboardType: TextInputType.text,
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2030))
                                            .then((value) {
                                          dateController.text =
                                              (DateFormat.yMMMd()
                                                  .format(value!));
                                          print(
                                              DateFormat.yMMMd().format(value));
                                        }).catchError((error) {
                                          print(
                                              "Error when selecting date ${error.toString()}");
                                        });
                                      },
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return "date must not be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Task date',
                                          prefixIcon: const Icon(
                                              Icons.calendar_month_outlined),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.0)))),
                                ],
                              ),
                      ),
                  ))
                      .closed.then((value) {
                        cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  //isBottomSheetShow = true;
                  // setState(() {
                  //   fabIcon=Icons.add;
                  // });
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 50.0,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived"),
              ],
            ),
          );
        },
      ),
    );
  }

  
}
