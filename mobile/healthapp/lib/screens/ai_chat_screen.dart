import 'package:flutter/material.dart';
import '../services/langchain_service.dart';

class AiChatScreen extends StatefulWidget {
  final Map<String, dynamic> ensembleContext;

  const AiChatScreen({super.key, required this.ensembleContext});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final LangChainService _langChain = LangChainService();
  bool _isLoading = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String userMsg = _controller.text;
    setState(() {
      _messages.add({"role": "user", "text": userMsg});
      _isLoading = true;
    });
    _controller.clear();

    try {
      String aiResponse = await _langChain.getCounselorResponse(
        userMsg,
        widget.ensembleContext,
      );

      setState(() {
        _messages.add({"role": "ai", "text": aiResponse});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "ai",
          "text": "I'm having trouble connecting. Check your internet.",
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MindCare AI Assistant"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.teal.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, size: 16, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "AI is aware of your latest ${widget.ensembleContext['result']} prediction.",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                bool isUser = msg["role"] == "user";
                return _buildChatBubble(msg["text"]!, isUser);
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(color: Colors.teal),
            ),

          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.teal : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isUser ? 15 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 15),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Ask about your results...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.teal),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
