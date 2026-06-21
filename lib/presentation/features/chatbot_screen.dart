// chatbot_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/chatbot_cubit.dart';
import 'package:graduation_app/cubit/chatbot_state.dart';
import 'package:graduation_app/models/chatbot_model.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.pimaryColor, 
      appBar: AppBar(
        backgroundColor: ColorsApp.darknavyblueColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: ColorsApp.WhiteColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: ColorsApp.blueColor,
              radius: 18,
              child: Icon(Icons.smart_toy_outlined, color: ColorsApp.WhiteColor, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Staffly Bot",
                  style: TextStyle(
                    color: ColorsApp.WhiteColor, 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Online",
                  style: TextStyle(color: ColorsApp.greenColor, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatbotCubit, ChatbotState>(
              listener: (context, state) {
                if (state is ChatbotSuccess || state is ChatbotLoading) {
                  _scrollToBottom();
                }
                if (state is ChatbotError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message, style: TextStyle(color: ColorsApp.WhiteColor)),
                      backgroundColor: ColorsApp.redColor,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<ChatbotCubit>();
                List<ChatMessage> currentMessages = cubit.messages;
                bool isBotTyping = (state is ChatbotLoading);

                if (currentMessages.isEmpty) {
                  return Center(
                    child: Text(
                      "No conversation yet.",
                      style: TextStyle(color: ColorsApp.greyColor),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: currentMessages.length + (isBotTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == currentMessages.length && isBotTyping) {
                      return _buildTypingIndicator();
                    }
                    
                    final message = currentMessages[index];
                    return _buildChatBubble(message);
                  },
                );
              },
            ),
          ),
          _buildInputArea(context),
        ],
      ),
    );
  }
  Widget _buildChatBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, 
        ),
        decoration: BoxDecoration(
          color: message.isUser ? ColorsApp.blueColor : ColorsApp.secondaryBlueColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 16),
          ),
          border: message.isUser ? null : Border.all(color: ColorsApp.borderGrey, width: 1),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: ColorsApp.WhiteColor,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: ColorsApp.secondaryBlueColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(ColorsApp.blueColor),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Staffly Bot is thinking...",
              style: TextStyle(color: ColorsApp.greyColor, fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24, top: 10),
      color: ColorsApp.darknavyblueColor, 
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ColorsApp.secondaryBlueColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: ColorsApp.borderGrey),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: ColorsApp.WhiteColor),
                cursorColor: ColorsApp.blueColor,
                decoration: InputDecoration(
                  hintText: "Ask Staffly AI...",
                  hintStyle: TextStyle(color: ColorsApp.greyColor, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: ColorsApp.blueColor,
            radius: 22,
            child: IconButton(
              icon: Icon(Icons.send_rounded, color: ColorsApp.WhiteColor, size: 20),
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  context.read<ChatbotCubit>().askChatbot(text);
                  _controller.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}