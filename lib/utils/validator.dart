class Validator {
  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null ||
        phoneNumber.isEmpty ||
        !RegExp(r'\([\d]{2}\) [\d]{5}-[\d]{4}').hasMatch(phoneNumber)) {
      return 'Digite um número de telefone válido';
    }
    return null;
  }
}
