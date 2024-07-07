class Urls {
    static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
    static const String registration = '$_baseUrl/registration';
    static const String login = '$_baseUrl/login';
    static const String createTask = '$_baseUrl/createTask';
    static const String newTasks = '$_baseUrl/listTaskByStatus/New';
    static const String completedTasks = '$_baseUrl/listTaskByStatus/Completed';
    static const String taskStatusCount = '$_baseUrl/taskStatusCount';
    static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
    static String updateProfile = '$_baseUrl/profileUpdate';
    static String progressStatus(String id) => '$_baseUrl/updateTaskStatus/$id/progress';
    static String completedStatus(String id) => '$_baseUrl/updateTaskStatus/$id/completed';
    static String cancelledStatus(String id) => '$_baseUrl/updateTaskStatus/$id/cancelled';
    static String cancelledTasks = '$_baseUrl/listTaskByStatus/cancelled';
    static String completedTask = '$_baseUrl/listTaskByStatus/completed';
    static String progressTasks = '$_baseUrl/listTaskByStatus/progress';
  }