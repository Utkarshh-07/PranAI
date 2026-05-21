// lib/features/my_space/screens/rhythm_input_screen.dart
import 'package:flutter/material.dart';
import '../models/rhythm_model.dart';
import '../services/rhythm_ai_service.dart';
import '../theme/card_styles.dart';
import 'rhythm_preview_screen.dart';

class RhythmInputScreen extends StatefulWidget {
  final List<RhythmTask>? existingTasks;

  const RhythmInputScreen({super.key, this.existingTasks});

  @override
  State<RhythmInputScreen> createState() => _RhythmInputScreenState();
}

class _RhythmInputScreenState extends State<RhythmInputScreen> {
  final TextEditingController _controller = TextEditingController();
  final RhythmAIService _aiService = RhythmAIService();
  bool _isAnalyzing = false;

  final List<String> _examples = const [
    'I wake at 7, study 9-12, lunch at 12:30, then study more till 4, dinner at 8, sleep by 11',
    'Wake up 6am, breakfast 7, study 8-12, lunch 12:30, study 2-5, dinner 7, relax 8-10, sleep 11',
    'Morning routine 7:30, study 9-11, break, study 11:30-1, lunch, study 2-4, relax, dinner 8, sleep 10',
    'Get up at 7, breakfast 8, work 9-12, lunch, work 1-4, gym 5, dinner 7, chill 8-10, bed 11',
  ];

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      if (widget.existingTasks != null && widget.existingTasks!.isNotEmpty) {
        _controller.text = _tasksToText(widget.existingTasks!);
      } else {
        _controller.text = _examples[1];
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _tasksToText(List<RhythmTask> tasks) {
    final buffer = StringBuffer();
    
    for (var task in tasks) {
      buffer.write('${task.title} at ${_formatTimeForText(task.time)}, ');
    }
    
    String result = buffer.toString();
    if (result.endsWith(', ')) {
      result = result.substring(0, result.length - 2);
    }
    
    return result;
  }

  String _formatTimeForText(String time) {
    try {
      final hour = int.parse(time.substring(0, 2));
      final minute = time.substring(3, 5);
      final period = hour >= 12 ? 'pm' : 'am';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      
      if (minute == '00') {
        return '$displayHour$period';
      } else {
        return '$displayHour:$minute$period';
      }
    } catch (e) {
      return time;
    }
  }

  void _analyzeText() {
    if (_controller.text.trim().isEmpty) {
      _showSnackBar('Please describe your day first');
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    // Small delay to show loading
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      
      try {
        final tasks = _aiService.parseUserInput(_controller.text);
        
        setState(() {
          _isAnalyzing = false;
        });

        if (tasks.isEmpty) {
          _showSnackBar('Could not understand your schedule. Try using an example!', isError: true);
          return;
        }

        if (!mounted) return;
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RhythmPreviewScreen(
              tasks: tasks,
              originalText: _controller.text,
            ),
          ),
        );
      } catch (e) {
        setState(() {
          _isAnalyzing = false;
        });
        _showSnackBar('Error processing your schedule', isError: true);
      }
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF2D3E50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _useExample(int index) {
    setState(() {
      _controller.text = _examples[index % _examples.length];
    });
  }

  void _clearText() {
    setState(() {
      _controller.clear();
    });
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFFFFF9F0),
              Color(0xFFF5F0FF),
              Color(0xFFE8F0FE),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3E50)),
                      onPressed: _goBack,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.existingTasks != null 
                              ? '✏️ EDIT RHYTHM' 
                              : '⏰ CREATE RHYTHM',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3E50),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // AI Message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB4A7F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🤖', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Describe your day however you want. Example: "I wake at 7, study 9-12, lunch at 12:30, then study more, take a break at 4, dinner at 8, and sleep by 11."',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2D3E50),
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Input Field
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CardStyles.wrapWithFrostedGlass(
                    tintColor: const Color(0xFFB4A7F5),
                    opacity: 0.15,
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _controller,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Type your day here...',
                        hintStyle: TextStyle(
                          color: const Color(0xFF2D3E50).withOpacity(0.4),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2D3E50),
                      ),
                    ),
                  ),
                ),
              ),

              // Common Phrases
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 Common phrases I understand:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3E50),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildPhraseChip('wake up'),
                          _buildPhraseChip('study'),
                          _buildPhraseChip('break'),
                          _buildPhraseChip('lunch'),
                          _buildPhraseChip('dinner'),
                          _buildPhraseChip('sleep'),
                          _buildPhraseChip('gym'),
                          _buildPhraseChip('work'),
                          _buildPhraseChip('relax'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showExampleDialog(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2D3E50),
                          side: const BorderSide(color: Color(0xFF2D3E50)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('📋 EXAMPLES', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clearText,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2D3E50),
                          side: const BorderSide(color: Color(0xFF2D3E50)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('🗑️ CLEAR', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),

              // Analyze Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isAnalyzing ? null : _analyzeText,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D3E50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isAnalyzing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.existingTasks != null
                                ? '✨ UPDATE MY RHYTHM'
                                : '✨ ANALYZE MY DAY',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExampleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Example'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _examples.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Example ${index + 1}'),
                subtitle: Text(
                  _examples[index],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _useExample(index);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhraseChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3E50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF2D3E50),
        ),
      ),
    );
  }
}