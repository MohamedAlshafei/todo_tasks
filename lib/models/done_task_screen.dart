
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/components/components.dart';
import 'package:to_do_app/shared/cubit/cubit_cubit.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<AppCubit,AppState>(
      builder: (context, state){

        var tasks= AppCubit.get(context).doneTasks;

        return taskBuilder(
          tasks: tasks
        );
      }
      );
  }
}