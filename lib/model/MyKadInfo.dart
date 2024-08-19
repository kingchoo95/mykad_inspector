class MyKadInfo {
  final int age;
  final String placeOfBirth;
  final DateTime dateOfBirth;
  final String gender;
  final String formattedIcNumber;
  final String icNumber;

  MyKadInfo({
    required this.age,
    required this.placeOfBirth,
    required this.dateOfBirth,
    required this.gender,
    required this.formattedIcNumber,
    required this.icNumber,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyKadInfo &&
        other.age == age &&
        other.placeOfBirth == placeOfBirth &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.formattedIcNumber == formattedIcNumber &&
        other.icNumber == icNumber;
  }

  @override
  int get hashCode {
    return age.hashCode ^
    placeOfBirth.hashCode ^
    dateOfBirth.hashCode ^
    gender.hashCode ^
    formattedIcNumber.hashCode ^
    icNumber.hashCode;
  }
}
