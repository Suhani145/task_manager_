import 'package:flutter/material.dart';
import 'package:task_manager_assignment/data/models/network_response.dart';
import 'package:task_manager_assignment/data/models/task_model.dart';
import 'package:task_manager_assignment/data/network_caller/network_caller.dart';
import 'package:task_manager_assignment/data/utilities/urls.dart';
import 'package:task_manager_assignment/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager_assignment/ui/widgets/snack_bar_message.dart';
class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.taskModel,
    required this.onUpdateTask,
  });

  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteInProgress = false;
  bool _editInProgress = false;
  String dropdownValue = '';
  List<String> statusList = [
    'New',
    'Progress',
    'Completed',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        title: Text(widget.taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.description ?? ''),
            Text(
              'Date: ${widget.taskModel.createdDate}',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(widget.taskModel.status ?? 'New'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
                ButtonBar(
                  children: [
                    Visibility(
                      visible: _deleteInProgress == false,
                      replacement: const CenterProgressIndicator(),
                      child: IconButton(
                        onPressed: () {
                          _deleteTask();
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                    Visibility(
                      visible: _editInProgress == false,
                      replacement: const CenterProgressIndicator(),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.edit),
                        onSelected: (String selectedValue) async {
                          setState(() {
                            _editInProgress = true;
                          });
                          await _updateTaskStatus(selectedValue);
                          setState(() {
                            _editInProgress = false;
                            dropdownValue = selectedValue;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return statusList.map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child: ListTile(
                                title: Text(value),
                                trailing: dropdownValue == value
                                    ? const Icon(Icons.done)
                                    : null,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    _deleteInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.deleteTask(widget.taskModel.sId!));

    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Get task count by status failed! Try again',
        );
      }
    }
    _deleteInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _updateTaskStatus(String newStatus) async {
    String url = '';
    switch (newStatus) {
      case 'Progress':
        url = Urls.progressStatus(widget.taskModel.sId!);
        break;
      case 'Completed':
        url = Urls.completedStatus(widget.taskModel.sId!);
        break;
      case 'Cancelled':
        url = Urls.cancelledStatus(widget.taskModel.sId!);
        break;
      default:
        return;
    }

    NetworkResponse response = await NetworkCaller.getRequest(url);
    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Update task status failed! Try again');
      }
    }
  }
}