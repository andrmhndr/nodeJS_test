import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:nodejs_test/bloc/activities/activities_bloc.dart';
import 'package:nodejs_test/bloc/user/user_bloc.dart';
import 'package:nodejs_test/model/activites_model.dart';
import 'package:nodejs_test/view/widgets/converter.dart';

class CreateActivitiesPage extends StatefulWidget {
  CreateActivitiesPage({super.key});

  @override
  State<CreateActivitiesPage> createState() => _CreateActivitiesPageState();
}

class _CreateActivitiesPageState extends State<CreateActivitiesPage> {
  final _formKey = GlobalKey<FormState>();

  final controllerName = TextEditingController();

  final controllerStartTime = TextEditingController();

  final controllerEndTime = TextEditingController();

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Activity')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Name*',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'nama tidak boleh kosong';
                  }
                  return null;
                },
                controller: controllerName,
                decoration: const InputDecoration(
                  hintText: 'activitiy name',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Start Time*',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: controllerStartTime,
                validator: (value) {
                  if (value == '') {
                    return 'start time tidak boleh kosong';
                  }
                  return null;
                },
                readOnly: true,
                onTap: () async {
                  final DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (newTime != null && newTime != DateTime.now()) {
                    startTime = newTime;
                  }
                  if (newDate != null && newDate != DateTime.now()) {
                    startDate = newDate;
                  }
                  setState(() {
                    controllerStartTime.text = Converter.dateFormat(
                        value: DateTime(startDate.year, startDate.month,
                            startDate.day, startTime.hour, startTime.minute));
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'start time',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'End Time*',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: controllerEndTime,
                validator: (value) {
                  if (value == '') {
                    return 'end time tidak boleh kosong';
                  }
                  return null;
                },
                readOnly: true,
                onTap: () async {
                  final DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (newTime != null) {
                    endTime = newTime;
                  }
                  if (newDate != null) {
                    endDate = newDate;
                  }
                  setState(() {
                    controllerEndTime.text = Converter.dateFormat(
                        value: DateTime(endDate.year, endDate.month,
                            endDate.day, endTime.hour, endTime.minute));
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'end time',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        var activities = Activities(
                            id: '',
                            name: controllerName.value.text,
                            startTime: DateTime(
                              startDate.year,
                              startDate.month,
                              startDate.day,
                              startTime.hour,
                              startTime.minute,
                            ),
                            endTime: DateTime(
                              endDate.year,
                              endDate.month,
                              endDate.day,
                              endTime.hour,
                              endTime.minute,
                            ),
                            email: state.user.email,
                            status: '');
                        context
                            .read<ActivitiesBloc>()
                            .add(ActivitiesCreate(activities: activities));
                        Get.back();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 45,
                      child: const Text('Create'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
