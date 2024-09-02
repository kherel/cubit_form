part of 'multi_page_cubit.dart';

class MultiPageFormState extends FormCubitState {
  const MultiPageFormState({
    required this.errorShownOnPagesList,
    required this.pageValidityList,
    required super.isBusy,
    required super.isSubmitted,
    required super.isInitial,
  });

  factory MultiPageFormState.initial(int pageCount) {
    return MultiPageFormState(
      errorShownOnPagesList: List.generate(pageCount, (_) => false),
      pageValidityList: List.generate(pageCount, (_) => false),
      isInitial: true,
      isBusy: false,
      isSubmitted: false,
    );
  }

  final List<bool> errorShownOnPagesList;
  final List<bool> pageValidityList;

  bool isErrorShownPerPage(int pageIndex) => errorShownOnPagesList[pageIndex];
  bool isFormDataValidPerPage(int pageIndex) => pageValidityList[pageIndex];

  bool get isAllValid => pageValidityList.every((element) => element);

  MultiPageFormState copyWith({
    bool? isInitial,
    List<bool>? errorShownOnPagesList,
    List<bool>? pageValidityList,
    bool? isBusy,
    bool? isSubmitted,
  }) {
    assert(isSubmitting != true || isAllValid);
    return MultiPageFormState(
      isInitial: isInitial ?? this.isInitial,
      errorShownOnPagesList:
          errorShownOnPagesList ?? this.errorShownOnPagesList,
      pageValidityList: pageValidityList ?? this.pageValidityList,
      isBusy: isBusy ?? this.isBusy,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  bool hasErrorToShow(int pageIndex) =>
      !isFormDataValidPerPage(pageIndex) && isErrorShownPerPage(pageIndex);

  @override
  List<Object> get props => [
        isInitial,
        isSubmitting,
        isSubmitted,
        errorShownOnPagesList,
        pageValidityList,
      ];
}
