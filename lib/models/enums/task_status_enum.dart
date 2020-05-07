enum TaskStatus { open, taken, onApprove, closed }

extension TaskStatusExtension on TaskStatus {
  String get name {
    switch (this) {
      case TaskStatus.open:
        return "Открыта";
        break;

      case TaskStatus.taken:
        return "Взята";
        break;

      case TaskStatus.onApprove:
        return "на Проверке";
        break;

      case TaskStatus.closed:
        return "Закрыта";
        break;
      default:
        return null;
    }
  }

  double get range {
    return TaskStatus.values.length as double;
  }
}
