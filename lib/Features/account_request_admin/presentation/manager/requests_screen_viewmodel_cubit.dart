import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/account_request_admin/domain/use_cases/decline_requests_user_case%20copy.dart';
import 'package:bug_away/Features/account_request_admin/domain/use_cases/accept_requests_user_case.dart';
import 'package:bug_away/Features/account_request_admin/domain/use_cases/delete_requests_user_case.dart';
import 'package:bug_away/Features/account_request_admin/domain/use_cases/get_requests_user_case.dart';
import 'package:bug_away/Features/user_request_account/domain/entities/user_request_account_model_entity.dart';

part 'requests_screen_viewmodel_state.dart';

@injectable
class RequestsScreenViewmodelCubit extends Cubit<RequestsScreenViewmodelState> {
  GetRequestsUseCase getRequestsUseCase;
  AcceptRequestsUseCase acceptRequestsUseCase;
  DeclineRequestsUseCase declineRequestsUseCase;
  DeleteRequestsUseCase deleteRequestsUseCase;
  RequestsScreenViewmodelCubit(
      {required this.getRequestsUseCase,
      required this.acceptRequestsUseCase,
      required this.deleteRequestsUseCase,
      required this.declineRequestsUseCase})
      : super(RequestsScreenViewmodelInitial());
  static RequestsScreenViewmodelCubit get(context, [bool? listen]) =>
      BlocProvider.of(context, listen: listen ?? false);
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();
  List<UserRequestAccountEntity> requests = [];
  String dateTime = "";
  Future<void> getRequest() async {
    isLoading = true;
    emit(RequestsScreenViewmodelLoading());
    var either = await getRequestsUseCase.getRequests();
    either.fold((l) {
      isLoading = false;
      emit(RequestsScreenViewmodelError(error: l));
    }, (stream) {
      isLoading = false;
      stream.listen((request) {
        scrollToBottom();
        requests = request.docs.map((e) {
          dateTime = formatDateTime(e.data().dateTime);
          return e.data();
        }).toList();

        emit(RequestsScreenViewmodelSuccess());
      });
    });
  }

  Future<void> acceptRequest(UserRequestAccountEntity user) async {
    isLoading = true;
    emit(AcceptRequestsScreenViewmodelLoading());
    var either = await acceptRequestsUseCase.acceptRequests(user);
    either.fold((l) {
      isLoading = false;

      emit(AcceptRequestsScreenViewmodelError(error: l));
    }, (r) {
      isLoading = false;
      emit(AcceptRequestsScreenViewmodelSuccess());
    });
  }

  Future<void> declineRequest(UserRequestAccountEntity user) async {
    isLoading = true;
    emit(DeclineRequestsScreenViewmodelLoading());
    var either = await declineRequestsUseCase.declineRequests(user);
    either.fold((l) {
      isLoading = false;

      emit(DeclineRequestsScreenViewmodelError(error: l));
    }, (r) {
      isLoading = false;
      emit(DeclineRequestsScreenViewmodelSuccess());
    });
  }

  Future<void> deleteRequest(String id) async {
    isLoading = true;
    emit(DeleteRequestsScreenViewmodelLoading());
    var either = await deleteRequestsUseCase.deleteRequests(id);
    either.fold((l) {
      isLoading = false;

      emit(DeleteRequestsScreenViewmodelError(error: l));
    }, (r) {
      isLoading = false;
      emit(DeleteRequestsScreenViewmodelSuccess());
    });
  }

  String formatDateTime(DateTime date) {
    DateFormat formatter = DateFormat("yyyy-MM-dd");
    String formatted = formatter.format(date);
    return formatted;
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
