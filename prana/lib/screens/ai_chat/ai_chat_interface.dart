// lib/screens/ai_chat/ai_chat_interface.dart
import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../../models/ai_character_model.dart';
import '../../models/chat_message_model.dart';
import '../../widgets/animated_character.dart';

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
  final AIService _aiService = AIService();
  
  bool _isTyping = false;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentExpression = 'neutral';

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
    _loadChatHistory();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage.create(
      role: 'ai',
      content: 'Hi! I\'m ${widget.character.name}. ${_getPersonalityGreeting()}',
    );
    setState(() => _messages.add(welcomeMessage));
  }

  String _getPersonalityGreeting() {
    switch (widget.character.id) {
      case 'ai_1': // Alex - Calm
        return "I'm here to listen and support you. What's on your mind?";
      case 'ai_2': // Jordan - Energetic
        return "So good to see you! Let's have an amazing conversation! 🎉";
      case 'ai_3': // Taylor - Wise
        return "I've been looking forward to our chat. What shall we explore today?";
      case 'ai_4': // Casey - Gentle
        return "I'm really glad you're here. Take your time, I'm all ears.";
      default:
        return "How can I help you today?";
    }
  }

  Future<void> _loadChatHistory() async {
    // TODO: Load chat history from local storage if needed
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isLoading) return;

    final userMessage = _messageController.text;
    
    setState(() {
      _messages.add(ChatMessage.create(
        role: 'user',
        content: userMessage,
      ));
      _isTyping = true;
      _isLoading = true;
      _errorMessage = null;
      _currentExpression = 'listening';
    });
    
    _messageController.clear();
    _scrollToBottom();

    try {
      // Get real AI response from OpenAI
      final aiResponse = await _aiService.getAIResponse(
        userMessage, 
        widget.character
      );

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage.create(
            role: 'ai',
            content: aiResponse,
          ));
          _isTyping = false;
          _isLoading = false;
          _currentExpression = _detectEmotion(aiResponse);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage.create(
            role: 'ai',
            content: "I'm having trouble connecting right now. Please try again in a moment.",
            isError: true,
          ));
          _isTyping = false;
          _isLoading = false;
          _errorMessage = e.toString();
          _currentExpression = 'concerned';
        });
      }
    }
    
    _scrollToBottom();
  }

  String _detectEmotion(String response) {
    final lowerResponse = response.toLowerCase();
    
    if (lowerResponse.contains('sorry') || 
        lowerResponse.contains('tough') || 
        lowerResponse.contains('hard') ||
        lowerResponse.contains('sad')) {
      return 'concerned';
    } else if (lowerResponse.contains('great') || 
               lowerResponse.contains('happy') || 
               lowerResponse.contains('wonderful') ||
               lowerResponse.contains('🎉') ||
               lowerResponse.contains('🔥')) {
      return 'happy';
    } else if (lowerResponse.contains('think') || 
               lowerResponse.contains('maybe') || 
               lowerResponse.contains('consider') ||
               lowerResponse.contains('perhaps')) {
      return 'thinking';
    }
    
    return 'neutral';
  }

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

  Future<void> _refreshChat() async {
    setState(() {
      _messages.clear();
      _errorMessage = null;
    });
    _addWelcomeMessage();
    _aiService.clearHistory(widget.character.id);
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
            // Animated character avatar
            SizedBox(
              width: 40,
              height: 40,
              child: AnimatedCharacter(
                character: widget.character,
                expression: _currentExpression,
                isSpeaking: _isTyping,
                isListening: _isTyping, gender: '', baseColor: '', eyeColor: '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.character.name,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _isTyping ? Colors.orange : Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isTyping ? 'thinking...' : 'online',
                        style: TextStyle(
                          color: _isTyping ? Colors.orange : Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1F2F),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _refreshChat,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: _showOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade900.withOpacity(0.3),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Connection issue. Using offline mode.',
                      style: TextStyle(color: Colors.red.shade200, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshChat,
              color: Colors.blue,
              backgroundColor: const Color(0xFF1A1F2F),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          if (_isTyping) _buildTypingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(int.parse(widget.character.baseColor.replaceFirst('#', '0xFF'))),
                    const Color(0xFF7B68EE),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.character.name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? Colors.blue 
                    : (message.isError ? Colors.red.shade900 : Colors.grey.shade800),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(int.parse(widget.character.baseColor.replaceFirst('#', '0xFF'))),
                  const Color(0xFF7B68EE),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.character.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(150),
                const SizedBox(width: 4),
                _buildTypingDot(300),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.3, end: 1.0),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF1A1F2F),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: _isLoading ? 'Waiting for response...' : 'Type a message...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              enabled: !_isLoading,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: Icon(
                _isLoading ? Icons.hourglass_empty : Icons.send,
                color: _isLoading ? Colors.grey : Colors.blue,
              ),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F2F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionTile(
              icon: Icons.delete_outline,
              label: 'Clear Chat History',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _refreshChat();
              },
            ),
            _buildOptionTile(
              icon: Icons.info_outline,
              label: 'About ${widget.character.name}',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                _showCharacterInfo();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  void _showCharacterInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2F),
        title: Text(
          widget.character.name,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Gender', widget.character.gender),
            _buildInfoRow('Voice', widget.character.voiceType),
            _buildInfoRow('Personality', _getPersonalityType()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  String _getPersonalityType() {
    switch (widget.character.id) {
      case 'ai_1': return 'Calm & Supportive';
      case 'ai_2': return 'Energetic & Motivating';
      case 'ai_3': return 'Wise & Thoughtful';
      case 'ai_4': return 'Gentle & Caring';
      default: return 'Friendly';
    }
  }
}