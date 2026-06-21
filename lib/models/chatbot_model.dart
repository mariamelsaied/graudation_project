
class ChatbotResponseModel {
  final String status;
  final String reply;

  ChatbotResponseModel({required this.status, required this.reply});

  factory ChatbotResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatbotResponseModel(
      status: json['status'] ?? '',
      reply: json['data']?['reply'] ?? '',
    );
  }
}


class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}