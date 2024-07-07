
import 'package:flutter/material.dart';
import 'package:task_manager_assignment/data/models/network_response.dart';
import 'package:task_manager_assignment/data/network_caller/network_caller.dart';
import 'package:task_manager_assignment/data/utilities/urls.dart';
import 'package:task_manager_assignment/ui/widgets/background_widget.dart';
import 'package:task_manager_assignment/ui/widgets/profile_app_bar.dart';
import 'package:task_manager_assignment/ui/widgets/snack_bar_message.dart';
import '../widgets/centered_progress_indicator.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false; //loader flag

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleTEController,
                    decoration: const InputDecoration(hintText: 'Title'),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter Title!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: 'Description'),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter Description!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: _addNewTaskInProgress == false,
                    replacement: const CenterProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addNewTasK();
                          }
                        },
                        child: const Icon(Icons.add_circle)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTasK() async {

    _addNewTaskInProgress = true;//loader on
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestData = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    };

    NetworkResponse response =
    await NetworkCaller.postRequest(Urls.createTask, body: requestData);

    _addNewTaskInProgress = false;//loader on
    if (mounted) {
      setState(() {});
    }

    if(response.isSuccess){
      _clearTextFields();
      if(mounted){
        showSnackBarMessage(context, 'New Task Added!');
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, 'Failed!Try Again',true);
      }
    }

  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();

  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}



















