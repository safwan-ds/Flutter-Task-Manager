class Task {
  final int? id;
  final String title;
  final String description;
  bool isCompleted;
  final DateTime? dueDate;
  final DateTime createdAt;

  Task({
    this.id,
    required this.title,
    this.description = "",
    this.isCompleted = false,
    this.dueDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "isCompleted": isCompleted ? 1 : 0,
      "dueDate": dueDate?.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
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
    );
  }
}
