import 'dart:async';

import 'package:get/get.dart';

class CountdownController extends GetxController {
  var minutes = 0.obs;
  var seconds = 0.obs;

  void startCountdown(int totalSeconds) {
    minutes.value = (totalSeconds ~/ 60);
    seconds.value = (totalSeconds % 60);

    if (totalSeconds > 0) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (totalSeconds > 0) {
          totalSeconds--;
          minutes.value = (totalSeconds ~/ 60);
          seconds.value = (totalSeconds % 60);
        } else {
          timer.cancel();
        }
      });
    }
  }
}
