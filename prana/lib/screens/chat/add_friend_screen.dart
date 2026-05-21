// lib/screens/chat/add_friend_screen.dart (COMPLETE)
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import '../../services/friend_request_service.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final String currentUserDocId = "user_utkarsh";
  final String currentUserId = "user1";
  final String currentUserName = "Utkarsh";
  final String currentUserAvatar = "💗";
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _showQR = true;
  final FriendRequestService _friendService = FriendRequestService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Text('Username @$currentUserName copied!'),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF1A1F2F),
        ),
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
        title: const Text('Add Friend', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_showQR ? Icons.search : Icons.qr_code_scanner),
            onPressed: () {
              setState(() {
                _showQR = !_showQR;
              });
            },
          ),
        ],
      ),
      body: _showQR ? _buildQRWithProfile() : _buildSearchUI(),
    );
  }

  Widget _buildQRWithProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // User Profile Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF69B4).withOpacity(0.2),
                  const Color(0xFF7B68EE).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFF69B4).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      currentUserAvatar,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '@$currentUserName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C9AFF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.copy, color: Color(0xFF7C9AFF), size: 20),
                        onPressed: () => _copyToClipboard('@$currentUserName'),
                        tooltip: 'Copy username',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentUserDocId,
                        style: const TextStyle(
                          color: Color(0xFF9AA8C7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _copyToClipboard(currentUserDocId),
                        child: Icon(
                          Icons.copy,
                          color: const Color(0xFF9AA8C7).withOpacity(0.5),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.1),
                ),
                const SizedBox(height: 24),
                
                const Text(
                  'SCAN TO ADD FRIEND',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: QrImageView(
                    data: currentUserDocId,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'or share username: ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _copyToClipboard('@$currentUserName'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C9AFF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '@$currentUserName',
                              style: TextStyle(
                                color: const Color(0xFF7C9AFF),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.copy,
                              color: const Color(0xFF7C9AFF),
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // QR Scanner Button
          OutlinedButton.icon(
            onPressed: () {
              _showQRScanner();
            },
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Scan QR Code'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: const Color(0xFFFF69B4).withOpacity(0.5)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchUI() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by username...',
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
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.qr_code, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _showQR = true;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        if (_isSearching)
          const Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final user = _searchResults[index];
              return Card(
                color: const Color(0xFF1A1F2F),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(user['avatar'] ?? '👤', style: const TextStyle(fontSize: 24)),
                  ),
                  title: Text(
                    user['username'] ?? 'User',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '@${user['username']}',
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _sendFriendRequest(user),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A80F0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
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
              data['uid'] = data['uid'];
              return data;
            })
            .toList();
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _sendFriendRequest(Map<String, dynamic> user) async {
    try {
      await _friendService.sendFriendRequest(
        fromUserId: currentUserId,
        fromUserDocId: currentUserDocId,
        fromUserName: currentUserName,
        fromUserAvatar: currentUserAvatar,
        toUserId: user['uid'],
        toUserDocId: user['id'],
        toUserName: user['username'],
        toUserAvatar: user['avatar'] ?? '👤',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Friend request sent to ${user['username']}!'),
            backgroundColor: Colors.green,
          ),
        );
        
        setState(() {
          _searchResults.remove(user);
        });
        
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFF0B0E17),
          appBar: AppBar(
            title: const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF69B4), Color(0xFF7B68EE)],
                ),
              ),
            ),
          ),
          body: MobileScanner(
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  final scannedId = barcode.rawValue!;
                  Navigator.pop(context);
                  
                  // Fetch user data and send request
                  final userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(scannedId)
                      .get();
                  
                  if (userDoc.exists) {
                    final userData = userDoc.data()!;
                    await _sendFriendRequest({
                      'id': scannedId,
                      'uid': userData['uid'],
                      'username': userData['username'],
                      'avatar': userData['avatar'],
                    });
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid QR code')),
                      );
                    }
                  }
                  return;
                }
              }
            },
          ),
        ),
      ),
    );
  }
}