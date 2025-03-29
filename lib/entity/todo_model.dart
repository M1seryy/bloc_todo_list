import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  final String title;
  final String category;
  final String description;
  final bool isDone;

  Todo({
    required this.title,
    required this.category,
    required this.description,
    this.isDone = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
