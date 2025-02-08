class Patient {
  final String registrationId;
  final String pin;
  final String patientName;
  final String gender;
  final String mobile;
  final String registrationDate;
  final String doctor;
  final String bedNumber;
  final String deptName;
  final String? tpaName;

  Patient({
    required this.registrationId,
    required this.pin,
    required this.patientName,
    required this.gender,
    required this.mobile,
    required this.registrationDate,
    required this.doctor,
    required this.bedNumber,
    required this.deptName,
    this.tpaName,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      registrationId: json['RegistrationId'],
      pin: json['PIN'],
      patientName: json['Patientname'],
      gender: json['Gender'],
      mobile: json['Mobile'],
      registrationDate: json['RegistrationDate'],
      doctor: json['Doctor'],
      bedNumber: json['BedNumber'],
      deptName: json['DeptName'],
      tpaName: json['TPAName'],
    );
  }
}
