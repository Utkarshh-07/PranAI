// lib/screens/mindfulness/happy_thoughts/shell_collection.dart

import 'package:flutter/material.dart';

class ShellCollectionScreen extends StatefulWidget {
  const ShellCollectionScreen({super.key});

  @override
  _ShellCollectionScreenState createState() => _ShellCollectionScreenState();
}

class _ShellCollectionScreenState extends State<ShellCollectionScreen> {
  final Map<String, List<Shell>> _shellCollections = {
    'Daily Wins': [
      Shell(type: 'common', name: 'Sunrise Shell', collected: true),
      Shell(type: 'common', name: 'Wave Shell', collected: true),
      Shell(type: 'common', name: 'Sand Dollar', collected: false),
    ],
    'Gratitude': [
      Shell(type: 'rare', name: 'Golden Shell', collected: true),
      Shell(type: 'common', name: 'Thankful Shell', collected: true),
    ],
    'Milestones': [
      Shell(type: 'golden', name: '7-Day Shell', collected: true),
      Shell(type: 'golden', name: '30-Day Shell', collected: false),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2463),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Shell Collection'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFD166).withOpacity(0.3),
                      Color(0xFFFF6B6B).withOpacity(0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    '🐚',
                    style: TextStyle(fontSize: 80),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Each happy thought earns you a shell. Collect them all!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = _shellCollections.keys.toList()[index];
                final shells = _shellCollections[category]!;
                return _buildShellCategory(category, shells);
              },
              childCount: _shellCollections.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShellCategory(String category, List<Shell> shells) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: shells.length,
            itemBuilder: (context, index) {
              final shell = shells[index];
              return _buildShellItem(shell);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShellItem(Shell shell) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: shell.collected 
          ? _getShellColor(shell.type).withOpacity(0.3)
          : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: shell.collected 
            ? _getShellColor(shell.type)
            : Colors.grey,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getShellEmoji(shell.type),
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 8),
          Text(
            shell.name,
            style: TextStyle(
              color: shell.collected ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getShellColor(String type) {
    switch (type) {
      case 'golden': return Color(0xFFFFD166);
      case 'rare': return Color(0xFF9D4EDD);
      default: return Color(0xFF4CC9F0);
    }
  }

  String _getShellEmoji(String type) {
    switch (type) {
      case 'golden': return '🌟';
      case 'rare': return '💎';
      default: return '🐚';
    }
  }
}

class Shell {
  final String type;
  final String name;
  final bool collected;

  Shell({
    required this.type,
    required this.name,
    required this.collected,
  });
}