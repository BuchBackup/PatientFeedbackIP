import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:new_bih_feedback/controllers/login_controller.dart';
import 'package:new_bih_feedback/controllers/patient_information_controller.dart';
import 'package:new_bih_feedback/controllers/stored_feedback_controller.dart';
import 'package:new_bih_feedback/services/apis.dart';
import 'package:new_bih_feedback/services/constent.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:new_bih_feedback/views/feedback_q_view.dart';
import 'package:new_bih_feedback/views/login_view.dart';
import 'package:new_bih_feedback/views/no_network.dart';
import 'package:new_bih_feedback/views/sotred_feedback_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/patient_data_model.dart';
import '../widgets/search_textfield.dart';

class AdmittedPatientView extends StatefulWidget {
  const AdmittedPatientView({super.key});

  @override
  _AdmittedPatientViewState createState() => _AdmittedPatientViewState();
}

class _AdmittedPatientViewState extends State<AdmittedPatientView> {
  List<Patient> _patients = [];
  List<Patient> _filteredPatients = [];
  Map<String, int> _bedPrefixCounts =
      {}; // Map to store patient count for each category
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final patientCon = Get.put(PatientController());

  // Currently selected bed prefix
  String? _selectedBedPrefix = 'All';
  final loginCon = Get.put(LoginDataController());
  @override
  void initState() {
    super.initState();
    _loadUserPin();
    _fetchPatients();
    _searchController.addListener(_filterPatients);
  }

  Future<void> _loadUserPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginCon.userPin = prefs.getString('userPin') ?? '';
    });
  }

  Apis api = Apis();
  final storedFCon = Get.put(StoredFeedBackController());
  // Fetching data from the API
  void _fetchPatients() async {
    try {
      Apis api = Apis();
      final patients = await api.fetchPatients();

      setState(() {
        _patients = patients;
        _filteredPatients = patients;
        _isLoading = false;

        // Calculate patient count per bed prefix
        _bedPrefixCounts = _patients.fold<Map<String, int>>({}, (acc, patient) {
          final prefix = patient.bedNumber.split(RegExp(r'\d')).first;
          acc[prefix] = (acc[prefix] ?? 0) + 1;
          return acc;
        });
        _bedPrefixCounts['All'] =
            _patients.length; // Total count for "All" category
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Filtering logic based on search query and bed prefix
  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = _patients.where((patient) {
        final matchesSearchQuery =
            patient.patientName.toLowerCase().contains(query) ||
                patient.pin.toLowerCase().contains(query);

        final matchesBedPrefix = _selectedBedPrefix == 'All' ||
            patient.bedNumber.startsWith(_selectedBedPrefix!);

        return matchesSearchQuery && matchesBedPrefix;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

/////////////////////////////Load User Pin

  ///////////////////////////////////////////Logout
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userPin');
    Get.to(
      () => const LoginView(),
      // const PatientListScreen(),
      // duration: const Duration(seconds: 1),
      transition: Transition.leftToRight,
    );
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NetworkAwareWidget(
        child: ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(
            color: Color.fromARGB(255, 172, 202, 83),
          ),
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Container(
                  color: const Color.fromARGB(255, 172, 202, 83),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.white,
                        height: 65,
                        width: 130,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/bih_logo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Text(
                          'Patient Feedback Form',
                          style: kBodyBlackBold14,
                        ),
                      ),
                      // const Text(
                      //   "TP-",
                      //   style: kBodyBlackBold18,
                      // ),
                      const Spacer(),
                      CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 42, 42, 42),
                          radius: 25,
                          child: Text(
                            "${_patients.length}",
                            style: kBodyWhite18,
                          )),
                      const SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ),
                MyTextField(
                  style: kBodyWhite12,
                  hintStyle: kBodyWhite12,
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: "Search by Patient Name/PIN...",
                  controller: _searchController,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Always include the "All Patients" button first
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                            label: Row(
                              children: [
                                const Text(
                                  'All',
                                  style: kBodyBlack12,
                                ),
                                const SizedBox(width: 6),
                                CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 42, 42, 42),
                                  radius: 15,
                                  child: Text(
                                    '${_patients.length}', // Show the total count
                                    style: kBodyWhite12,
                                  ),
                                ),
                              ],
                            ),
                            selected: _selectedBedPrefix == 'All',
                            onSelected: (selected) {
                              setState(() {
                                _selectedBedPrefix = 'All';
                                _filterPatients();
                              });
                            },
                            selectedColor:
                                const Color.fromARGB(255, 172, 202, 83),
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: _selectedBedPrefix == 'All'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        // Dynamically generate other category chips
                        ..._bedPrefixCounts.entries
                            .where((entry) => entry.key != 'All')
                            .map((entry) {
                          final prefix = entry.key
                              .replaceAll('-', ''); // Remove the '-' character
                          final count = entry.value;
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ChoiceChip(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                              ),
                              label: Row(
                                children: [
                                  Text(
                                    prefix, // Display the cleaned prefix
                                    style: kBodyBlack12,
                                  ),
                                  const SizedBox(width: 6),
                                  CircleAvatar(
                                    backgroundColor:
                                        const Color.fromARGB(255, 42, 42, 42),
                                    radius: 15,
                                    child: Text(
                                      '$count',
                                      style: kBodyWhite12,
                                    ),
                                  ),
                                ],
                              ),
                              selected: _selectedBedPrefix ==
                                  entry.key, // Match with the original key
                              onSelected: (selected) {
                                setState(() {
                                  _selectedBedPrefix = entry
                                      .key; // Use the original key for filtering
                                  _filterPatients();
                                });
                              },
                              selectedColor:
                                  const Color.fromARGB(255, 172, 202, 83),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: _selectedBedPrefix == entry.key
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 173, 202, 83),
                        ))
                      : ListView.builder(
                          itemCount: _filteredPatients.length,
                          itemBuilder: (context, index) {
                            final patient = _filteredPatients[index];
                            String dateTimeString = patient.registrationDate;
                            // Parse the string into a DateTime object
                            DateTime parsedDateTime =
                                DateTime.parse(dateTimeString);

                            // Extract date and time separately
                            String date =
                                "${parsedDateTime.year}-${parsedDateTime.month.toString().padLeft(2, '0')}-${parsedDateTime.day.toString().padLeft(2, '0')}";
                            String time =
                                "${parsedDateTime.hour.toString().padLeft(2, '0')}:${parsedDateTime.minute.toString().padLeft(2, '0')}:${parsedDateTime.second.toString().padLeft(2, '0')}";

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;

                                    patientCon.sPregisId =
                                        _filteredPatients[index].registrationId;
                                    patientCon.sPpin =
                                        _filteredPatients[index].pin;
                                    patientCon.sPname =
                                        _filteredPatients[index].patientName;
                                    patientCon.sPgender =
                                        _filteredPatients[index].gender;
                                    patientCon.sPmobile =
                                        _filteredPatients[index].mobile;
                                    patientCon.sPregisDate =
                                        _filteredPatients[index]
                                            .registrationDate;
                                    patientCon.sPdoctor =
                                        _filteredPatients[index].doctor;
                                    patientCon.sPbedNum =
                                        _filteredPatients[index].bedNumber;
                                    patientCon.sPdeptName =
                                        _filteredPatients[index].deptName;
                                    patientCon.sPtpaName =
                                        _filteredPatients[index].tpaName;

                                    // api.fetchFeedback(
                                    //     _filteredPatients[index].registrationId);
                                  });

                                  var data = await api.fetchFeedback(
                                      _filteredPatients[index].registrationId);
                                  if (data == ApiStatus.failed.name) {
                                    Get.to(
                                      () => const FeedbackScreen(),
                                      // duration: const Duration(
                                      //     ),
                                      transition: Transition.fadeIn,
                                    );

                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else {
                                    Get.to(
                                      () => const StoredFeedbackScreen(),
                                      // duration: const Duration(
                                      //     ),
                                      transition: Transition.fadeIn,
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                child: Card(
                                  color: const Color.fromARGB(255, 42, 42, 42),
                                  child: ListTile(
                                    title: Text(
                                      patient.patientName,
                                      style: kBodyGreenShadeBold14,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PIN: ${patient.pin}',
                                          style: kBodyWhiteBold12,
                                        ),
                                        SizedBox(
                                          width: 270,
                                          child: Text(
                                            'Doctor: ${patient.doctor}',
                                            style: kBodyWhiteBold12,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 270,
                                          height: 20,
                                          child: Text(
                                            'Dept: ${patient.deptName}',
                                            style: kBodyWhiteBold12,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 173, 202, 83),
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: Row(
                                            children: [
                                              const Spacer(),
                                              const Text(
                                                "Date: ",
                                                style: kBodyWhiteBold12,
                                              ),
                                              Text(
                                                date,
                                                style: kBodyBlackBold12,
                                              ),
                                              const Text(
                                                "\t\t\tTime: ",
                                                style: kBodyWhiteBold12,
                                              ),
                                              Text(
                                                time,
                                                style: kBodyBlackBold12,
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      patient.bedNumber,
                                      style: kBodyWhiteBold11,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: const Color.fromARGB(255, 173, 202, 83),
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              children: [
                // SpeedDialChild(
                //   child: const Icon(Icons.message, color: Colors.white),
                //   backgroundColor: Colors.red,
                //   label: 'Message',
                //   labelStyle: const TextStyle(fontSize: 18.0),
                //   onTap: () => print('Message Clicked'),

                SpeedDialChild(
                  child: const Icon(Icons.logout_outlined,
                      color: Color.fromARGB(255, 173, 202, 83)),
                  backgroundColor: const Color.fromARGB(255, 42, 42, 42),
                  label: 'Logout',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  onTap: _logout,
                ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
