import 'package:get/state_manager.dart';

class FeedbackRatingController extends GetxController {
  List<int> selectedOptions = List.filled(10, 0); // Default: no selection (0)
  RxBool isSubmitEnabled = false.obs;

  // Updates the selected option for a specific question
  void selectOption(int questionIndex, int option) {
    selectedOptions[questionIndex] = option;

    // Enable the submit button only when all questions are answered
    isSubmitEnabled.value = selectedOptions.every((option) => option != 0);

    update();
  }
}
