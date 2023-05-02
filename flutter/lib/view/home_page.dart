import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:nodejs_test/bloc/activities/activities_bloc.dart';
import 'package:nodejs_test/bloc/user/user_bloc.dart';
import 'package:nodejs_test/route/route_name.dart';
import 'package:nodejs_test/view/update_activities.dart';
import 'package:nodejs_test/view/widgets/converter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ActivitiesBloc>().add(ActivitiesLoad());
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              context.read<UserBloc>().add(const UserLogout());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocConsumer<ActivitiesBloc, ActivitiesState>(
        listener: (context, state) {
          if (state is ActivitiesLoaded) {}
        },
        builder: (context, state) {
          if (state is ActivitiesLoaded) {
            return ListView.separated(
              itemCount: state.activitiesList.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Get.to(UpdateActivitiesPage(
                          activities: state.activitiesList[index]));
                    },
                    title: Text(state.activitiesList[index].name),
                    subtitle: Text(state.activitiesList[index].email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Mulai: ${Converter.dateFormat(value: state.activitiesList[index].startTime)}'),
                            Text(
                                'Selesai: ${Converter.dateFormat(value: state.activitiesList[index].endTime)}'),
                            Text(
                                'Status: ${state.activitiesList[index].status}'),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              context.read<ActivitiesBloc>().add(
                                  ActivitiesDelete(
                                      id: state.activitiesList[index].id));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) {
                return SizedBox(
                  height: 5,
                );
              },
            );
          } else if (state is ActivitiesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text('something wrong'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteName.goCreateActivities);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
