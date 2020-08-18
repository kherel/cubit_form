part of 'form_cubit.dart';

class FormCubitState extends Equatable {
  const FormCubitState({
    @required this.isErrorShown,
    @required this.isFormValid,
    @required this.isSubmitting,
    @required this.isSubmitted,
  });

  final bool isErrorShown;
  final bool isFormValid;
  final bool isSubmitting;
  final bool isSubmitted;

  FormCubitState copyWith({
    bool isErrorShown,
    bool isFormValid,
    bool isSubmitting,
    bool isSubmitted,
  }) {
    assert(isSubmitting != true || this.isFormValid);
    return FormCubitState(
      isErrorShown: isErrorShown ?? this.isErrorShown,
      isFormValid: isFormValid ?? this.isFormValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object> get props => [isErrorShown, isFormValid];
}
