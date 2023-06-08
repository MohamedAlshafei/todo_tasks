import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit_cubit.dart';


Widget buildTaskItem(Map model,context){
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (dismissed){
      AppCubit.get(context).deleteData(id: model['id']);
    },
    child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(width: 15.0,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                const SizedBox(height: 5,),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey[800]
                    ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 15,),
            IconButton(
              onPressed: (){
                AppCubit.get(context).updateDatabase(status: 'done', id: model['id']);
              }, 
              icon: const Icon(Icons.check_box),
              color: Colors.green,
              ),
              IconButton(
                onPressed: (){
                  AppCubit.get(context).updateDatabase(status: 'archived', id: model['id']);
                }, 
                icon: const Icon(Icons.archive_outlined),
                color: Colors.black45,
                ),
          ],
        ),
      ),
  );
}

Widget taskBuilder({required List<Map> tasks}){
  return  ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (context)=>ListView.separated(
              itemBuilder: (context, index) {
                return buildTaskItem(tasks[index],context);
              },
              separatorBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.blueGrey[500],
                );
              },
              itemCount: tasks.length),
          fallback: (context){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu,size: 50, color: Colors.grey[700],),
                  Text(
                    'No tasks yet. add some tasks',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800]
                    ),
                  )
                  
                ],
              ),
            );
          },
        );
}