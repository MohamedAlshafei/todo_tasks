import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/components/components.dart';

import '../shared/cubit/cubit_cubit.dart';

class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        
        var tasks=AppCubit.get(context).archivedTasks;

        return taskBuilder(
          tasks: tasks
        );
      },
    );
  }
}