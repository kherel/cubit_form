import 'package:cubit_form/cubit_form.dart';
import 'package:email_validator/email_validator.dart';

class RequiredIntValidation extends ValidationModel<int> {
  RequiredIntValidation(String errorText)
      : super((value) => value <= 0, errorText);
}

class RequiredNotNullValidation<T> extends ValidationModel<T> {
  RequiredNotNullValidation(String errorText)
      : super((value) => value == null, errorText);
}

class RequiredStringValidation extends ValidationModel<String> {
  RequiredStringValidation(String errorText)
      : super((s) => s.isEmpty, errorText);
}

class MinLengthValidation extends ValidationModel<String> {
  MinLengthValidation(int n, String errorText)
      : super((s) => s.length < n, errorText);
}

class MaxLengthValidation extends ValidationModel<String> {
  MaxLengthValidation(int n, String errorText)
      : super((s) => s.length > n, errorText);
}

class EmailStringValidation extends ValidationModel<String> {
  EmailStringValidation(String errorText)
      : super((email) => !EmailValidator.validate(email), errorText);
}

class LengthStringValidation extends ValidationModel<String> {
  LengthStringValidation(int length, String errorText)
      : super((n) => n.length != length, errorText);
}

class PhoneStringValidation extends ValidationModel<String> {
  PhoneStringValidation(int numberLength, String errorText)
      : super((n) => n.replaceAll(RegExp(r'\D'), '').length != numberLength,
            errorText);
}

class RegExpValidation extends ValidationModel<String> {
  RegExpValidation(RegExp regExp, String errorText)
      : super((s) => !regExp.hasMatch(s), errorText);
}

class CombinedValidation<T> extends ValidationModel<T> {
  CombinedValidation(CombinedTest test, ValidationModel<T> innerValidation)
      : super((T value) => test() && innerValidation.test(value),
            innerValidation.errorMassage);
}

typedef ValidationTest<T> = bool Function(T value);
typedef CombinedTest = bool Function();
