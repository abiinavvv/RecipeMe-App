import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:recipeme_app/models/app_state.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final String apiKey = "AIzaSyBhPPSTI8OgYUy2kqWAIECU_-7nbWTZYE8"; // Replace with your actual API key

  Future<void> sendMessage(String message) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    
    setState(() => _messages.add(ChatMessage(text: message, isUser: true)));

    try {
      final response = await model.generateContent([Content.text(message)]);
      setState(() => _messages.add(ChatMessage(text: response.text!, isUser: false)));
    } catch (e) {
      setState(() => _messages.add(ChatMessage(text: "Error: $e", isUser: false)));
    }

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppState>(context).isDarkMode;
    final theme = _getTheme(isDarkMode);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: _buildAppBar(isDarkMode),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) => MessageBubble(message: _messages[index], isDarkMode: isDarkMode),
              ),
            ),
            _buildInputArea(isDarkMode),
          ],
        ),
      ),
    );
  }

  ThemeData _getTheme(bool isDarkMode) {
    return isDarkMode
        ? ThemeData.dark().copyWith(
            primaryColor: Colors.deepOrange,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        : ThemeData.light().copyWith(
            primaryColor: Colors.orange,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
            ),
          );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: isDarkMode ? Colors.deepOrange : Colors.orange[200],
              child: Text('AI', style: TextStyle(color: isDarkMode ? Colors.black : Colors.white)),
            ),
            const SizedBox(width: 10),
            const Text('Chef AI'),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: "Message...",
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildSendButton(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSendButton(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        if (_controller.text.isNotEmpty) {
          sendMessage(_controller.text);
          _controller.clear();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.deepOrange, Colors.orange]
                : [Colors.orange, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(Icons.send, color: Colors.white, size: 20),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDarkMode;

  const MessageBubble({super.key, required this.message, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: message.isUser
              ? (isDarkMode ? Colors.deepOrange[700] : const Color(0xFFFFE5B4))
              : (isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: parseMarkdown(message.text, isDarkMode),
      ),
    );
  }

  Widget parseMarkdown(String text, bool isDarkMode) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(r'\*\*(.*?)\*\*');
    int lastIndex = 0;

    for (Match match in exp.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: TextStyle(
            color: message.isUser
                ? (isDarkMode ? Colors.white : Colors.black87)
                : (isDarkMode ? Colors.white : Colors.black),
          ),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: message.isUser
              ? (isDarkMode ? Colors.white : Colors.black87)
              : (isDarkMode ? Colors.white : Colors.black),
        ),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(
          color: message.isUser
              ? (isDarkMode ? Colors.white : Colors.black87)
              : (isDarkMode ? Colors.white : Colors.black),
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}