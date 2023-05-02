import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nodejs_test/model/activites_model.dart';
import 'package:nodejs_test/repository/database_repository.dart';

part 'activities_event.dart';
part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final DatabaseRepository _databaseRepository;

  ActivitiesBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(ActivitiesLoading()) {
    on<ActivitiesLoad>(_onActivitiesLoad);
    on<ActivitiesUpdate>(_onActivitiesUpdate);
    on<ActivitiesDelete>(_onActivitiesDelete);
    on<ActivitiesCreate>(_onActivitiesCreate);
    on<ActivitiesUpdateItem>(_onActivitiesUpdateItem);
  }

  Future<void> _onActivitiesUpdateItem(
      ActivitiesUpdateItem event, Emitter<ActivitiesState> emit) async {
    await _databaseRepository.updateActivities(event.activities);
    add(ActivitiesLoad());
  }

  Future<void> _onActivitiesCreate(
      ActivitiesCreate event, Emitter<ActivitiesState> emit) async {
    await _databaseRepository.createActivities(event.activities);
    add(ActivitiesLoad());
  }

  Future<void> _onActivitiesDelete(
      ActivitiesDelete event, Emitter<ActivitiesState> emit) async {
    await _databaseRepository.deleteActivities(event.id);
    add(ActivitiesLoad());
  }

  void _onActivitiesLoad(
      ActivitiesLoad event, Emitter<ActivitiesState> emit) async {
    add(ActivitiesUpdate(
        activitiesList: await _databaseRepository.getActivities()));
  }

  void _onActivitiesUpdate(
      ActivitiesUpdate event, Emitter<ActivitiesState> emit) {
    emit(ActivitiesLoaded(activitiesList: event.activitiesList));
  }
}
