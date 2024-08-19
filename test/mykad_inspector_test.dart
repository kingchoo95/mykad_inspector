import 'package:flutter_test/flutter_test.dart';
import 'package:mykad_inspector/model/MyKadInfo.dart';

import 'package:mykad_inspector/mykad_inspector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('IC Number with Gender Male', () async {
    final myKadInspector = MyKadInspector();

    final testOneExpectedInfo = MyKadInfo(
      age: 29,
      placeOfBirth: 'Kelantan',
      dateOfBirth: DateTime.parse('1995-01-30 00:00:00.000'),
      gender: 'M',
      formattedIcNumber: '950130-03-5947',
      icNumber: '950130035947',
    );

    expect(await myKadInspector.extractICDetails('950130035947'), testOneExpectedInfo);
  });

  test('IC Number with Gender Female', () async {
    final myKadInspector = MyKadInspector();

    final testTwoExpectedInfo = MyKadInfo(
      age: 24,
      placeOfBirth: 'Selangor',
      dateOfBirth: DateTime.parse('2000-01-23 00:00:00.000'),
      gender: 'F',
      formattedIcNumber: '000123-10-5936',
      icNumber: '000123105936',
    );


    expect(await myKadInspector.extractICDetails('000123105936'), testTwoExpectedInfo);
  });

  test('IC Number with dash', () async {
    final myKadInspector = MyKadInspector();

    final testThreeExpectedInfo = MyKadInfo(
      age: 24,
      placeOfBirth: 'Selangor',
      dateOfBirth: DateTime.parse('2000-01-23 00:00:00.000'),
      gender: 'F',
      formattedIcNumber: '000123-10-5936',
      icNumber: '000123105936',
    );


    expect(await myKadInspector.extractICDetails('000123-10-5936'), testThreeExpectedInfo);
  });

  test('IC Number with 12 years old', () async {
    final myKadInspector = MyKadInspector();

    final testFourExpectedInfo = MyKadInfo(
      age: 12,
      placeOfBirth: 'Selangor',
      dateOfBirth: DateTime.parse('2012-01-23 00:00:00.000'),
      gender: 'F',
      formattedIcNumber: '120123-10-5936',
      icNumber: '120123105936',
    );

    expect(await myKadInspector.extractICDetails('120123-10-5936'), testFourExpectedInfo);
  });

  test('IC Number with 111 years old', () async {
    final myKadInspector = MyKadInspector();

    final testFiveExpectedInfo = MyKadInfo(
      age: 111,
      placeOfBirth: 'Federal Territory of Putrajaya',
      dateOfBirth: DateTime.parse('1913-01-23 00:00:00.000'),
      gender: 'M',
      formattedIcNumber: '130123-16-1123',
      icNumber: '130123161123',
    );

    expect(await myKadInspector.extractICDetails('130123-16-1123'), testFiveExpectedInfo);
  });

  test('IC Number with Alpha', () async {
    final myKadInspector = MyKadInspector();

    final testSevenExpectedInfo = null;

    expect(await myKadInspector.extractICDetails('950123991121asdas3'), testSevenExpectedInfo);
  });

  test('IC Number with less length', () async {
    final myKadInspector = MyKadInspector();

    final testEightExpectedInfo = null;

    expect(await myKadInspector.extractICDetails('950123'), testEightExpectedInfo);
  });

}
