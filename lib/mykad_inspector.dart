library mykad_inspector;

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'model/MyKadInfo.dart';
import 'model/MyKardUserAgeInfo.dart';

class MyKadInspector {
  Future<MyKadInfo?> extractICDetails(String icNumber) async {
    // example 950130-03-5947
    MyKadInfo? myKadInfo;
    // remove "-"
    String sanitizedIC = icNumber.replaceAll('-', '');

    // check ic format length
    // check ic format contain numbers only
    if (sanitizedIC.length != 12 || !(RegExp(r'^\d+$').hasMatch(sanitizedIC))) {
      return myKadInfo;
    }

    // reformat ic number
    String substringICNumberDOB = sanitizedIC.substring(0, 6);
    String substringICNumberPOB = sanitizedIC.substring(6, 8);
    String substringICnumberGender = sanitizedIC.substring(11, 12);

    // check DOB correct
    MyKadUserAgeInfo mykadUserAgeInfo =
        _findICNumberDOB(substringICNumberDOB);
    // check gender
    String gender = _findICNumberGender(int.parse(substringICnumberGender));

    // check place of birth
    String placeOfBirth = await _findICNumberPOB(substringICNumberPOB);

    myKadInfo = MyKadInfo(
        icNumber: sanitizedIC,
        formattedIcNumber: _reformatICNumber(sanitizedIC),
        dateOfBirth: mykadUserAgeInfo.dateOfBirth,
        age: mykadUserAgeInfo.age,
        placeOfBirth: placeOfBirth,
        gender: gender);
    return myKadInfo;
  }

  // load place_of_birth.json
  Future<Map<String, String>> _loadICLocations() async {
    final String response =
        await rootBundle.loadString('assets/place_of_birth.json');
    final Map<String, dynamic> data = json.decode(response);
    return data.map((key, value) => MapEntry(key, value.toString()));
  }

  // find 4 digits year with 2 digits year from ic number
  MyKadUserAgeInfo _findICNumberDOB(String dateOfBirthString) {
    final reformatYear = int.parse(dateOfBirthString.substring(0, 2));
    final reformatMonth = int.parse(dateOfBirthString.substring(2, 4));
    final reformatDay = int.parse(dateOfBirthString.substring(4, 6));
    int currentAge = 0;

    DateTime now = new DateTime.now();

    int _20_minus = now.year - (2000 + reformatYear);
    int _19_minus = now.year - (1900 + reformatYear);

    // Malaysia over 11 years old only can register for IC
    if (_20_minus > 0 && _20_minus < 12) {
      currentAge = _19_minus;
    } else if (_20_minus > 0) {
      currentAge = _20_minus;
    } else {
      currentAge = _19_minus;
    }

    int getReformatYear = now.year - currentAge;

    DateTime dob = DateTime(getReformatYear, reformatMonth,reformatDay);

    return MyKadUserAgeInfo(age: currentAge, dateOfBirth: dob);
  }

  // odd number = male, even number = female
  String _findICNumberGender(int number) {
    if (number % 2 == 0) {
      // female/F
      return "F";
    } else {
      // male/M
      return "M";
    }
  }

  // find place of birth
  Future<String> _findICNumberPOB(String number) async {
    Map<String, String> locations = await _loadICLocations();
    String location = locations[number] ?? 'not found';
    return location;
  }

  // convert ic number from xxxxxxxxxxxx to xxxxxx-xx-xxxx
  String _reformatICNumber(String ic_number) {
    String reformatICNumber = ic_number;

    if (ic_number.length == 12) {
      reformatICNumber = reformatICNumber.substring(0, 6) +
          "-" +
          reformatICNumber.substring(6, 8) +
          "-" +
          reformatICNumber.substring(8, 12);
    }

    return reformatICNumber;
  }
}
