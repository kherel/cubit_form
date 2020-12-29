import 'package:cubit_form/cubit_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  var initialValue = 'initial value';
  var newValue = 'newValue';

  test("should set initial value", () async {
    var cubit = FieldCubit<String>(initalValue: initialValue);

    expect(cubit.state.value, equals(initialValue));
    expect(cubit.state.error, equals(null));
    expect(cubit.state.isErrorShown, equals(false));
    expect(cubit.state.isValid, equals(true));
  });

  group('value group', () {
    blocTest<FieldCubit<String>, FieldCubitState<String>>(
      'should set value',
      build: () => FieldCubit<String>(initalValue: initialValue),
      act: (FieldCubit cubit) => cubit.setValue(newValue),
      expect: <FieldCubitState<String>>[
        FieldCubitState<String>(
          value: newValue,
          error: null,
          isErrorShown: false,
        ),
      ],
    );

    blocTest<FieldCubit<String>, FieldCubitState<String>>(
      'should reset value and set InitialFieldCubitState',
      build: () => FieldCubit<String>(initalValue: initialValue),
      act: (FieldCubit cubit) => cubit
        ..setValue(newValue)
        ..reset(),
      expect: <FieldCubitState<String>>[
        FieldCubitState<String>(
          value: newValue,
          error: null,
          isErrorShown: false,
        ),
        InitialFieldCubitState<String>(
          initalValue: initialValue,
          error: null,
        ),
      ],
    );
  });

  group('validation errors', () {
    var value1 = 'value1';
    var value2 = 'value2';
    var value3 = 'value3';

    var error1 = 'error1';
    var error2 = 'error2';

    blocTest<FieldCubit<String>, FieldCubitState<String>>(
      'should validate',
      build: () => FieldCubit<String>(
        initalValue: initialValue,
        validations: [
          ValidationModel((val) => val == value1, error1),
          ValidationModel((val) => val == value2, error2),
        ],
      ),
      act: (FieldCubit cubit) =>
          cubit..setValue(value1)..setValue(value2)..setValue(value3),
      expect: <FieldCubitState<String>>[
        FieldCubitState<String>(
          value: value1,
          error: error1,
          isErrorShown: false,
        ),
        FieldCubitState<String>(
          value: value2,
          error: error2,
          isErrorShown: false,
        ),
        FieldCubitState<String>(
          value: value3,
          error: null,
          isErrorShown: false,
        ),
      ],
    );

    blocTest<FieldCubit<String>, FieldCubitState<String>>(
      'should reset errors and isErrorShown after reset cubit',
      build: () => FieldCubit<String>(
        initalValue: initialValue,
        validations: [
          ValidationModel((val) => val == value1, error1),
        ],
      ),
      act: (FieldCubit cubit) => cubit
        ..setValue(value1)
        ..showError()
        ..reset(),
      skip: 1,
      expect: <FieldCubitState<String>>[
        FieldCubitState<String>(
          value: value1,
          error: error1,
          isErrorShown: true,
        ),
        InitialFieldCubitState<String>(
          initalValue: initialValue,
          error: null,
        ),
      ],
    );

    blocTest<FieldCubit<String>, FieldCubitState<String>>(
      'should emit state with isErrorShown true, when showError trigered',
      build: () => FieldCubit<String>(
        initalValue: initialValue,
      ),
      act: (FieldCubit cubit) => cubit..showError(),
      expect: <FieldCubitState<String>>[
        FieldCubitState<String>(
          value: initialValue,
          error: null,
          isErrorShown: true,
        ),
      ],
    );
  });
  group('validation', () {
    test("should have error, when initial value not valid", () async {
      var cubit = FieldCubit<String>(
        initalValue: initialValue,
        validations: [
          ValidationModel((val) => val == initialValue, 'error'),
        ],
      );

      expect(cubit.state.error, equals('error'));
      expect(cubit.state.isValid, isFalse);
    });

    test("should n't have error, when initial value is valid", () async {
      var cubit = FieldCubit<String>(
        initalValue: initialValue,
        validations: [
          ValidationModel((val) => val != initialValue, 'error'),
        ],
      );

      expect(cubit.state.error, isNull);
      expect(cubit.state.isValid, isTrue);
    });

    blocTest<FieldCubit<String>, FieldCubitState<String>>(
      'should emit state with isErrorShown true, when showError trigered',
      build: () => FieldCubit<String>(
        initalValue: initialValue,
        validations: [
          ValidationModel((val) => val != 'value1', 'error1'),
          ValidationModel((val) => val != 'value2', 'error2'),
        ],
      ),
      act: (FieldCubit cubit) => cubit..setValue('value0')..setValue('value1'),
      expect: <FieldCubitState<String>>[
        FieldCubitState<String>(
          value: 'value0',
          error: 'error1',
          isErrorShown: false,
        ),
        FieldCubitState<String>(
          value: 'value1',
          error: 'error2',
          isErrorShown: false,
        ),
      ],
    );
  });
}
