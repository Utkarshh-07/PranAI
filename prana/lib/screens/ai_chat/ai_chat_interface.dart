// lib/screens/ai_chat/ai_chat_interface.dart (COMPLETE WITH DEBUG PRINTS)
import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../../models/ai_character_model.dart';

class ChatMessage {
  final String id;
  final String role;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  bool get isUser => role == 'user';

  factory ChatMessage.create({required String role, required String content}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: role,
      content: content,
      timestamp: DateTime.now(),
    );
  }
}

class AIChatInterface extends StatefulWidget {
  final AICharacter character;

  const AIChatInterface({super.key, required this.character});

  @override
  State<AIChatInterface> createState() => _AIChatInterfaceState();
}

class _AIChatInterfaceState extends State<AIChatInterface> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  
  // Create service directly
  late final AIService _aiService;

  @override
  void initState() {
    super.initState();
    _aiService = AIService();
    _addWelcomeMessage();
    print('✅ AIChatInterface initialized for: ${widget.character.name}');
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    String welcomeText;
    switch (widget.character.voiceType) {
      case 'calm':
        welcomeText = "Hi, I'm ${widget.character.name}. I'm here to listen. How are you feeling today? 🧘";
        break;
      case 'energetic':
        welcomeText = "Hey! I'm ${widget.character.name}! So excited to chat with you! What's on your mind? 🎉";
        break;
      case 'wise':
        welcomeText = "Hello. I'm ${widget.character.name}. I'm glad you're here. What shall we discuss today? 🌟";
        break;
      default:
        welcomeText = "Hi! I'm ${widget.character.name}. How can I help you today? 💗";
    }
    _messages.add(ChatMessage.create(role: 'ai', content: welcomeText));
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isLoading) {
      print('⏸️ Cannot send: empty or loading');
      return;
    }

    final userMessage = _messageController.text.trim();
    print('📤 SENDING: "$userMessage"');
    
    // Add user message
    setState(() {
      _messages.add(ChatMessage.create(role: 'user', content: userMessage));
      _isLoading = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      print('🔄 Calling Gemini API for: "$userMessage"');
      final aiResponse = await _aiService.getAIResponse(userMessage, widget.character);
      print('📥 RECEIVED RESPONSE: "$aiResponse"');
      
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage.create(role: 'ai', content: aiResponse));
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ ERROR in _sendMessage: $e');
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage.create(role: 'ai', content: "I'm here for you. What would you like to talk about? 💗"));
          _isLoading = false;
        });
      }
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _isLoading = false;
    });
    _addWelcomeMessage();
    _aiService.clearHistory(widget.character.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat history cleared')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E17),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.character.baseColorObj, const Color(0xFF7B68EE)],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.character.initial,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.character.name,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'AI Friend',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1F2F),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.isUser;
                final timeString = '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}';
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [widget.character.baseColorObj, const Color(0xFF7B68EE)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              widget.character.initial,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message.content,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                timeString,
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 8),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blueGrey,
                          child: Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(widget.character.baseColorObj),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.character.name} is typing...',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F2F),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: _isLoading ? 'Waiting for response...' : 'Type a message...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A0F1E),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      enabled: !_isLoading,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _isLoading ? null : _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: _isLoading
                            ? null
                            : LinearGradient(
                                colors: [widget.character.baseColorObj, const Color(0xFF7B68EE)],
                              ),
                        color: _isLoading ? Colors.grey.shade700 : null,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isLoading ? Icons.hourglass_empty : Icons.send,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}