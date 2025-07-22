import 'package:book/core/config/navigation_controller.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings {

  @override  
  void dependencies(){
    Get.put(NavigationController());
  }
}