part of 'activities_bloc.dart';

abstract class ActivitiesEvent extends Equatable {
  const ActivitiesEvent();

  @override
  List<Object> get props => [];
}

class ActivitiesLoad extends ActivitiesEvent {}

class ActivitiesUpdate extends ActivitiesEvent {
  final List<Activities> activitiesList;

  const ActivitiesUpdate({required this.activitiesList});

  @override
  List<Object> get props => [activitiesList];
}

class ActivitiesCreate extends ActivitiesEvent {
  final Activities activities;

  const ActivitiesCreate({required this.activities});

  @override
  List<Object> get props => [activities];
}

class ActivitiesDelete extends ActivitiesEvent {
  final String id;

  const ActivitiesDelete({required this.id});

  @override
  List<Object> get props => [id];
}

class ActivitiesUpdateItem extends ActivitiesEvent {
  final Activities activities;

  const ActivitiesUpdateItem({required this.activities});

  @override
  List<Object> get props => [activities];
}
