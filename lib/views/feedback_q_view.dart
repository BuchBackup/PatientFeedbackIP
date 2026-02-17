import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:new_bih_feedback/controllers/feedback_rating_controller.dart';
import 'package:new_bih_feedback/controllers/login_controller.dart';
import 'package:new_bih_feedback/controllers/patient_information_controller.dart';
import 'package:new_bih_feedback/models/all_select_feedback_model.dart';
import 'package:new_bih_feedback/services/apis.dart';
import 'package:new_bih_feedback/views/admitted_patient_view.dart';
import 'package:new_bih_feedback/views/home_view.dart';
import 'package:new_bih_feedback/views/no_network.dart';
import 'package:new_bih_feedback/widgets/input_text_field.dart';
import 'package:new_bih_feedback/widgets/my_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/stored_feedback_controller.dart';
import '../services/constent.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackRatingController feedbackRatingController =
      Get.put(FeedbackRatingController());
  final patientInformationController = Get.put(PatientController());
  final loginCon = Get.put(LoginDataController());
  final remarksCon = TextEditingController();
  int currentQuestionIndex = 0;

  final List<String> questions = [
    "Before your admission (from OPD/ER), did you receive enough information regarding your condition,treatment and stay?",
    "Did you have to wait too long before being taken to the ward, or for your room/bed to be prepared?",
    "How would you rate the friendliness and professionalism of the Front Desk Officer (FDO)?",
    "During your hospital stay, how often did nurses listen carefully to you or come immediately when needed?",
    "How often did doctors listen to you carefully during your stay?",
    "Was your pain well controlled during your hospital stay?",
    "Was the hospital environment/room clean and well-maintained?",
    "Was the food quality and nutrition counseling satisfactory during your stay?",
    "How satisfied are you with the timeliness of responses and care provided by the nursing team overall?",
    "How satisfied are you with your overall experience at our hospital so far?"
  ];

  final List<String> headings = [
    "Pre-Admission Information",
    "Waiting Time for Admission",
    "Front Desk Experience",
    "Nursing Responsiveness",
    "Doctor Communication",
    "Pain Management",
    "Cleanliness and Maintenance",
    "Food and Nutrition Counseling",
    "Nursing Care Satisfaction",
    "Overall Hospital Experience"
  ];

  final List<String> emojiOptions = ["😞", "😕", "😐", "🙂", "😄"];

  Map<int, int> percentageMap = {
    1: 20,
    2: 40,
    3: 60,
    4: 80,
    5: 100,
  };

  void goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void skipQuestion() {
    goToNextQuestion();
  }

  final apis = Apis();

// Helper function to get percentage value
  String? getPercentageValue(int index) {
    if (percentageMap.containsKey(index)) {
      return percentageMap[index]?.toString();
    }
    return "0";
  }

  bool areAllQuestionsAnswered() {
    return feedbackRatingController.selectedOptions
        .every((option) => option > 0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserPin();
  }

  Future<void> _loadUserPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginCon.userPin = prefs.getString('userPin') ?? '';
    });
  }

  final storedFCon = Get.put(StoredFeedBackController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: NetworkAwareWidget(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Obx(
            () => ModalProgressHUD(
              progressIndicator: const CircularProgressIndicator(
                color: Color.fromARGB(255, 172, 202, 83),
              ),
              inAsyncCall: patientInformationController.isLoading.value,
              child:
                  GetBuilder<FeedbackRatingController>(builder: (controller) {
                return Stack(
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 0),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/background.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
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
                            padding: EdgeInsets.only(right: 30.0),
                            child: Text(
                              'Patient Feedback Form',
                              style: kBodyBlackBold14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 70, left: 5, right: 5, bottom: 10),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    // color: Colors.red,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 42, 42, 42),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                        255, 173, 202, 83)
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: const Offset(5, 9),
                                              ),
                                            ],
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Please rate your experience with Buch International Hospitals 😍",
                                              style: kBodyWhiteBold16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 173, 202, 83),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                "Question: ${currentQuestionIndex + 1}",
                                                style: kBodyBlackBold16),
                                          ),
                                        ),
                                        const SizedBox(height: 6.0),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 42, 42, 42),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            child: Text(
                                                headings[currentQuestionIndex],
                                                style: kBodyWhiteBold14),
                                          ),
                                        ),
                                        const SizedBox(height: 6.0),
                                        SizedBox(
                                          height: 60,
                                          child: Text(
                                            questions[currentQuestionIndex],
                                            style: kBodyWhite14,
                                          ),
                                        ),
                                        const SizedBox(height: 6.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(5, (index) {
                                            int rating = index + 1;
                                            return GestureDetector(
                                              onTap: () {
                                                controller.selectOption(
                                                    currentQuestionIndex,
                                                    rating);
                                                goToNextQuestion();
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    emojiOptions[index],
                                                    style: TextStyle(
                                                      fontSize: 40,
                                                      color: controller
                                                                      .selectedOptions[
                                                                  currentQuestionIndex] ==
                                                              rating
                                                          ? Colors.blue
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor: controller
                                                                    .selectedOptions[
                                                                currentQuestionIndex] ==
                                                            rating
                                                        ? const Color.fromARGB(
                                                            255, 173, 202, 83)
                                                        : Colors.transparent,
                                                    radius: 10,
                                                    child: Text(
                                                      rating.toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: controller
                                                                        .selectedOptions[
                                                                    currentQuestionIndex] ==
                                                                rating
                                                            ? const Color
                                                                .fromARGB(
                                                                255, 42, 42, 42)
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Text(
                                          "Feedback",
                                          style: kBodyGreenRgb16,
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Table(
                                          border: TableBorder.all(
                                              color: Colors
                                                  .grey), // Add borders to the table
                                          columnWidths: const {
                                            0: FlexColumnWidth(
                                                1), // Adjust column widths
                                            1: FlexColumnWidth(1),
                                            2: FlexColumnWidth(1),
                                            // Add more as needed
                                          },
                                          children: [
                                            TableRow(
                                              children: List.generate(
                                                10,
                                                (index) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Center(
                                                    child: Text(
                                                      ' Q${index + 1}',
                                                      // textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255,
                                                              173,
                                                              202,
                                                              83)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableRow(
                                              children: List.generate(
                                                feedbackRatingController
                                                    .selectedOptions.length,
                                                (index) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    ' ${feedbackRatingController.selectedOptions[index]}',
                                                    textAlign: TextAlign.center,
                                                    style: kBodyWhiteBold14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        storedFCon.pFeedback == true
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: Text(
                                                      "Previous Feedback:",
                                                      style: kBodyGreenRgb16,
                                                    ),
                                                  ),
                                                  Table(
                                                    border: TableBorder.all(
                                                        color: Colors.grey,
                                                        width:
                                                            1), // Adds borders to the table
                                                    columnWidths: {
                                                      for (int i = 0;
                                                          i < 10;
                                                          i++)
                                                        i: const FlexColumnWidth(
                                                            1), // Equal width for 10 columns
                                                    },
                                                    children: [
                                                      // First Row: Keys
                                                      TableRow(
                                                        decoration: const BoxDecoration(
                                                            // color: Colors.grey
                                                            //     .shade300
                                                            ), // Header background color
                                                        children: storedFCon
                                                            .storedFeedbackModel!
                                                            .questionPercentages
                                                            .keys
                                                            .take(
                                                                10) // Limit to 10 keys
                                                            .map((key) {
                                                          // Transform the key
                                                          String
                                                              transformedKey =
                                                              key
                                                                  .replaceFirst(
                                                                      RegExp(
                                                                          r'^q'),
                                                                      'Q') // Replace 'q' at the start with 'Q'
                                                                  .replaceFirst(
                                                                      RegExp(
                                                                          r'q$'),
                                                                      'Q'); // Replace 'q' at the end with 'Q'

                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(
                                                              transformedKey,
                                                              style:
                                                                  kBodyWhiteBold14,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                      // Second Row: Values
                                                      TableRow(
                                                        children: storedFCon
                                                            .storedFeedbackModel!
                                                            .questionPercentages
                                                            .values
                                                            .take(
                                                                10) // Limit to 10 values
                                                            .map((value) {
                                                          // Parse the value as a number
                                                          double numericValue =
                                                              double.tryParse(
                                                                      value) ??
                                                                  0.0;

                                                          // Map value to corresponding number
                                                          int mappedValue = numericValue >=
                                                                  100
                                                              ? 5
                                                              : numericValue >=
                                                                      80
                                                                  ? 4
                                                                  : numericValue >=
                                                                          60
                                                                      ? 3
                                                                      : numericValue >=
                                                                              40
                                                                          ? 2
                                                                          : numericValue >= 20
                                                                              ? 1
                                                                              : 0; // Default to 0 if below 20

                                                          // Determine the color based on mapped value
                                                          Color valueColor =
                                                              mappedValue >= 3
                                                                  ? const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      173,
                                                                      202,
                                                                      83)
                                                                  : Colors.red;

                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(
                                                              '$mappedValue',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    valueColor, // Apply conditional color
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(
                                                height: 80,
                                              ),
                                        areAllQuestionsAnswered()
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: MyInputTextField(
                                                  hintText: "Enter Remarks",
                                                  controller: remarksCon,
                                                ),
                                              )
                                            : SizedBox(
                                                height: 85,
                                                child: Column(
                                                  children: [
                                                    const Spacer(),
                                                    Row(
                                                      children: [
                                                        const Spacer(),
                                                        const Text(
                                                          "login Id:",
                                                          style: kBodyWhite12,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 3,
                                                                  vertical: 3),
                                                          child: Text(
                                                            loginCon.userPin,
                                                            style:
                                                                kBodyGreenShadeBold14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        currentQuestionIndex > 0
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 42, 42, 42),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                height: 70,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      if (currentQuestionIndex >
                                                          0)
                                                        ElevatedButton(
                                                          onPressed:
                                                              goToPreviousQuestion,
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          173,
                                                                          202,
                                                                          83)),
                                                          child: const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        33),
                                                            child: Text(
                                                              "Back",
                                                              style:
                                                                  kBodyBlackBold12,
                                                            ),
                                                          ),
                                                        ),
                                                      // currentQuestionIndex ==
                                                      //         questions.length - 1
                                                      //     ?
                                                      areAllQuestionsAnswered()
                                                          ? ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                patientInformationController
                                                                    .startLoading();

                                                                try {
                                                                  // Format the current date and time
                                                                  DateTime now =
                                                                      DateTime
                                                                          .now();
                                                                  String
                                                                      formattedDate =
                                                                      DateFormat(
                                                                              'yyyy-MM-dd HH:mm:ss')
                                                                          .format(
                                                                              now);

                                                                  // Prepare data for the model
                                                                  PatientFeedbakModel
                                                                      patientModel =
                                                                      PatientFeedbakModel(
                                                                    registrationID:
                                                                        patientInformationController.sPregisId ??
                                                                            "",
                                                                    pin: patientInformationController
                                                                            .sPpin ??
                                                                        "",
                                                                    patientName:
                                                                        patientInformationController.sPname ??
                                                                            "",
                                                                    gender:
                                                                        patientInformationController.sPgender ??
                                                                            "",
                                                                    mobile:
                                                                        patientInformationController.sPmobile ??
                                                                            "",
                                                                    registrationDate:
                                                                        patientInformationController.sPregisDate ??
                                                                            "",
                                                                    doctorName:
                                                                        patientInformationController.sPdoctor ??
                                                                            "",
                                                                    bedNumber:
                                                                        patientInformationController.sPbedNum ??
                                                                            "",
                                                                    deptName:
                                                                        patientInformationController.sPdeptName ??
                                                                            "",
                                                                    tpaName:
                                                                        patientInformationController.sPtpaName ??
                                                                            "",
                                                                    fbDateTime:
                                                                        formattedDate,
                                                                    q1Percentage:
                                                                        getPercentageValue(
                                                                            feedbackRatingController.selectedOptions[0]),
                                                                    q2Percentage:
                                                                        getPercentageValue(
                                                                            feedbackRatingController.selectedOptions[1]),
                                                                    q3Percentage:
                                                                        getPercentageValue(
                                                                            feedbackRatingController.selectedOptions[2]),
                                                                    q4Percentage:
                                                                        getPercentageValue(
                                                                            feedbackRatingController.selectedOptions[3]),
                                                                    q5Percentage:
                                                                        getPercentageValue(
                                                                            feedbackRatingController.selectedOptions[4]),
                                                                    q6Percentage:
                                                                        getPercentageValue(
                                                                            feedbackRatingController.selectedOptions[5]),
                                                                    q7Percentage:
                                                                        getPercentageValue(
                                                                            feedbackRatingController.selectedOptions[6]),
                                                                    q8Percentage:
                                                                        getPercentageValue(
                                                                            feedbackRatingController.selectedOptions[7]),
                                                                    q9Percentage:
                                                                        getPercentageValue(
                                                                            feedbackRatingController.selectedOptions[8]),
                                                                    q10Percentage:
                                                                        getPercentageValue(
                                                                            feedbackRatingController.selectedOptions[9]),
                                                                    comments:
                                                                        remarksCon.text ??
                                                                            "",
                                                                    sendby:
                                                                        loginCon.userPin ??
                                                                            "",
                                                                  );

                                                                  // Call the API and get the response
                                                                  String?
                                                                      response =
                                                                      await apis
                                                                          .postFeedbackData(
                                                                              patientModel);

                                                                  if (response !=
                                                                      null) {
                                                                    patientInformationController
                                                                        .stopLoading();
                                                                    // Show success toast
                                                                    myToast(
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            172,
                                                                            202,
                                                                            83),
                                                                        "Submit Successfully",
                                                                        Colors
                                                                            .black);

                                                                    // Clear selected options
                                                                    feedbackRatingController
                                                                            .selectedOptions =
                                                                        List.filled(
                                                                            10,
                                                                            0); // Reset to default values

                                                                    // Navigate to the home screen
                                                                    setState(
                                                                        () {
                                                                      storedFCon
                                                                              .pFeedback =
                                                                          false;
                                                                    });
                                                                    Get.offAll(
                                                                      () =>
                                                                          const AdmittedPatientView(),
                                                                      duration: const Duration(
                                                                          seconds:
                                                                              2),
                                                                      transition:
                                                                          Transition
                                                                              .fadeIn,
                                                                    );
                                                                  } else {
                                                                    // Handle submission failure
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text("Failed to submit feedback. Please try again.")),
                                                                    );
                                                                  }
                                                                } finally {
                                                                  // Hide the loading indicator
                                                                  patientInformationController
                                                                      .stopLoading();
                                                                }
                                                              },
                                                              // submitFeedback,
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          173,
                                                                          202,
                                                                          83)),
                                                              child: const Text(
                                                                "Submit Feedback",
                                                                style:
                                                                    kBodyBlackBold12,
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                myToast(
                                                                    Colors.red,
                                                                    "Please Select All Questions",
                                                                    Colors
                                                                        .white);
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white),
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        42,
                                                                        42,
                                                                        42),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30)),
                                                                height: 40,
                                                                width: 180,
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    "Submit Feedback",
                                                                    style:
                                                                        kBodyWhiteBold12,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7)),
                                                        height: 65,
                                                        width: 30,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                storedFCon
                                                                        .pFeedback =
                                                                    false;
                                                              });
                                                              Get.back();
                                                            },
                                                            icon: const Icon(
                                                              Icons.arrow_back,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: DottedBorder(
                                                      color: Colors
                                                          .red, // Border color
                                                      strokeWidth:
                                                          2, // Thickness of the border
                                                      dashPattern: const [
                                                        6,
                                                        3
                                                      ], // Dotted pattern [dash length, gap length]
                                                      borderType: BorderType
                                                          .RRect, // Rounded rectangle border
                                                      radius: const Radius
                                                          .circular(
                                                          12), // Rounded corners
                                                      child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  42, 42, 42),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "Please answer all questions before submitting.",
                                                              style:
                                                                  kBodyWhiteBold14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    ));
  }
}
