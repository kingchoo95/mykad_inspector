<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## MyKadInspector
MyKadInspector is a Dart/Flutter package designed to extract and analyze information from Malaysian identity card (MyKad) numbers. It provides details such as the date of birth, age, gender, and place of birth based on the MyKad number.

## Features
**Extract MyKad Information** Retrieve details such as date of birth, age, gender, and place of birth from a valid MyKad number.

**IC Number Formatting** Automatically format MyKad numbers to the standard xxxxxx-xx-xxxx format.

**Validation**  Validate MyKad numbers based on their structure and content.

**No internet connection required**

## Installing
You should add the following to your pubspec.yaml file:

dependencies:
    mykad_inspector: ^0.0.1

## Getting started

To start, import the dependency in your code:

    import 'package:mykad_inspector/mykad_inspector.dart';

Next, to get IC Number Information you can use the following code :

    void main() async {

        // Instantiate MyKadInspector object 
        final myKadInspector = MyKadInspector();

        // IC Number can format in xxxxxx-xx-xxxx or xxxxxxxxxxxx
        final myKadInfo = await myKadInspector.extractICDetails('950130-03-2947');

        if (myKadInfo != null) {
            print('Age: ${myKadInfo.age}');
            print('Date of Birth: ${myKadInfo.dateOfBirth}');
            print('Gender: ${myKadInfo.gender}');
            print('Place of Birth: ${myKadInfo.placeOfBirth}');
            print('Formatted IC Number: ${myKadInfo.formattedIcNumber}');
            print('IC Number: ${myKadInfo.icNumber}');
        } else {
            // return null if invalid IC Number format
            print('Invalid MyKad number');
        }
    }

MyKadInfo Model

    class MyKadInfo {
        final String icNumber;
        final String formattedIcNumber;
        final String icNumber;
        final DateTime dateOfBirth;
        final int age;
        final String placeOfBirth;
        final String gender;
    
        MyKadInfo({
            required this.icNumber,
            required this.formattedIcNumber,
            required this.icNumber,
            required this.dateOfBirth,
            required this.age,
            required this.placeOfBirth,
            required this.gender,
        });
    }

Example Output

    Age: 29
    Date of Birth: 1995-01-30 00:00:00.000
    Gender: M
    Place of Birth: Kelantan
    Formatted IC Number: 950130-03-2947
    IC Number: 950130032947

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

## Disclaimer
This package is intended for educational and informational purposes only. It should not be used in production systems without proper testing and validation.
