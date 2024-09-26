import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/notification/domain/entity/child_task.dart';

class ChildTaskModel extends ChildTask {
  const ChildTaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.deadline,
    required super.estimatedDuration,
    super.isCompleted,
  });

  ChildTaskModel.fromMap(DataMap map)
      : super(
    id: map['id'] as String,
    title: map['title'] as String,
    description: map['description'] as String,
    deadline: DateTime.parse(map['deadline'] as String),
    estimatedDuration: Duration(seconds: map['estimatedDuration'] as int),
    isCompleted: map['isCompleted'] as bool,
  );

  DataMap toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'estimatedDuration': estimatedDuration.inSeconds,
      'isCompleted': isCompleted,
    };
  }

  factory ChildTaskModel.fromEntity(ChildTask entity) {
    return ChildTaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      deadline: entity.deadline,
      estimatedDuration: entity.estimatedDuration,
      isCompleted: entity.isCompleted,
    );
  }
}