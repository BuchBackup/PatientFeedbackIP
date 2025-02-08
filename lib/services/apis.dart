import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_bih_feedback/controllers/stored_feedback_controller.dart';
import 'package:new_bih_feedback/models/all_select_feedback_model.dart';
import 'package:new_bih_feedback/models/storedfeedback_model.dart';
import 'dart:convert';
import '../models/patient_data_model.dart';

enum ApiStatus { success, failed, unauthorized, error }

class ApiResponse<T> {
  final ApiStatus status;
  final T? data;
  final String? message;

  ApiResponse({required this.status, this.data, this.message});
}

final sotoredCon = Get.put(StoredFeedBackController());

class Apis {
  String hostAndPort = 'https://www.buchhospital.com/settings/api/';
  Future<String?> postFeedbackData(PatientFeedbakModel patientModel) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '$hostAndPort/admitted_patient_feedback.php'), // Replace with your actual URL
    );

    // Add all fields from model to request
    request.fields.addAll(patientModel.toMap());

    // Send request
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      print("Error: ${response.reasonPhrase}");
      return null;
    }
  }

  //////////////login data
  Future login(String email, String password) async {
    var request = http.Request('GET',
        Uri.parse('$hostAndPort/app_auth.php?email=$email&password=$password'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      return data[0]['emp_id'];
    } else {
      print(response.reasonPhrase);
      return ApiStatus.failed.name;
    }
  }

//////////////////////////get Patients
  Future<List<Patient>> fetchPatients() async {
    final response = await http
        .get(Uri.parse('https://bapi.buchhospital.com/admittedpatients.php'));

    if (response.statusCode == 200) {
      // Manually separate individual JSON objects by splitting at "}{"
      final formattedJson = '[${response.body.replaceAll('}{', '},{')}]';

      // Now parse as a list
      List<dynamic> data = jsonDecode(formattedJson);
      return data.map((item) => Patient.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  /////////////////////////////////////////////////////////
  // Future fetchFeedback(String registrationID) async {
  //   final Uri url = Uri.parse(
  //       '$hostAndPort/get_storedfeedback.php?registrationID=$registrationID');
  //   final Map<String, String> headers = {
  //     'Cookie': 'PHPSESSID=9b5035b42659c373c4c06d1a6d845482',
  //   };

  //   try {
  //     final http.Response response = await http.get(url, headers: headers);
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       sotoredCon.storedFeedbackModel =
  //           StoredFeedbackModel.fromJson(jsonResponse);
  //       // return
  //       //  StoredFeedbackModel.fromJson(jsonResponse);
  //     } else {
  //       print('Error: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Exception: $e');
  //   }
  //   return null;
  // }

  /////////////////////////////////////////////
  ///
  Future fetchFeedback(String registrationID) async {
    final Uri url = Uri.parse(
        '$hostAndPort/get_storedfeedback.php?registrationID=$registrationID');
    final Map<String, String> headers = {
      'Cookie': 'PHPSESSID=9b5035b42659c373c4c06d1a6d845482',
    };

    try {
      final http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['message'] ==
            "No record found for the provided registrationID.") {
          return ApiStatus.failed.name;
        } else {
          sotoredCon.storedFeedbackModel =
              StoredFeedbackModel.fromJson(jsonResponse);
          return ApiStatus.success.name;
        }
      } else {
        print('Error: ${response.reasonPhrase}');
        return ApiStatus.failed.name;
      }
    } catch (e) {
      print('Exception: $e');
      return ApiStatus.failed.name;
    }
  }
}
