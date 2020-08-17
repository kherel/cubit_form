import 'package:cubit_form/cubit_form/field_model.dart';
import 'package:cubit_form/logic/form_field/form_field_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  var initialValue = 'initial value';
  var newValue = 'newValue';

  test("should set initial value", () async {
    var cubit = FormFieldCubit<String>(initalValue: initialValue);

    expect(cubit.state.value, equals(initialValue));
    expect(cubit.state.error, equals(null));
    expect(cubit.state.isErrorShown, equals(false));
    expect(cubit.state.isValid, equals(true));
  });

  group('value group', () {
    blocTest<FormFieldCubit<String>, FormFieldState<String>>(
      'should set value',
      build: () => FormFieldCubit<String>(initalValue: initialValue),
      act: (FormFieldCubit cubit) => cubit.setValue(newValue),
      expect: <FormFieldState<String>>[
        FormFieldState<String>(value: newValue),
      ],
    );

    blocTest<FormFieldCubit<String>, FormFieldState<String>>(
      'should reset value',
      build: () => FormFieldCubit<String>(initalValue: initialValue),
      act: (FormFieldCubit cubit) => cubit
        ..setValue(newValue)
        ..reset(),
      expect: <FormFieldState<String>>[
        FormFieldState<String>(value: newValue),
        FormFieldState<String>(value: initialValue),
      ],
    );
  });

  group('validation errors', () {
    var value1 = 'value1';
    var value2 = 'value2';
    var value3 = 'value3';

    var error1 = 'error1';
    var error2 = 'error2';

    blocTest<FormFieldCubit<String>, FormFieldState<String>>(
      'should validate',
      build: () => FormFieldCubit<String>(
        initalValue: initialValue,
        validations: [
          ValidationModel((val) => val == value1, error1),
          ValidationModel((val) => val == value2, error2),
        ],
      ),
      act: (FormFieldCubit cubit) =>
          cubit..setValue(value1)..setValue(value2)..setValue(value3),
      expect: <FormFieldState<String>>[
        FormFieldState<String>(value: value1, error: error1),
        FormFieldState<String>(value: value2, error: error2),
        FormFieldState<String>(value: value3),
      ],
    );

    blocTest<FormFieldCubit<String>, FormFieldState<String>>(
      'should reset errors and isErrorShown after reset cubit',
      build: () => FormFieldCubit<String>(
        initalValue: initialValue,
        validations: [
          ValidationModel((val) => val == value1, error1),
        ],
      ),
      act: (FormFieldCubit cubit) => cubit
        ..setValue(value1)
        ..showError()
        ..reset(),
      skip: 1,
      expect: <FormFieldState<String>>[
        FormFieldState<String>(
          value: value1,
          error: error1,
          isErrorShown: true,
        ),
        FormFieldState<String>(
          value: initialValue,
          error: null,
          isErrorShown: false,
        ),
      ],
    );

    blocTest<FormFieldCubit<String>, FormFieldState<String>>(
      'should emit state with isErrorShown true, when showError trigered',
      build: () => FormFieldCubit<String>(
        initalValue: initialValue,
      ),
      act: (FormFieldCubit cubit) => cubit..showError(),
      expect: <FormFieldState<String>>[
        FormFieldState<String>(
          value: initialValue,
          error: null,
          isErrorShown: true,
        ),
      ],
    );
  });

  group('formFieldState', () {
    test('should show isValid false if state has an error', () {
      var state = FormFieldState(
        error: 'error',
      );

      expect(state.isValid, isFalse);
    });

    test('should show no shownError if isErrorShown is false', () {
      var state = FormFieldState(
        error: 'error',
      );

      expect(state.shownError, isNull);
    });
  });
}
