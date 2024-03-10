class Validator {
  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null ||
        phoneNumber.isEmpty ||
        !entirelyMatch(RegExp(r'\(\d{2}\) \d{4,5}-\d{4}'), phoneNumber)) {
      return 'Digite um número de telefone válido';
    }
    return null;
  }

  static bool entirelyMatch(RegExp regex, String target) {
    if (regex.hasMatch(target)) {
      Iterable<Match> matches = regex.allMatches(target);
      Match first = matches.first;
      return first.start == 0 && first.end == target.length;
    }
    return false;
  }

  static bool isInteger(String? str) {
    if (str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  static String formatDate(DateTime date) {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String formatDatetime(DateTime dateTime) {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String getMonthAbbr(int monthNumber) {
    List<String> monthStrs = <String>['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    return monthStrs[monthNumber - 1];
  }
}
