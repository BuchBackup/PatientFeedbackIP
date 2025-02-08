import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:new_bih_feedback/controllers/login_controller.dart';
import 'package:new_bih_feedback/views/admitted_patient_view.dart';
import 'package:new_bih_feedback/views/login_view.dart';
import 'package:new_bih_feedback/views/no_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/constent.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    _loadUserPin();
  }

/////////////////////////////////////////////////////////////
  Future<void> _loadUserPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginCon.userPin = prefs.getString('userPin') ?? '';
    });
  }

  //////////////////////////////////////////////////////////
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
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginView()),
    // );
  }

  final loginCon = Get.put(LoginDataController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return NetworkAwareWidget(
      child: PopScope(
        canPop: false,
        child: SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
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
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(
                            0.3), // Optional: To add a slight overlay color
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 150,
                                    ),
                                    SizedBox(
                                        height: 300,
                                        width: 260,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Welcome To",
                                              style: kBodyWhiteBold24,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              "Buch International Hospital",
                                              style: kBodyGreenRgb20,
                                            ),
                                            const Text(
                                              " Your feedback helps us improve our services. Please share your experience to help us provide even better care.",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 172, 202, 83),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  child: Text(
                                                    "Thank you for your support!",
                                                    style: kBodyBlackBold14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Divider(
                                              thickness: 2,
                                            )
                                          ],
                                        )),

                                    // const SizedBox(
                                    //   height: 200,
                                    // ),
                                    OutlinedButton(
                                      onPressed: () async {
                                        Get.to(
                                          () => const AdmittedPatientView(),
                                          // const PatientListScreen(),
                                          // duration: const Duration(seconds: 1),
                                          transition: Transition.leftToRight,
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        side: const BorderSide(
                                          width: 2.0,
                                          color:
                                              Color.fromARGB(255, 170, 202, 81),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 62, vertical: 7),
                                        child: Text(
                                          'START',
                                          style: kBodyGreenShadeBold14,
                                        ),
                                      ),
                                    ),

                                    ElevatedButton(
                                      onPressed: _logout,
                                      style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        backgroundColor: const Color.fromARGB(
                                            255, 170, 202, 81),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 60, vertical: 7),
                                        child: Text(
                                          "LogOut",
                                          style: kBodyBlackBold12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'LogIn ID: ',
                                              style: kBodyBlackBold14,
                                            ),
                                            Text(
                                              loginCon.userPin,
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
              )
            ],
          ),
        )),
      ),
    );
  }
}
