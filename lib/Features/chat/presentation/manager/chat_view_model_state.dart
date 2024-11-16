part of 'chat_view_model_cubit.dart';

@immutable
sealed class ChatViewModelState {}

final class ChatViewModelInitial extends ChatViewModelState {}
final class ChatViewModelGetMessage extends ChatViewModelState {}
final class ChatViewModelFailGetMessage extends ChatViewModelState {
  final Failure error;

  ChatViewModelFailGetMessage({required this.error});



}
final class ChatViewModelButtonState extends ChatViewModelState {}
final class ChatViewModelAddMessage extends ChatViewModelState {}
final class ChatViewModelFailAddMessage extends ChatViewModelState {
  final Failure error;

  ChatViewModelFailAddMessage({required this.error});
}
