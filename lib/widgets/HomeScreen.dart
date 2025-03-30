import 'package:bloc_todo_list/bloc/todo_bloc.dart';
import 'package:bloc_todo_list/entity/todo_model.dart';
import 'package:bloc_todo_list/widgets/AddTodoScreen.dart';
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
        child: BlocProvider(
          create: (BuildContext context) => TodoBloc(),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (BuildContext context, state) {
              return Column(
                children: [
                  _Search(),
                  _FilterDropdown(),
                  _CategoryDropdown(),
                  Expanded(
                    child: BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state.filteredTodos.isEmpty) {
                          return Center(child: Text("Немає завдань"));
                        }

                        return ListView.builder(
                          itemCount: state.filteredTodos.length,
                          itemBuilder: (context, index) {
                            return _TodoItem(
                              todo: state.filteredTodos[index],
                              index: index,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  FloatingActionButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTodoScreen(),
                          ),
                        ),
                    child: Icon(Icons.add),
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

class _FilterDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return DropdownButton<TodoFilter>(
            value: state.filter,
            onChanged: (filter) {
              if (filter != null) {
                context.read<TodoBloc>().add(SetFilter(filter));
              }
            },
            items: const [
              DropdownMenuItem(value: TodoFilter.all, child: Text("Всі")),
              DropdownMenuItem(
                value: TodoFilter.completed,
                child: Text("Виконані"),
              ),
              DropdownMenuItem(
                value: TodoFilter.pending,
                child: Text("Невиконані"),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  final Todo todo;
  final int index;

  const _TodoItem({super.key, required this.todo, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(15),
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
                todo.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 280, child: Text(todo.description, maxLines: 1)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<TodoBloc>().add(RemoveTodo(index));
            },
          ),
          IconButton(
            icon:
                todo.isDone
                    ? Icon(Icons.check_box, color: Colors.red)
                    : Icon(
                      Icons.check_box_outline_blank,
                      color: const Color.fromARGB(255, 53, 9, 215),
                    ),
            onPressed: () {
              context.read<TodoBloc>().add(ToggleTodoDone(index));
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return DropdownButton<String?>(
            value: state.categoryFilter,
            hint: Text("Оберіть категорію"),
            onChanged: (category) {
              context.read<TodoBloc>().add(SetCategoryFilter(category));
            },
            items: [
              DropdownMenuItem(value: null, child: Text("Всі категорії")),
              DropdownMenuItem(value: "Робота", child: Text("Робота")),
              DropdownMenuItem(
                value: "Саморозвиток",
                child: Text("Саморозвиток"),
              ),
              DropdownMenuItem(value: "Покупки", child: Text("Покупки")),
            ],
          );
        },
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
