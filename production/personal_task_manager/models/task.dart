class Task {
  final String title;
  final String description;
  final String category;
  final String priority;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    required this.isCompleted,
  });

  Task copyWith({
    String? title,
    String? description,
    String? category,
    String? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
