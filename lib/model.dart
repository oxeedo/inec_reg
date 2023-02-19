import 'package:flutter/material.dart';

class Model {
  late String surName;
  late String todayDate;
  late String firstName;
  late String middleName;
  late String gprsCorrd;
  late String userName;

  Model(
      {required this.surName,
      required this.todayDate,
      required this.firstName,
      required this.gprsCorrd,
      required this.middleName,
      required this.userName});
}
