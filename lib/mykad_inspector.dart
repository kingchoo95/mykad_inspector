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
    MyKadUserAgeInfo mykadUserAgeInfo = _findICNumberDOB(substringICNumberDOB);
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
    final Map<String, dynamic> data = json.decode(_placeOfBirthJson);
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

    DateTime dob = DateTime(getReformatYear, reformatMonth, reformatDay);

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

  final String _placeOfBirthJson = '''{
    "00": "—",
    "01": "Johor",
    "02": "Kedah",
    "03": "Kelantan",
    "04": "Malacca",
    "05": "Negeri Sembilan",
    "06": "Pahang",
    "07": "Penang",
    "08": "Perak",
    "09": "Perlis",
    "10": "Selangor",
    "11": "Terengganu",
    "12": "Sabah",
    "13": "Sarawak",
    "14": "Federal Territory of Kuala Lumpur",
    "15": "Federal Territory of Labuan",
    "16": "Federal Territory of Putrajaya",
    "17": "—",
    "18": "—",
    "19": "—",
    "20": "—",
    "21": "Johor",
    "22": "Johor",
    "23": "Johor",
    "24": "Johor",
    "25": "Kedah",
    "26": "Kedah",
    "27": "Kedah",
    "28": "Kelantan",
    "29": "Kelantan",
    "30": "Malacca",
    "31": "Negeri Sembilan",
    "32": "Pahang",
    "33": "Pahang",
    "34": "Penang",
    "35": "Penang",
    "36": "Perak",
    "37": "Perak",
    "38": "Perak",
    "39": "Perak",
    "40": "Perlis",
    "41": "Selangor",
    "42": "Selangor",
    "43": "Selangor",
    "44": "Selangor",
    "45": "Terengganu",
    "46": "Terengganu",
    "47": "Sabah",
    "48": "Sabah",
    "49": "Sabah",
    "50": "Sarawak",
    "51": "Sarawak",
    "52": "Sarawak",
    "53": "Sarawak",
    "54": "Federal Territory of Kuala Lumpur",
    "55": "Federal Territory of Kuala Lumpur",
    "56": "Federal Territory of Kuala Lumpur",
    "57": "Federal Territory of Kuala Lumpur",
    "58": "Federal Territory of Labuan",
    "59": "Negeri Sembilan",
    "PB": "Place of birth (outside Malaysia / abroad)",
    "60": "Brunei",
    "61": "Indonesia",
    "62": "Cambodia / Democratic Kampuchea / Kampuchea",
    "63": "Laos",
    "64": "Myanmar",
    "65": "Philippines",
    "66": "Singapore",
    "67": "Thailand",
    "68": "Vietnam",
    "69": "—",
    "70": "—",
    "71": "A person born outside Malaysia prior to 2001",
    "72": "A person born outside Malaysia prior to 2001",
    "73": "—",
    "74": "China",
    "75": "India",
    "76": "Pakistan",
    "77": "Saudi Arabia",
    "78": "Sri Lanka",
    "79": "Bangladesh",
    "80": "—",
    "81": "—",
    "82": "Unknown state",
    "83": "Asia-Pacific",
    "84": "South America",
    "85": "Africa",
    "86": "Europe",
    "87": "Britain / Great Britain / Ireland",
    "88": "Middle East",
    "89": "Far East",
    "90": "Caribbean",
    "91": "North America",
    "92": "Soviet Union / USSR",
    "93": "Afghanistan / Andorra / Antarctica / Antigua and Barbuda / Azerbaijan / Benin / Bermuda / Bhutan / Bora Bora / Bouvet Island / British Indian Ocean Territory / Burkina Faso / Cape Verde / Cayman Islands / Comoros / Dahomey / Equatorial Guinea / Falkland Islands / French Southern Territories / Gibraltar / Guinea-Bissau / Hong Kong / Iceland / Ivory Coast / Kazakhstan / Kiribati / Kyrgyzstan / Lesotho / Libya / Liechtenstein / Macau / Madagascar / Maghribi / Malagasy / Maldives / Mauritius / Mongolia / Montserrat / Nauru / Nepal / Northern Marianas Islands / Outer Mongolia / Palau / Palestine / Pitcairn Islands / Saint Helena / Saint Lucia / Saint Vincent and the Grenadines / Samoa / San Marino / São Tomé and Príncipe / Seychelles / Solomon Islands / Svalbard and Jan Mayen Islands / Tajikistan / Turkmenistan / Tuvalu / Upper Volta / Uzbekistan / Vanuatu / Vatican City / Virgin Islands (British) / Western Samoa / Yugoslavia",
    "94": "—",
    "95": "—",
    "96": "—",
    "97": "—",
    "98": "Stateless / Stateless Person Article 1/1954",
    "99": "Mecca / Neutral Zone / No Information / Refugee / Refugee Article 1/1951 / United Nations Specialized Agency / United Nations Organization / Unspecified Nationality"
  }''';
}
