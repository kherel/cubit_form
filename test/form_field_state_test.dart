import 'package:cubit_form/logic/field_cubit/field_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formFieldState', () {
    test('should show isValid false if state has an error', () {
      var state = FieldCubitState(
        value: 'value',
        error: 'error',
        isErrorShown: false,
      );

      expect(state.isValid, isFalse);
    });

    test('should show no shownError if isErrorShown is false', () {
      var state = FieldCubitState(
        value: 'value',
        error: 'error',
        isErrorShown: false,
      );

      expect(state.shownError, isNull);
    });
  });
}
