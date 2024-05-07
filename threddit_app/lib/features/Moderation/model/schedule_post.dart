// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
class SchedulePostModel {
  String? date;
  String? time;
  String? title;
  String? body;
  DateTime? realDate;
  TimeOfDay? realTime;
  
  SchedulePostModel({
    this.date,
    this.time,
    this.title,
    this.body,
    this.realDate,
    this.realTime
  });

  SchedulePostModel copyWith({
    String? date,
    String? time,
    String? title,
    String? body,
    DateTime? realDate,
    TimeOfDay? realTime
  }) {
    return SchedulePostModel(
      date: date ?? this.date,
      time: time ?? this.time,
      title: title ?? this.title,
      body: body ?? this.body,
      realDate: realDate ?? this.realDate,
      realTime: realTime ?? this.realTime,
    );
  }

  Map<String?, dynamic> toMap() {
    return <String?, dynamic>{
      'date': date,
      'time': time,
      'title': title,
      'body': body,
    };
  }

  factory SchedulePostModel.fromMap(Map<String, dynamic> map) {
    return SchedulePostModel(
      date: map['date'] != null ? map['date'] as String : null,
      time: map['time'] != null ? map['time'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SchedulePostModel.fromJson(String source) => SchedulePostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SchedulePostModel(date: $date, time: $time, title: $title, body: $body)';
  }

  @override
  bool operator ==(covariant SchedulePostModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.date == date &&
      other.time == time &&
      other.title == title &&
      other.body == body;
  }

  @override
  int get hashCode {
    return date.hashCode ^
      time.hashCode ^
      title.hashCode ^
      body.hashCode;
  }
}
