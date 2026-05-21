// lib/screens/chat/create_group_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final String currentUserDocId = "user_utkarsh";
  final String currentUserName = "Utkarsh";
  final String currentUserAvatar = "❤️";
  
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _selectedMembers = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .limit(10)
          .get();

      setState(() {
        _searchResults = snapshot.docs
            .where((doc) => doc.id != currentUserDocId)
            .map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            })
            .toList();
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  void _addMember(Map<String, dynamic> user) {
    if (!_selectedMembers.any((m) => m['id'] == user['id'])) {
      setState(() {
        _selectedMembers.add(user);
        _searchResults.remove(user);
      });
    }
    _searchController.clear();
  }

  void _removeMember(Map<String, dynamic> user) {
    setState(() {
      _selectedMembers.remove(user);
    });
  }

  Future<void> _createGroup() async {
    if (_groupNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter group name')),
      );
      return;
    }

    if (_selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one member')),
      );
      return;
    }

    try {
      List<String> memberIds = [currentUserDocId];
      Map<String, String> memberNames = {currentUserDocId: currentUserName};
      Map<String, String> memberAvatars = {currentUserDocId: currentUserAvatar};

      for (var member in _selectedMembers) {
        memberIds.add(member['id']);
        memberNames[member['id']] = member['username'] ?? 'User';
        memberAvatars[member['id']] = member['avatar'] ?? '👤';
      }

      await FirebaseFirestore.instance.collection('groups').add({
        'name': _groupNameController.text,
        'avatar': '👥',
        'createdBy': currentUserDocId,
        'admins': [currentUserDocId],
        'members': memberIds,
        'memberNames': memberNames,
        'memberAvatars': memberAvatars,
        'flow': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group created!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
        title: const Text('Create Group', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _createGroup,
            child: const Text('Create', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _groupNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Group name',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: const Color(0xFF1A1F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search users to add...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: const Color(0xFF1A1F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
              ),
              onChanged: _searchUsers,
            ),
          ),
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          if (_searchResults.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(user['avatar'] ?? '👤'),
                    ),
                    title: Text(
                      user['username'] ?? 'User',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: Colors.green),
                      onPressed: () => _addMember(user),
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Selected Members (${_selectedMembers.length})',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _selectedMembers.length,
                    itemBuilder: (context, index) {
                      final user = _selectedMembers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(user['avatar'] ?? '👤'),
                        ),
                        title: Text(
                          user['username'] ?? 'User',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _removeMember(user),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}