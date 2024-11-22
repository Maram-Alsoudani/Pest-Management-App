import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/reports/domain/use_cases/get_report_of_site.dart';
import 'package:pesticides/Features/reports/presentation/manager/get_report_of_site_states.dart';

@injectable
class ReportOfSiteViewModel extends Cubit<GetReportOfSiteState> {
  GetReportOfSiteUseCase useCase;

  ReportOfSiteViewModel({required this.useCase})
      : super(GetReportOfSiteLoadingState());
  bool isLoading = false;
  double opacity = 1.0;

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  void initializeAnimation(SingleTickerProviderStateMixin single) {
    animationController = AnimationController(
        vsync: single, duration: const Duration(seconds: 1));

    slideAnimation = slideAnimation =
        Tween<Offset>(begin: Offset(-1.w, 0), end: const Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    animationController.forward();
  }

  Future<void> getReportOfSite(String siteId) async {
    isLoading = true;
    emit(GetReportOfSiteLoadingState());
    var reportResponse = await useCase.invoke(siteId);
    reportResponse.fold((failure) {
      isLoading = false;
      emit(GetReportOfSiteErrorState(errorMessage: failure.errorMessage));
    }, (report) {
      isLoading = false;
      emit(GetReportOfSiteSuccessState(siteReport: report));
    });
  }

  @override
  Future<void> close() {
    // TODO: implement close

    return super.close();
  }
}
