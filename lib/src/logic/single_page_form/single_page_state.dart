part of 'single_page_cubit.dart';

class SinglePageFormState extends FormCubitState {
  const SinglePageFormState({
    required this.isErrorShown,
    required this.isFormDataValid,
    required super.isBusy,
    required super.isSubmitted,
    required super.isInitial,
  });

  final bool isErrorShown;
  final bool isFormDataValid;

  SinglePageFormState copyWith({
    bool? isInitial,
    bool? isErrorShown,
    bool? isFormValid,
    bool? isBusy,
    bool? isSubmitted,
  }) {
    assert(isSubmitting != true || this.isFormDataValid);
    return SinglePageFormState(
      isInitial: isInitial ?? this.isInitial,
      isErrorShown: isErrorShown ?? this.isErrorShown,
      isFormDataValid: isFormValid ?? this.isFormDataValid,
      isBusy: isBusy ?? this.isBusy,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  bool get hasErrorToShow => !isFormDataValid && isErrorShown;

  @override
  List<Object> get props => [
        isInitial,
        isErrorShown,
        isFormDataValid,
        isBusy,
        isSubmitted,
      ];
}
