import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../entity/todo_model.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = "Робота";

  final List<String> categories = ["Робота", "Навчання", "Особисте"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Додати завдання")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Назва"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Опис"),
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items:
                  categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final todo = Todo(
                  title: titleController.text,
                  category: selectedCategory,
                  description: descriptionController.text,
                );
                context.read<TodoBloc>().add(AddTodo(todo));
                Navigator.pop(context);
              },
              child: Text("Додати"),
            ),
          ],
        ),
      ),
    );
  }
}
