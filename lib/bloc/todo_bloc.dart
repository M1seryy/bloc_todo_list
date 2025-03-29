import 'package:bloc_todo_list/entity/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//initial state
//try to move on server
final List<Todo> initialTodos = [
  Todo(
    title: "Купити молоко",
    category: "Покупки",
    description: "Купити 2 літри молока в супермаркеті",
  ),
  Todo(
    title: "Прочитати книгу",
    category: "Саморозвиток",
    description: "Дочитати розділ 5 книги 'Чистий код'",
  ),
  Todo(
    title: "Пробіжка в парку",
    category: "Спорт",
    description: "Вранці пробігти 5 км у місцевому парку",
  ),
  Todo(
    title: "Написати статтю",
    category: "Робота",
    description: "Написати чернетку нової статті для блогу",
  ),
  Todo(
    title: "Зателефонувати мамі",
    category: "Сім'я",
    description: "Запитати, як справи та домовитися про зустріч",
  ),
];

abstract class TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;
  AddTodo(this.todo);
}

class RemoveTodo extends TodoEvent {
  final int index;
  RemoveTodo(this.index);
}

class TodoState {
  final List<Todo> todos;
  TodoState(this.todos);
}

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState(initialTodos)) {
    on<AddTodo>((event, emit) {
      final updatedTodos = List<Todo>.from(state.todos)..add(event.todo);
      emit(TodoState(updatedTodos));
    });

    on<RemoveTodo>((event, emit) {
      final updatedTodos = List<Todo>.from(state.todos)..removeAt(event.index);
      emit(TodoState(updatedTodos));
    });
  }
}
