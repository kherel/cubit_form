part of 'form_cubit.dart';

abstract class FormCubitState extends Equatable {
  const FormCubitState({
    required this.isBusy,
    required this.isSubmitted,
    required this.isInitial,
  });

  final bool isInitial;

  bool get isSubmitting => isBusy;

  final bool isBusy;
  final bool isSubmitted;

  @override
  List<Object> get props => [
        isInitial,
        isBusy,
        isSubmitted,
      ];
}
