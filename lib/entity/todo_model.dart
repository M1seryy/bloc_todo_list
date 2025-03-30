import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Todo extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String category;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool isDone;

  Todo({
    required this.title,
    required this.category,
    required this.description,
    this.isDone = false,
  });

  // 🎯 Методи для конвертації в JSON
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
