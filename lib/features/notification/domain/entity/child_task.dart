import 'package:equatable/equatable.dart';

class ChildTask extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final Duration estimatedDuration;
  final bool isCompleted;

  const ChildTask({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.estimatedDuration,
    this.isCompleted = false,
  });

  ChildTask copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    Duration? estimatedDuration,
    bool? isCompleted,
  }) {
    return ChildTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'estimatedDuration': estimatedDuration.inSeconds,
      'isCompleted': isCompleted,
    };
  }
  
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    deadline,
    estimatedDuration,
    isCompleted,
  ];
}