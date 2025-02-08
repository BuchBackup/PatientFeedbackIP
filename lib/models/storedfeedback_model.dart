class StoredFeedbackModel {
  final String registrationID;
  final String pin;
  final String patientName;
  final String gender;
  final String mobile;
  final String registrationDate;
  final String fbDateTime;
  final String doctorName;
  final String bedNumber;
  final String deptName;
  final String tpaName;
  final Map<String, String> questionPercentages;

  StoredFeedbackModel({
    required this.registrationID,
    required this.pin,
    required this.patientName,
    required this.gender,
    required this.mobile,
    required this.registrationDate,
    required this.fbDateTime,
    required this.doctorName,
    required this.bedNumber,
    required this.deptName,
    required this.tpaName,
    required this.questionPercentages,
  });

  factory StoredFeedbackModel.fromJson(Map<String, dynamic> json) {
    return StoredFeedbackModel(
      registrationID: json['registrationID'],
      pin: json['pin'],
      patientName: json['patientName'],
      gender: json['gender'],
      mobile: json['mobile'],
      registrationDate: json['registrationDate'],
      fbDateTime: json['fbDateTime'],
      doctorName: json['doctorName'],
      bedNumber: json['bedNumber'],
      deptName: json['deptName'],
      tpaName: json['tpaName'],
      questionPercentages: {
        'q1': json['q1Percentage'],
        'q2': json['q2Percentage'],
        'q3': json['q3Percentage'],
        'q4': json['q4Percentage'],
        'q5': json['q5Percentage'],
        'q6': json['q6Percentage'],
        'q7': json['q7Percentage'],
        'q8': json['q8Percentage'],
        'q9': json['q9Percentage'],
        'q10': json['q10Percentage'],
      },
    );
  }
}
