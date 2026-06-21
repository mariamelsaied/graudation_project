
import 'package:graduation_app/models/chatbot_model.dart';

abstract class ChatbotState {}

class ChatbotInitial extends ChatbotState {}
class ChatbotLoading extends ChatbotState {}
class ChatbotSuccess extends ChatbotState {
  final List<ChatMessage> messages;
  ChatbotSuccess(this.messages);
}
class ChatbotError extends ChatbotState {
  final String message;
  ChatbotError(this.message);
}