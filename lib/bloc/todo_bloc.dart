import 'package:bloc_todo_list/entity/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//initial state
//try to move on server
enum TodoFilter { all, completed, pending }

final List<Todo> initialTodos = [
  Todo(
    title: "Купити молоко",
    category: "Покупки",
    description: "Купити 2 літри молока в супермаркеті",
    isDone: false,
  ),
  Todo(
    title: "Прочитати книгу",
    category: "Саморозвиток",
    description: "Дочитати розділ 5 книги 'Чистий код'",
    isDone: false,
  ),
  Todo(
    title: "Пробіжка в парку",
    category: "Спорт",
    description: "Вранці пробігти 5 км у місцевому парку",
    isDone: false,
  ),
  Todo(
    title: "Написати статтю",
    category: "Робота",
    description: "Написати чернетку нової статті для блогу",
    isDone: true,
  ),
  Todo(
    title: "Зателефонувати мамі",
    category: "Сім'я",
    description: "Запитати, як справи та домовитися про зустріч",
    isDone: false,
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

class SetFilter extends TodoEvent {
  final TodoFilter filter;
  SetFilter(this.filter);
}

class ToggleTodoDone extends TodoEvent {
  final int index;
  ToggleTodoDone(this.index);
}

class TodoState {
  final List<Todo> todos;
  final TodoFilter filter;

  TodoState({required this.todos, this.filter = TodoFilter.all});

  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.completed:
        return todos.where((todo) => todo.isDone).toList();
      case TodoFilter.pending:
        return todos.where((todo) => !todo.isDone).toList();
      case TodoFilter.all:
      default:
        return todos;
    }
  }
}

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState(todos: initialTodos)) {
    on<AddTodo>((event, emit) {
      final updatedTodos = List<Todo>.from(state.todos)..add(event.todo);
      emit(TodoState(todos: updatedTodos, filter: state.filter));
    });

    on<RemoveTodo>((event, emit) {
      final updatedTodos = List<Todo>.from(state.todos)..removeAt(event.index);
      emit(TodoState(todos: updatedTodos, filter: state.filter));
    });

    on<ToggleTodoDone>((event, emit) {
      final updatedTodos = List<Todo>.from(state.todos);
      updatedTodos[event.index] = Todo(
        title: updatedTodos[event.index].title,
        category: updatedTodos[event.index].category,
        description: updatedTodos[event.index].description,
        isDone: !updatedTodos[event.index].isDone,
      );
      emit(TodoState(todos: updatedTodos, filter: state.filter));
    });

    on<SetFilter>((event, emit) {
      emit(TodoState(todos: state.todos, filter: event.filter));
    });
  }
}
