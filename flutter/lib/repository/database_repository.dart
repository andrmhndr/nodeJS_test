import 'dart:async';
import 'dart:convert';

import 'package:nodejs_test/model/activites_model.dart';
import 'package:nodejs_test/model/user_model.dart';
import 'package:http/http.dart' as http;

abstract class BaseDatabaseRepository {
  Future register(String email, String password);
  Future login(String email, String password);

  Stream<List<Activities>> get getActivitiesStream;
  Future<void> createActivities(Activities activities);
  Future<void> deleteActivities(String id);
  Future<void> updateActivities(Activities activities);
}

class DatabaseRepository extends BaseDatabaseRepository {
  final headers = {"Content-type": "application/json"};
  final url = 'http://localhost:3000';

  @override
  Future register(String email, String password) async {
    String body = '{"email": "$email", "password": "$password"}';

    try {
      http.Response response = await http.post(Uri.parse('$url/user/register'),
          body: body, headers: headers);
      return response.statusCode;
    } catch (err) {
      return err;
    }
  }

  @override
  Future<User> login(String email, String password) async {
    String body = '{"email": "$email", "password": "$password"}';

    try {
      http.Response response = await http.post(Uri.parse('$url/user/login'),
          body: body, headers: headers);
      var data = json.decode(response.body)['user'];
      return User.fromJson(data);
    } catch (err) {
      return User.empty();
    }
  }

  Future<List<Activities>> getActivities() async {
    try {
      http.Response response =
          await http.get(Uri.parse('$url/activities/'), headers: headers);

      List data = json.decode(response.body)['data'];
      List<Activities> activitiesList =
          data.map((item) => Activities.fromJson(item)).toList();

      return activitiesList;
    } catch (err) {
      return [];
    }
  }

  @override
  Stream<List<Activities>> get getActivitiesStream async* {
    yield await getActivities();
  }

  @override
  Future<void> deleteActivities(String id) async {
    try {
      http.Response response = await http
          .delete(Uri.parse('$url/activities/delete/$id'), headers: headers);
      var data = json.decode(response.body);
      print(data);
    } catch (err) {
      print(err);
    }
  }

  @override
  Future<void> createActivities(Activities activities) async {
    try {
      http.Response response = await http.post(
          Uri.parse('$url/activities/create'),
          body: activities.toJson(),
          headers: headers);

      var data = json.decode(response.body);
      print(response.body);
    } catch (err) {
      print(err);
    }
  }

  @override
  Future<void> updateActivities(Activities activities) async {
    try {
      http.Response response = await http.put(
          Uri.parse('$url/activities/update/${activities.id}'),
          body: activities.toJson(),
          headers: headers);

      var data = json.decode(response.body);
      print(response.body);
    } catch (err) {
      print(err);
    }
  }
}
