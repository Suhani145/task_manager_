import 'package:flutter/material.dart';
import 'package:task_manager_assignment/data/models/network_response.dart';
import 'package:task_manager_assignment/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_assignment/data/models/task_model.dart';
import 'package:task_manager_assignment/data/network_caller/network_caller.dart';
import 'package:task_manager_assignment/data/utilities/urls.dart';
import 'package:task_manager_assignment/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager_assignment/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_assignment/ui/widgets/task_item.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});
  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTasksInProgress = false;
  List<TaskModel> cancelledTasks = [];
  @override
  void initState() {
    super.initState();
    _getCancelledTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _getCancelledTasks(),
        child: Visibility(
          visible: _getCancelledTasksInProgress == false,
          replacement: const CenterProgressIndicator(),
          child: ListView.builder(
            itemCount: cancelledTasks.length,
            itemBuilder: (context, index) {
              return TaskItem(
                taskModel: cancelledTasks[index],
                onUpdateTask: () {
                  _getCancelledTasks();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _getCancelledTasks() async {
    _getCancelledTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.cancelledTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      cancelledTasks = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Get cancelled tasks failed! Try again');
      }
    }
    _getCancelledTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}