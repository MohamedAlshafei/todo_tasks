import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/components.dart';
import '../shared/cubit/cubit_cubit.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        var tasks=AppCubit.get(context).newTasks;

        return taskBuilder(
          tasks: tasks
        );
        
          
      },
    );
  }
}
