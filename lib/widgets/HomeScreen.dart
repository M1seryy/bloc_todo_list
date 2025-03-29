import 'package:bloc_todo_list/bloc/todo_bloc.dart';
import 'package:bloc_todo_list/entity/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List")),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: BlocProvider<TodoBloc>(
          create: (BuildContext context) => TodoBloc(),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (BuildContext context, state) {
              return Column(
                children: [
                  _Search(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _Todo_item(title: state.todos[index].title);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Todo_item extends StatelessWidget {
  final String title;
  const _Todo_item({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.all(
          Radius.circular(15), //                 <--- border radius here
        ),
      ),
      width: double.infinity,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text("Short description"),
            ],
          ),
          Icon(Icons.delete),
        ],
      ),
    );
  }
}

class _Search extends StatelessWidget {
  const _Search({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
