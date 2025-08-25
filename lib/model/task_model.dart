class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority;
  bool isCompleted;
  final String userId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
    required this.userId,
  });

  // Convert Task object to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }

  // Create Task object from Map (from Firestore)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'] ?? 'low',
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'] ?? '',
    );
  }
}