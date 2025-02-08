import 'package:get/get.dart';

class PatientController extends GetxController {
  RxBool isLoading = false.obs; // RxBool variable initialized to
  void startLoading() {
    isLoading.value = true; // Update to true to show loading state
  }

  void stopLoading() {
    isLoading.value = false; // Update to false to hide loading state
  }

////////////////////////////////selected patient data
  var sPregisId;
  var sPpin;
  var sPname;
  var sPgender;
  var sPmobile;
  var sPregisDate;
  var sPdoctor;
  var sPbedNum;
  var sPdeptName;
  var sPtpaName;

  String _patientRegisId = '';
  String _pin = '';
  String _patientName = '';
  String _gender = '';
  String _phone = '';
  String _regisDate = '';
  String _doctorName = '';
  String _bedNumber = '';
  String _deptName = '';
  String _tpaName = '';

  String get patientRegisId => _patientRegisId;
  String get pin => _pin;
  String get patientName => _patientName;
  String get gender => _gender;
  String get phone => _phone;
  String get regisDate => _regisDate;
  String get doctorName => _doctorName;
  String get bedNumber => _bedNumber;
  String get deptName => _deptName;
  String get tpaName => _tpaName;

  void setPatientInformationData({
    patientRegisId,
    pin,
    name,
    gender,
    phone,
    regisDate,
    doctorName,
    bedNumber,
    deptName,
    tpaName,
  }) {
    _patientRegisId = patientRegisId;
    _pin = pin;
    _patientName = name;
    _gender = gender;
    _phone = phone;
    _regisDate = regisDate;
    _doctorName = doctorName;
    _bedNumber = bedNumber;

    _deptName = deptName;
    _tpaName = tpaName;
  }
}
