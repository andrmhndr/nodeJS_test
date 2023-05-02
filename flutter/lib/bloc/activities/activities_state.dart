part of 'activities_bloc.dart';

abstract class ActivitiesState extends Equatable {
  const ActivitiesState();

  @override
  List<Object> get props => [];
}

class ActivitiesLoading extends ActivitiesState {}

class ActivitiesLoaded extends ActivitiesState {
  final List<Activities> activitiesList;
  final String status;

  const ActivitiesLoaded({
    this.status = '',
    this.activitiesList = const <Activities>[],
  });

  @override
  List<Object> get props => [status, activitiesList];
}
