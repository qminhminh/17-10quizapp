import 'dart:async';
import 'package:get/get.dart';

class CountdownController extends GetxController {
  var minutes = 0.obs;
  var seconds = 0.obs;
  var isRunning = false.obs; // Added to track if the countdown is running

  Timer? _timer;

  void startCountdown(int totalSeconds) {
    minutes.value = (totalSeconds ~/ 60);
    seconds.value = (totalSeconds % 60);

    if (totalSeconds > 0) {
      // ignore: prefer_const_constructors
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (totalSeconds > 0) {
          totalSeconds--;
          minutes.value = (totalSeconds ~/ 60);
          seconds.value = (totalSeconds % 60);
        } else {
          timer.cancel();
          isRunning.value =
              false; // Set isRunning to false when countdown finishes
        }
      });

      isRunning.value = true; // Set isRunning to true when countdown starts
    }
  }

  void stop() {
    _timer?.cancel();
    isRunning.value =
        false; // Set isRunning to false when countdown is manually stopped
  }
}
