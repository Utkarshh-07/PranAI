import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prana/features/happy_thoughts/shell_collection/models/shell_model.dart';
import 'package:prana/features/happy_thoughts/shell_collection/widgets/story_display.dart';

class OceansDiary extends StatefulWidget {
  final List<Shell> shells;
  
  const OceansDiary({Key? key, required this.shells}) : super(key: key);
  
  @override
  _OceansDiaryState createState() => _OceansDiaryState();
}

class _OceansDiaryState extends State<OceansDiary> 
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  List<Shell> _favoriteShells = [];
  List<Shell> _recentShells = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Filter shells
    _recentShells = List.from(widget.shells)
      ..sort((a, b) => b.discoveredAt.compareTo(a.discoveredAt));
    
    // Simulate favorites (in real app, this would be from storage)
    _favoriteShells = widget.shells.where((shell) => 
        shell.rarity == ShellRarity.EPIC || 
        shell.rarity == ShellRarity.LEGENDARY).toList();
  }
  
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
                  Color(0xFF1B3B6F).withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Ocean\'s Diary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Your collection of ocean wisdom and memories',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Tabs
          Container(
            color: Color(0xFF1B3B6F),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.cyan,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: 'All Stories'),
                Tab(text: 'Favorites'),
                Tab(text: 'By Month'),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Stories Tab
                _buildAllStoriesTab(),
                
                // Favorites Tab
                _buildFavoritesTab(),
                
                // By Month Tab
                _buildByMonthTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAllStoriesTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _recentShells.length,
      itemBuilder: (context, index) {
        final shell = _recentShells[index];
        return _buildStoryCard(shell, index);
      },
    );
  }
  
  Widget _buildFavoritesTab() {
    if (_favoriteShells.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, color: Colors.white.withOpacity(0.3), size: 60),
            SizedBox(height: 20),
            Text(
              'No favorite stories yet',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tap the star on any story to add it here',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _favoriteShells.length,
      itemBuilder: (context, index) {
        final shell = _favoriteShells[index];
        return _buildStoryCard(shell, index, isFavorite: true);
      },
    );
  }
  
  Widget _buildByMonthTab() {
    // Group shells by month
    final Map<String, List<Shell>> shellsByMonth = {};
    
    for (var shell in widget.shells) {
      final monthKey = DateFormat('MMMM yyyy').format(shell.discoveredAt);
      shellsByMonth.putIfAbsent(monthKey, () => []).add(shell);
    }
    
    final monthKeys = shellsByMonth.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Recent first
    
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: monthKeys.length,
      itemBuilder: (context, index) {
        final month = monthKeys[index];
        final monthShells = shellsByMonth[month]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    color: Colors.cyan,
                  ),
                  SizedBox(width: 10),
                  Text(
                    month,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${monthShells.length} shells',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Shells for this month
            ...monthShells.map((shell) => 
              _buildStoryCard(shell, monthShells.indexOf(shell), showMonth: false)
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildStoryCard(Shell shell, int index, {bool isFavorite = false, bool showMonth = true}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            shell.glowColor.withOpacity(0.15),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: shell.glowColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showStoryDetails(shell);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Shell info
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: shell.glowColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: shell.glowColor),
                          ),
                          child: Center(
                            child: Text(
                              shell.emoji,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shell.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              showMonth 
                                  ? DateFormat('dd MMM yyyy').format(shell.discoveredAt)
                                  : shell.discoveredIn,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Favorite button
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.yellow : Colors.white70,
                      ),
                      onPressed: () {
                        _toggleFavorite(shell);
                      },
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Story preview
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    shell.description.length > 150
                        ? '${shell.description.substring(0, 150)}...'
                        : shell.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                SizedBox(height: 12),
                
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rarity badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: shell.rarityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: shell.rarityColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        shell.rarityString,
                        style: TextStyle(
                          color: shell.rarityColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Read more button
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: shell.glowColor,
                      ),
                      onPressed: () {
                        _showStoryDetails(shell);
                      },
                      child: Row(
                        children: [
                          Text('Read Full Story'),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _toggleFavorite(Shell shell) {
    setState(() {
      if (_favoriteShells.contains(shell)) {
        _favoriteShells.remove(shell);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from favorites'),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        _favoriteShells.add(shell);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to favorites!'),
            backgroundColor: Colors.yellow.shade700,
          ),
        );
      }
    });
  }
  
  void _showStoryDetails(Shell shell) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Color(0xFF0A2342),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Ocean\'s Message',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: StoryDisplay(
              story: shell.description,
              title: shell.name,
              themeColor: shell.glowColor,
              showRevealAnimation: false,
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}