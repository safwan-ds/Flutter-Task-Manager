class Task {
  final int? id;
  final String title;
  final String description;
  bool isCompleted;
  final DateTime? dueDate;
  final DateTime createdAt;
  final int? categoryId;
  final int? priority;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.dueDate,
    required this.createdAt,
    this.categoryId,
    this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "isCompleted": isCompleted ? 1 : 0,
      "dueDate": dueDate?.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
      "category_id": categoryId,
      "priority": priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      isCompleted: map["isCompleted"] == 1,
      dueDate: map["dueDate"] != null ? DateTime.parse(map["dueDate"]) : null,
      createdAt: DateTime.parse(map["createdAt"]),
      categoryId: map["category_id"],
      priority: map["priority"],
    );
  }
}
