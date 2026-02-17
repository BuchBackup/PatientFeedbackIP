import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:new_bih_feedback/controllers/login_controller.dart';
import 'package:new_bih_feedback/services/apis.dart';
import 'package:new_bih_feedback/services/constent.dart';
import 'package:new_bih_feedback/views/admitted_patient_view.dart';
import 'package:new_bih_feedback/views/home_view.dart';
import 'package:new_bih_feedback/views/no_network.dart';
import 'package:new_bih_feedback/widgets/my_toast.dart';
import 'package:new_bih_feedback/widgets/search_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  bool showPassword = true;
  bool isLoading = false;

  final loginDataController = Get.put(LoginDataController());

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login(String pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userPin', pin);
    Get.to(
      () => const AdmittedPatientView(),
      // const PatientListScreen(),
      // duration: const Duration(seconds: 1),
      transition: Transition.leftToRight,
    );

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const HomeView()),
    // );
  }
  /////////////////////////////

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return NetworkAwareWidget(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          body: PopScope(
            canPop: false,
            child: ModalProgressHUD(
              progressIndicator: const CircularProgressIndicator(
                color: Color.fromARGB(255, 172, 202, 83),
              ),
              inAsyncCall: isLoading,
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context)
                            .viewInsets
                            .bottom, // Adds padding for the keyboard
                      ),
                      child: Form(
                        key: _formKey,
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 42, 42, 42),
                                    // color: const Color.fromARGB(255, 170, 202, 81),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 247, 244, 244)
                                            .withOpacity(0.5),
                                        // const Color.fromARGB(255, 42, 42, 43)
                                        //     .withOpacity(0.5),
                                        spreadRadius: 8,
                                        blurRadius: 8,
                                        offset: const Offset(
                                          1,
                                          5,
                                        ), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  height: 425,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "LogIn",
                                          style: kBodyWhiteBold24,
                                        ),
                                        const Text(
                                          "To Login in, kindly enter\nyour credentials",
                                          textAlign: TextAlign.center,
                                          style: kBodyWhite14,
                                        ),
                                        MyTextField(
                                          style: kBodyWhite12,
                                          hintStyle: kBodyWhite12,
                                          hintText: "Enter Email ID",
                                          prefixIcon: const Icon(
                                            Icons.email_outlined,
                                            color: Color.fromARGB(
                                                255, 170, 202, 81),
                                          ),
                                          controller: emailCon,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter email';
                                            }
                                            if (!RegExp(
                                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                                .hasMatch(value)) {
                                              return 'Please  enter  valid email';
                                            }

                                            return null;
                                          },
                                        ),
                                        MyTextField(
                                          style: kBodyWhite12,
                                          hintStyle: kBodyWhite12,
                                          hintText: 'Password',
                                          inputType:
                                              TextInputType.visiblePassword,
                                          isObsecure: showPassword,
                                          // lableText: 'Password',
                                          controller: passCon,
                                          prefixIcon: const Icon(
                                              Icons.lock_outline,
                                              color: Color.fromARGB(
                                                  255, 170, 202, 81)),
                                          suffixIcon: IconButton(
                                            icon: showPassword
                                                ? const Icon(
                                                    Icons
                                                        .remove_red_eye_outlined,
                                                    color: Colors.grey,
                                                  )
                                                : const Icon(
                                                    Icons.remove_red_eye,
                                                    color: Color.fromARGB(
                                                        255, 170, 202, 81),
                                                  ),
                                            onPressed: () {
                                              setState(() {
                                                showPassword = !showPassword;
                                              });
                                            },
                                          ),
                                          inputFormater: [
                                            LengthLimitingTextInputFormatter(15)
                                          ],
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter password';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                Apis api = Apis();
                                                //TODO: remove this before publish
                                                isLoading = true;
                                                // emailCon.text = "ghazanfarabbas@buchhospital.com";
                                                // passCon.text = "ghani121223";

                                                var empId = await api.login(
                                                    emailCon.text,
                                                    passCon.text);

                                                if (empId != null &&
                                                    empId !=
                                                        ApiStatus.failed.name) {
                                                  setState(() {
                                                    isLoading = false;
                                                  });

                                                  _login(empId);
                                                  Get.to(
                                                    () =>
                                                        const AdmittedPatientView(),
                                                    // duration: const Duration(
                                                    //     ),
                                                    transition:
                                                        Transition.fadeIn,
                                                  );
                                                } else {
                                                  myToast(
                                                      const Color.fromARGB(
                                                          255, 170, 202, 81),
                                                      "Authorization Error",
                                                      Colors.black);
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 170, 202, 81)),
                                            child: const Text(
                                              "Login",
                                              style: kBodyBlack12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
