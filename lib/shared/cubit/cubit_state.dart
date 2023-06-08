part of 'cubit_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppChangeBottomNavBarState extends AppState{}

class AppCreateDatabaseState extends AppState{}

class AppInsertDatabaseState extends AppState{}

class AppGetDatabaseLoadingState extends AppState{}
class AppGetDatabaseState extends AppState{}
class AppUpdateDatabaseState extends AppState{}
class AppDeleteDatabaseState extends AppState{}
class AppChangeBottomSheetState extends AppState{}

