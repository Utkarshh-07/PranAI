import 'package:flutter/material.dart';
import 'package:prana/features/happy_thoughts/shell_collection/models/shell_model.dart';

class BeachCustomization extends StatefulWidget {
  final List<Shell> shells;
  
  const BeachCustomization({Key? key, required this.shells}) : super(key: key);
  
  @override
  _BeachCustomizationState createState() => _BeachCustomizationState();
}

class _BeachCustomizationState extends State<BeachCustomization> {
  String _selectedTheme = 'sunset';
  List<String> _placedItems = [];
  
  final Map<String, List<Map<String, dynamic>>> _beachThemes = {
    'sunset': [
      {'icon': '🏖️', 'name': 'Beach Umbrella', 'color': Colors.red},
      {'icon': '🪑', 'name': 'Beach Chair', 'color': Colors.blue},
      {'icon': '🏐', 'name': 'Beach Ball', 'color': Colors.yellow},
      {'icon': '🛟', 'name': 'Float Ring', 'color': Colors.orange},
    ],
    'moonlight': [
      {'icon': '🏮', 'name': 'Lantern', 'color': Colors.yellow},
      {'icon': '🕯️', 'name': 'Candle', 'color': Colors.orange},
      {'icon': '🌌', 'name': 'Star Net', 'color': Colors.purple},
      {'icon': '🛏️', 'name': 'Hammock', 'color': Colors.brown},
    ],
    'tropical': [
      {'icon': '🌴', 'name': 'Palm Tree', 'color': Colors.green},
      {'icon': '🌺', 'name': 'Flowers', 'color': Colors.pink},
      {'icon': '🦜', 'name': 'Parrot', 'color': Colors.red},
      {'icon': '🥥', 'name': 'Coconut', 'color': Colors.brown},
    ],
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2342),
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A2342),
                  Color(0xFF1B3B6F),
                ],
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Beach Builder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.save, color: Colors.cyan),
                      onPressed: _saveBeach,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Build your dream beach with collected shells and items',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Beach preview
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _getThemeColors(),
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Beach background elements
                  _buildBeachBackground(),
                  
                  // Placed items
                  ..._placedItems.map((item) => _buildPlacedItem(item)).toList(),
                  
                  // Shells on beach
                  ...widget.shells.take(5).map((shell) => _buildBeachShell(shell)).toList(),
                  
                  // Instructions
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Drag items from below to place on beach',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Theme selector
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Theme:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _beachThemes.keys.map((theme) {
                    return ChoiceChip(
                      label: Text(
                        theme.capitalize(),
                        style: TextStyle(
                          color: _selectedTheme == theme ? Colors.white : Colors.white70,
                        ),
                      ),
                      selected: _selectedTheme == theme,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTheme = theme;
                        });
                      },
                      backgroundColor: Colors.white.withOpacity(0.1),
                      selectedColor: _getThemeColor(theme),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // Items palette
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beach Items:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _beachThemes[_selectedTheme]!.length,
                      itemBuilder: (context, index) {
                        final item = _beachThemes[_selectedTheme]![index];
                        return Draggable<String>(
                          data: item['name'],
                          feedback: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: item['color'].withOpacity(0.8),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: item['color'],
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                item['icon'],
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          childWhenDragging: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: item['color'].withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: item['color'].withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: item['color'].withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item['icon'],
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
  
  Widget _buildBeachBackground() {
    return Stack(
      children: [
        // Sky
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _getThemeColors(),
              ),
            ),
          ),
        ),
        
        // Sun/Moon
        Positioned(
          top: 50,
          right: 50,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedTheme == 'moonlight' 
                  ? Colors.white.withOpacity(0.8) 
                  : Colors.yellow.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: _selectedTheme == 'moonlight'
                      ? Colors.white.withOpacity(0.5)
                      : Colors.yellow.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        ),
        
        // Ocean
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.withOpacity(0.5),
                  Colors.blue.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),
        
        // Sand
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFE9C46A),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBeachShell(Shell shell) {
    final index = widget.shells.indexOf(shell);
    final double x = 50 + (index % 3) * 80.0;
    final double y = 120 + (index * 20) % 60.0;
    
    return Positioned(
      left: x,
      bottom: y,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: shell.glowColor.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(
            color: shell.glowColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: shell.glowColor.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            shell.emoji,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPlacedItem(String itemName) {
    // Find item details
    final item = _beachThemes[_selectedTheme]!.firstWhere(
      (item) => item['name'] == itemName,
      orElse: () => {'icon': '⭐', 'color': Colors.white},
    );
    
    // Simple positioning (in real app, would track positions)
    final index = _placedItems.indexOf(itemName);
    final double x = 30 + (index * 60) % 200.0;
    final double y = 80 + (index * 40) % 120.0;
    
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: item['color'].withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: item['color'].withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            item['icon'],
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
  
  List<Color> _getThemeColors() {
    switch (_selectedTheme) {
      case 'sunset':
        return [
          Color(0xFFFF6B6B),
          Color(0xFFFFA726),
          Color(0xFFFFCA28),
          Color(0xFF4ECDC4),
        ];
      case 'moonlight':
        return [
          Color(0xFF1A237E),
          Color(0xFF283593),
          Color(0xFF3949AB),
          Color(0xFF5C6BC0),
        ];
      case 'tropical':
        return [
          Color(0xFF4CAF50),
          Color(0xFF8BC34A),
          Color(0xFFCDDC39),
          Color(0xFF2196F3),
        ];
      default:
        return [
          Color(0xFF0A2342),
          Color(0xFF1B3B6F),
          Color(0xFF2A9D8F),
        ];
    }
  }
  
  Color _getThemeColor(String theme) {
    switch (theme) {
      case 'sunset': return Colors.orange;
      case 'moonlight': return Colors.purple;
      case 'tropical': return Colors.green;
      default: return Colors.blue;
    }
  }
  
  void _saveBeach() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Beach saved! You can visit it anytime.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}