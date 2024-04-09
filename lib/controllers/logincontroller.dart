import 'package:get/get.dart';

class LoginController extends GetxController {
  var email=''.obs;
  var first_name=''.obs;
  var last_name=''.obs;
  updateEmail(em){
    email.value = em;
  }
  updateFirstName(fn){
    first_name.value = fn;
  }
  updateLastName(ln){
    last_name.value = ln;
  }
  var isHidden = false.obs;
  toggleHide() {
    isHidden.value = !isHidden.value;
  }
}
