import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:nodejs_test/view/widgets/converter.dart';

class Activities extends Equatable {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String email;
  final String status;

  const Activities({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.email,
    required this.status,
  });

  factory Activities.fromJson(Map<String, dynamic> json) {
    return Activities(
        id: json['id'],
        name: json['name'],
        startTime: Converter.dateFromJson(json['startTime']),
        endTime: Converter.dateFromJson(json['endTime']),
        email: json['email'],
        status: json['status']);
  }

  toJson() {
    return '{"name": "$name", "startTime": "${startTime.year}-${Converter.digitFormat(startTime.month)}-${Converter.digitFormat(startTime.day)}T${Converter.digitFormat(startTime.hour)}:${Converter.digitFormat(startTime.minute)}:${Converter.digitFormat(startTime.second)}.00Z", "endTime" : "${endTime.year}-${Converter.digitFormat(endTime.month)}-${Converter.digitFormat(endTime.day)}T${Converter.digitFormat(endTime.hour)}:${Converter.digitFormat(endTime.minute)}:${Converter.digitFormat(endTime.second)}.00Z", "email" : "$email"}';
  }

  @override
  List<Object?> get props => [
        name,
        startTime,
        id,
        endTime,
        email,
        status,
      ];
}
