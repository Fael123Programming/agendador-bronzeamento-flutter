import 'package:flutter/services.dart';

class BrPhoneNumberFormatter extends TextInputFormatter {
  ///Text input formatter for the brazilian standard pattern for phone numbers:
  ///(xx) xxxxx-xxxx
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > 15) {
      return oldValue;
    }
    bool userIsInserting = oldValue.text.length < newValue.text.length;
    StringBuffer strBuffer = StringBuffer();
    String newValueStr = newValue.text;
    int newValueStrLength = newValueStr.length, cursorPos = 0;
    if (userIsInserting) {
      switch (newValueStrLength) {
        case 1:
          {
            strBuffer.write('($newValueStr');
            cursorPos = 2;
            break;
          }
        case 3:
          {
            strBuffer.write('$newValueStr) ');
            cursorPos = 5;
            break;
          }
        case 4:
          {
            strBuffer.write(
                '${oldValue.text}) ${newValueStr[newValueStrLength - 1]}');
            cursorPos = 6;
            break;
          }
        case 10:
          {
            strBuffer.write('$newValueStr-');
            cursorPos = 11;
            break;
          }
        case 11:
          {
            strBuffer.write(
                '${oldValue.text}-${newValueStr[newValueStrLength - 1]}');
            cursorPos = 12;
            break;
          }
        default:
          {
            strBuffer.write(newValueStr);
            cursorPos = newValueStrLength;
          }
      }
    } else {
      switch (newValueStrLength) {
        case 1:
          {
            strBuffer.write('');
            break;
          }
        case 4:
          {
            strBuffer.write(newValueStr.substring(0, newValueStrLength - 2));
            cursorPos = newValue.selection.end - 2;
            break;
          }
        case 5:
          {
            strBuffer.write(newValueStr.substring(0, newValueStrLength - 2));
            cursorPos = newValue.selection.end - 2;
            break;
          }
        case 10:
          {
            strBuffer.write(newValueStr.substring(0, newValueStrLength - 1));
            cursorPos = newValue.selection.end - 1;
            break;
          }
        case 11:
          {
            strBuffer.write(newValueStr.substring(0, newValueStrLength - 1));
            cursorPos = newValue.selection.end - 1;
            break;
          }
        default:
          {
            strBuffer.write(newValueStr);
            cursorPos = newValueStrLength;
          }
      }
    }
    return TextEditingValue(
      text: strBuffer.toString(),
      selection: TextSelection.collapsed(offset: cursorPos),
    );
  }
}
