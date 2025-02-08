class PatientFeedbakModel {
  String registrationID;
  String pin;
  String patientName;
  String gender;
  String mobile;
  String registrationDate;
  String doctorName;
  String bedNumber;
  String deptName;
  String tpaName;
  String fbDateTime;
  String? q1Percentage;
  String? q2Percentage;
  String? q3Percentage;
  String? q4Percentage;
  String? q5Percentage;
  String? q6Percentage;
  String? q7Percentage;
  String? q8Percentage;
  String? q9Percentage;
  String? q10Percentage;
  String comments;
  String sendby;

  PatientFeedbakModel({
    required this.registrationID,
    required this.pin,
    required this.patientName,
    required this.gender,
    required this.mobile,
    required this.registrationDate,
    required this.doctorName,
    required this.bedNumber,
    required this.deptName,
    required this.tpaName,
    required this.fbDateTime,
    this.q1Percentage,
    this.q2Percentage,
    this.q3Percentage,
    this.q4Percentage,
    this.q5Percentage,
    this.q6Percentage,
    this.q7Percentage,
    this.q8Percentage,
    this.q9Percentage,
    this.q10Percentage,
    required this.comments,
    required this.sendby,
  });

  // Convert model to map for API request
  Map<String, String> toMap() {
    return {
      "registrationID": registrationID,
      "pin": pin,
      "patientName": patientName,
      "gender": gender,
      "mobile": mobile,
      "registrationDate": registrationDate,
      "doctorName": doctorName,
      "bedNumber": bedNumber,
      "deptName": deptName,
      "tpaName": tpaName,
      "fbDateTime": fbDateTime,
      "q1Percentage": q1Percentage ?? "0",
      "q2Percentage": q2Percentage ?? "0",
      "q3Percentage": q3Percentage ?? "0",
      "q4Percentage": q4Percentage ?? "0",
      "q5Percentage": q5Percentage ?? "0",
      "q6Percentage": q6Percentage ?? "0",
      "q7Percentage": q7Percentage ?? "0",
      "q8Percentage": q8Percentage ?? "0",
      "q9Percentage": q9Percentage ?? "0",
      "q10Percentage": q10Percentage ?? "0",
      "comments": comments,
      "sendby": sendby,
    };
  }
}
