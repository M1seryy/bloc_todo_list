import 'package:bloc_todo_list/entity/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum TodoFilter { all, completed, pending } //task status types

//test data for developing
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

class SetCategoryFilter extends TodoEvent {
  final String? category;
  SetCategoryFilter(this.category);
}

class LoadTodos extends TodoEvent {}

class TodoState {
  final List<Todo> todos;
  final TodoFilter filter;
  final String? categoryFilter;

  TodoState({
    required this.todos,
    this.filter = TodoFilter.all,
    this.categoryFilter,
  });

  List<Todo> get filteredTodos {
    List<Todo> filtered = todos;

    //status filtering
    switch (filter) {
      case TodoFilter.completed:
        filtered = filtered.where((todo) => todo.isDone).toList();
        break;
      case TodoFilter.pending:
        filtered = filtered.where((todo) => !todo.isDone).toList();
        break;
      case TodoFilter.all:
    }

    // category filter
    if (categoryFilter != null && categoryFilter!.isNotEmpty) {
      filtered =
          filtered.where((todo) => todo.category == categoryFilter).toList();
    }

    return filtered;
  }
}

//bloc
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  late Box<Todo> todoBox;

  TodoBloc() : super(TodoState(todos: [])) {
    _initHive();
    on<SetFilter>((event, emit) {
      emit(
        TodoState(
          todos: state.todos,
          filter: event.filter,
          categoryFilter: state.categoryFilter,
        ),
      );
    });
    on<SetCategoryFilter>((event, emit) {
      emit(
        TodoState(
          todos: state.todos,
          filter: state.filter,
          categoryFilter: event.category,
        ),
      );
    });

    on<AddTodo>((event, emit) {
      todoBox.add(event.todo); // hive add
      emit(TodoState(todos: todoBox.values.toList()));
    });

    on<RemoveTodo>((event, emit) {
      todoBox.deleteAt(event.index); //hive delete
      emit(TodoState(todos: todoBox.values.toList()));
    });

    on<ToggleTodoDone>((event, emit) {
      final todo = todoBox.getAt(event.index);
      if (todo != null) {
        todo.isDone = !todo.isDone;
        todo.save();
        emit(TodoState(todos: todoBox.values.toList()));
      }
    });

    on<LoadTodos>((event, emit) {
      emit(TodoState(todos: todoBox.values.toList()));
    });
  }

  Future<void> _initHive() async {
    todoBox = await Hive.openBox<Todo>('todos');
    add(LoadTodos());
  }

  void loadTodos() {
    add(LoadTodos());
  }
}
