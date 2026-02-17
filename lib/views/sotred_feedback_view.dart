import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_bih_feedback/models/storedfeedback_model.dart';
import 'package:new_bih_feedback/services/apis.dart';
import 'package:new_bih_feedback/views/feedback_q_view.dart';
import 'package:new_bih_feedback/widgets/my_toast.dart';

import '../controllers/stored_feedback_controller.dart';
import '../services/constent.dart';

class StoredFeedbackScreen extends StatefulWidget {
  const StoredFeedbackScreen({Key? key}) : super(key: key);

  @override
  _StoredFeedbackScreenState createState() => _StoredFeedbackScreenState();
}

class _StoredFeedbackScreenState extends State<StoredFeedbackScreen> {
  Apis api = Apis();
  final storedFCon = Get.put(StoredFeedBackController());

  // Text(DateTime.now().toString())
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String fdateTimeString =
        storedFCon.storedFeedbackModel!.fbDateTime.toString();
    DateTime fparsedDateTime = DateTime.parse(fdateTimeString);
    String cdateTimeString = DateTime.now().toString();
    DateTime cparsedDateTime = DateTime.parse(cdateTimeString);
    String fdate =
        "${fparsedDateTime.year}-${fparsedDateTime.month.toString().padLeft(2, '0')}-${fparsedDateTime.day.toString().padLeft(2, '0')}";
    String cdate =
        "${cparsedDateTime.year}-${cparsedDateTime.month.toString().padLeft(2, '0')}-${cparsedDateTime.day.toString().padLeft(2, '0')}";
    double overallPercentage = 0.0;
    // Check if questionPercentages is not null or empty
    if (storedFCon.storedFeedbackModel?.questionPercentages != null &&
        storedFCon.storedFeedbackModel!.questionPercentages.isNotEmpty) {
      // Calculate the total percentage
      overallPercentage = storedFCon
          .storedFeedbackModel!.questionPercentages.entries
          .take(10) // Limit to 10 rows
          .map((entry) =>
              double.tryParse(entry.value) ?? 0.0) // Convert to double
          .reduce((sum, value) => sum + value); // Sum up percentages

      // Calculate the average percentage
      overallPercentage /= storedFCon
          .storedFeedbackModel!.questionPercentages.entries
          .take(10)
          .length;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 42, 42, 42),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color.fromARGB(255, 172, 202, 83),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      height: 65,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/bih_logo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 0.0),
                      child: Text(
                        'Patient Feedback Form',
                        style: kBodyBlackBold12,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 172, 202, 83))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Patient Name:   ",
                                    style: kBodyGreenShadeBold14,
                                  ),
                                  Text(
                                    storedFCon
                                            .storedFeedbackModel?.patientName ??
                                        'N/A',
                                    style: kBodyWhite12,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Doctor Name:    ",
                                    style: kBodyGreenShadeBold14,
                                  ),
                                  Text(
                                    storedFCon
                                            .storedFeedbackModel?.doctorName ??
                                        'N/A',
                                    style: kBodyWhite12,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Department:\t\t\t\t\t\t",
                                    style: kBodyGreenShadeBold14,
                                  ),
                                  Text(
                                    storedFCon.storedFeedbackModel?.deptName ??
                                        'N/A',
                                    style: kBodyWhite12,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Bed Number:\t\t\t\t\t",
                                    style: kBodyGreenShadeBold14,
                                  ),
                                  Text(
                                    storedFCon.storedFeedbackModel?.bedNumber ??
                                        'N/A',
                                    style: kBodyWhite12,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Gender:\t\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                    style: kBodyGreenShadeBold14,
                                  ),
                                  Text(
                                    storedFCon.storedFeedbackModel?.gender ??
                                        'N/A',
                                    style: kBodyWhite12,
                                  ),
                                ],
                              ),
                              const Divider(),
                              const Text(
                                'Feedback Percentages:',
                                style: kBodyWhiteBold14,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    "Overall Satisfaction:",
                                    style: kBodyGreenRgb14,
                                  ),
                                  Text(
                                    '\t\t${overallPercentage.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: overallPercentage >= 60
                                          ? Colors.white
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Table(
                      border: TableBorder.all(color: Colors.grey, width: 1),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration:
                              BoxDecoration(color: Colors.grey.shade300),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                'Sr No',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                'Percentage',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                'Satisfaction',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        ...storedFCon
                            .storedFeedbackModel!.questionPercentages.entries
                            .take(10)
                            .map((entry) {
                          String transformedKey = entry.key
                              .replaceFirst(RegExp(r'^q'), 'Q')
                              .replaceFirst(RegExp(r'q$'), 'Q');
                          double value = double.tryParse(entry.value) ?? 0.0;
                          Color valueColor = value >= 60
                              ? const Color.fromARGB(255, 172, 202, 83)
                              : Colors.red;
                          String emoji = value < 20
                              ? '😞'
                              : value < 40
                                  ? '😕'
                                  : value < 60
                                      ? '😐'
                                      : value < 80
                                          ? '🙂'
                                          : '😄';

                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  transformedKey,
                                  style: kBodyWhiteBold14,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${entry.value}%',
                                  style: TextStyle(
                                      fontSize: 12, color: valueColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  emoji,
                                  style: TextStyle(
                                      fontSize: 18, color: valueColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            if (fdate == cdate) {
                              myToast(
                                  Colors.red,
                                  "Feedback has already been submitted. Only one feedback submission is allowed until 12 AM",
                                  Colors.white);
                            } else {
                              setState(() {
                                storedFCon.pFeedback = true;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FeedbackScreen()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 172, 202, 83)),
                          child: const Text(
                            "Update Feedback",
                            style: kBodyBlack12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
