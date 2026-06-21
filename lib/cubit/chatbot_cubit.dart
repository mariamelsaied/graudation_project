import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/cubit/chatbot_state.dart';
import 'package:graduation_app/models/chatbot_model.dart';
import 'package:graduation_app/services/secure_storage.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final SecureStorage _storage = SecureStorage();
  

  final List<ChatMessage> messages = [];

  ChatbotCubit() : super(ChatbotInitial()) {
    messages.add(ChatMessage(
      text: "Hello. Welcome to Staffly HRMS. How can I assist you today with managing your workforce, reviewing payroll, or other HR-related tasks?", 
      isUser: false,
    ));
    emit(ChatbotSuccess(List.from(messages)));
  }

  Future<void> askChatbot(String question) async {
    if (question.trim().isEmpty) return;

   
    messages.add(ChatMessage(text: question, isUser: true));
    emit(ChatbotSuccess(List.from(messages)));
    

    emit(ChatbotLoading());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {};
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(ChatbotError("Access token is required. Please log in."));
      emit(ChatbotSuccess(List.from(messages)));
      return;
    }

    try {
      final response = await DioHelper.dio.post(
        '/api/chatbot/ask',
        data: {
          'message': question, 
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final String replyMessage = response.data['data']?['reply'] ?? "No response received";
        
  
        messages.add(ChatMessage(text: replyMessage, isUser: false));
        emit(ChatbotSuccess(List.from(messages)));
      } else {
        emit(ChatbotError("Failed to load response from Chatbot"));
        emit(ChatbotSuccess(List.from(messages)));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(ChatbotError(errorMessage));
      emit(ChatbotSuccess(List.from(messages))); 
    } catch (e) {
      emit(ChatbotError(e.toString()));
      emit(ChatbotSuccess(List.from(messages)));
    }
  }
}