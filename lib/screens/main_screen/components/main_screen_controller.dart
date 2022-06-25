import 'package:get/get.dart';

class MainScreenController extends GetxController {
  RxList isHovering = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ].obs;

  RxBool scrolled = false.obs;
}
