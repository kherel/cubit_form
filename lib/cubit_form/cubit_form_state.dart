part of 'cubit_form_cubit.dart';

class CubitFormState extends Equatable {
  final Map<String, dynamic> values;
  final Map<String, String> errors;
  final isSubmiting;
  final hasSubmitted;

  const CubitFormState({
    @required this.values,
    @required this.errors,
    this.isSubmiting = false,
    this.hasSubmitted = false,
  });

  get isValid => !errors.containsValue((String value) => value.isNotEmpty);

  @override
  List<Object> get props => [values, errors, isSubmiting];
}

class InitialCubitFormState extends CubitFormState {
  InitialCubitFormState({
    Map<String, dynamic> values,
  }) : super(
            errors: Map.fromIterable(
              values.keys,
              key: (e) => e,
              value: (_) => null,
            ),
            values: values);
}
