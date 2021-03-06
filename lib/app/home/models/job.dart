import 'package:flutter/material.dart';

class Job {
  Job({@required this.name,@required this.ratePerHour, @required this.id });

  final String name;
  final double ratePerHour;
  final String id;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if( data == null){
      return null;
    }
    final String name = data['name'];
    final double ratePerHour = data['ratePerHour'];
    return Job(name: name, ratePerHour: ratePerHour, id: documentId);
  }

  Map<String, dynamic> toMap(){
    return {
      'name':name,
      'ratePerHour': ratePerHour
    };
  }
}