import 'package:get/get.dart';
import '../controllers/shopping_assistant_controller.dart';

class ShoppingAssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShoppingAssistantController());
  }
}
