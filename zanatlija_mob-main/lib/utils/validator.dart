bool isEmailValid(String email) {
  final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return regex.hasMatch(email);
}

bool isPhoneNumberValid(String phoneNumber) {
  final regex = RegExp(r'^(06[0-9]{8}|0[3-9][0-9]{7})$');
  return regex.hasMatch(phoneNumber);
}

bool isValidFullname(String name) {
  final regex = RegExp(r'^[A-Za-z]+ [A-Za-z]+$');
  return regex.hasMatch(name);
}
