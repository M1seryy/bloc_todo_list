import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  final String title;
  final String category;
  final String description;

  Todo({
    required this.title,
    required this.category,
    required this.description,
  });

  // Десеріалізація (з JSON в модель)
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  // Серіалізація (з моделі в JSON)
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
