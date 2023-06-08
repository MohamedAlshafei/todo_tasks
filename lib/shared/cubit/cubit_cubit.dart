// ignore_for_file: avoid_print


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/archived_task_screen.dart';
import '../../models/done_task_screen.dart';
import '../../models/new_task_screen.dart';

part 'cubit_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  //object of cubit
  static AppCubit get(context)=> BlocProvider.of(context);


  int currentIndex=0;
  late Database database;
  var returnedVl;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;
  
  List<Widget> screens=const[
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen()
  ];
  List<String> titles=const[
    'New Task',
    'Done Task',
    'Archived Task'
  ];

  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
      openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
      print('Database Created');
      database
          .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('table Created');
      }).catchError((error) {
        print('Eror on creating database ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database opend');
    }).then((value){
      database=value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String date,
      required String time})  async{
    return await database.transaction((txn) async {
      txn.rawInsert(
            'INSERT INTO Tasks(title, date, time, status) VALUES("$title","$date", " $time", "new")')
          .then((value) {
            print("$value inserted successfully");
            emit(AppInsertDatabaseState());
            getDataFromDatabase(database);
          }).catchError((error) {
            print('error when inserting to database ${error.toString()}');
          });
          return returnedVl;
    });
  }

  void getDataFromDatabase(database) {

    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value) {

      

      value.forEach((element){
        if(element['status'] == 'new'){
          newTasks.add(element);
        }
        else if(element['status'] == 'done'){
          doneTasks.add(element);
        }else{
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({required String status, required int id}) async{
    database.rawUpdate(
    'UPDATE Tasks SET status = ? WHERE id = ?',
    [status, id,]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({required int id})async{
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}){
    isBottomSheetShow=isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }

}
