part of 'form_cubit.dart';

class FormCubitState extends Equatable {
  const FormCubitState({
    required this.isErrorShown,
    required this.isFormDataValid,
    required this.isSubmitting,
    required this.isSubmitted,
    required this.isInitial,
  });

  final bool isInitial;
  final bool isErrorShown;
  final bool isFormDataValid;
  final bool isSubmitting;
  final bool isSubmitted;

  FormCubitState copyWith({
    bool? isInitial,
    bool? isErrorShown,
    bool? isFormValid,
    bool? isSubmitting,
    bool? isSubmitted,
  }) {
    assert(isSubmitting != true || this.isFormDataValid);
    return FormCubitState(
      isInitial: isInitial ?? this.isInitial,
      isErrorShown: isErrorShown ?? this.isErrorShown,
      isFormDataValid: isFormValid ?? this.isFormDataValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  bool get hasErrorToShow => !isFormDataValid && isErrorShown;

  @override
  List<Object> get props => [
        isInitial,
        isErrorShown,
        isFormDataValid,
        isSubmitting,
        isSubmitted,
      ];
}
