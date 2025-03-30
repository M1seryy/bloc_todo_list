import 'package:bloc_todo_list/widgets/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_todo_list/bloc/todo_bloc.dart';
import 'package:bloc_todo_list/entity/todo_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); //hive init
  Hive.registerAdapter(TodoAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc()..loadTodos(), // loading hive data
      child: MaterialApp(home: Homescreen()),
    );
  }
}
