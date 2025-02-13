// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';

// class CommentSection extends StatefulWidget {
//   final String pageId;
//   const CommentSection({Key? key, required this.pageId}) : super(key: key);

//   @override
//   _CommentSectionState createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> {
//   final TextEditingController _commentController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool _isPosting = false;
//   bool _hasMore = true;
//   bool _isLoading = false;
//   DocumentSnapshot? _lastDocument;
//   List<QueryDocumentSnapshot> _comments = [];

//   Future<void> _loadComments() async {
//     if (_isLoading || !_hasMore) return;

//     setState(() => _isLoading = true);

//     try {
//       Query query = _firestore
//           .collection('comments')
//           .where('pageId', isEqualTo: widget.pageId)
//           .orderBy('timestamp', descending: true)
//           .limit(10);

//       if (_lastDocument != null) {
//         query = query.startAfterDocument(_lastDocument!);
//       }

//       QuerySnapshot querySnapshot = await query.get();

//       if (querySnapshot.docs.isNotEmpty) {
//         setState(() {
//           _lastDocument = querySnapshot.docs.last;
//           _comments.addAll(
//               querySnapshot.docs.where((doc) => doc['text'].trim().isNotEmpty));
//         });
//       } else {
//         setState(() => _hasMore = false);
//       }
//     } catch (e) {
//       print("Error loading comments: $e");
//     }

//     setState(() => _isLoading = false);
//   }

//   void _addComment() async {
//     if (_commentController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('กรุณากรอกคอมเมนต์ก่อนโพสต์')),
//       );
//       return;
//     }

//     setState(() => _isPosting = true);

//     User? user = _auth.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('กรุณาเข้าสู่ระบบก่อนโพสต์คอมเมนต์')),
//       );
//       setState(() => _isPosting = false);
//       return;
//     }

//     try {
//       await _firestore.collection('comments').add({
//         'pageId': widget.pageId,
//         'userId': user.uid,
//         'userName': user.displayName ?? 'Anonymous',
//         'text': _commentController.text.trim(),
//         'timestamp': DateTime.now().toIso8601String(),
//       });

//       _commentController.clear();
//       _comments.clear();
//       _lastDocument = null;
//       _hasMore = true;
//       _loadComments();
//     } catch (e) {
//       print('Failed to post comment: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('ไม่สามารถโพสต์คอมเมนต์ได้ โปรดลองอีกครั้ง')),
//       );
//     }

//     setState(() => _isPosting = false);
//   }

//   void deleteComment(String commentId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('comments')
//           .doc(commentId)
//           .delete();
//       setState(() {
//         _comments.removeWhere((comment) => comment.id == commentId);
//       });
//     } catch (e) {
//       print("Error deleting comment: $e");
//     }
//   }

//   Widget buildCommentItem(DocumentSnapshot comment, String currentUserId) {
//     var data = comment.data() as Map<String, dynamic>;
//     String username = data['userName'] ?? 'Anonymous';
//     String commentText = data['text'] ?? '';
//     String formattedDate = 'Unknown';
//     String commentId = comment.id;

//     if (data['timestamp'] is String) {
//       try {
//         DateTime parsedDate = DateTime.parse(data['timestamp']);
//         formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
//       } catch (e) {
//         print('Error formatting timestamp: $e');
//         formattedDate = 'Invalid Date';
//       }
//     }

//     return ListTile(
//       leading: const Icon(Icons.account_circle),
//       title: Text(username),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(commentText),
//           Text("เมื่อ $formattedDate",
//               style: const TextStyle(fontSize: 12, color: Colors.grey)),
//         ],
//       ),
//       trailing: (data['userId'] == currentUserId)
//           ? PopupMenuButton<String>(
//               onSelected: (value) {
//                 if (value == 'delete') {
//                   deleteComment(commentId);
//                 }
//               },
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   value: 'delete',
//                   child: Row(
//                     children: [
//                       Icon(Icons.delete, color: Colors.red),
//                       SizedBox(width: 8),
//                       Text('Delete'),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           : null,
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Comments",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         TextField(
//           controller: _commentController,
//           decoration: InputDecoration(
//             labelText: "Add a comment...",
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             suffixIcon: IconButton(
//               icon: const Icon(Icons.send),
//               onPressed: _addComment,
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         _isPosting
//             ? const Center(child: CircularProgressIndicator())
//             : Container(),
//         _comments.isEmpty
//             ? const Center(child: Text('No comments yet.'))
//             : ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: _comments.length,
//                 itemBuilder: (context, index) {
//                   var comment = _comments[index];
//                   return buildCommentItem(
//                       comment, _auth.currentUser?.uid ?? '');
//                 },
//               ),
//         if (_hasMore)
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: ElevatedButton(
//                 onPressed: _loadComments,
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text("Load More Comments"),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  final String pageId;
  const CommentSection({Key? key, required this.pageId}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isPosting = false;
  bool _hasMore = true;
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;
  List<QueryDocumentSnapshot> _comments = [];
  String? _replyingToCommentId; // Store the comment ID to reply to
  String?
      _replyingToUserName; // Store the username of the comment being replied to

  Future<void> _loadComments() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      Query query = _firestore
          .collection('comments')
          .where('pageId', isEqualTo: widget.pageId)
          .orderBy('timestamp', descending: true)
          .limit(10);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _lastDocument = querySnapshot.docs.last;
          _comments.addAll(
              querySnapshot.docs.where((doc) => doc['text'].trim().isNotEmpty));
        });
      } else {
        setState(() => _hasMore = false);
      }
    } catch (e) {
      print("Error loading comments: $e");
    }

    setState(() => _isLoading = false);
  }

  void _addComment() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกคอมเมนต์ก่อนโพสต์')),
      );
      return;
    }

    setState(() => _isPosting = true);

    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเข้าสู่ระบบก่อนโพสต์คอมเมนต์')),
      );
      setState(() => _isPosting = false);
      return;
    }

    try {
      await _firestore.collection('comments').add({
        'pageId': widget.pageId,
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'text': _commentController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
        'replyTo':
            _replyingToCommentId, // Store the ID of the comment being replied to
        'replyToUserName':
            _replyingToUserName, // Store the username of the comment being replied to
      });

      _commentController.clear();
      _comments.clear();
      _lastDocument = null;
      _hasMore = true;
      _loadComments();
      setState(() {
        _replyingToCommentId = null; // Reset reply state
        _replyingToUserName = null; // Reset the replied-to username
      });
    } catch (e) {
      print('Failed to post comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('ไม่สามารถโพสต์คอมเมนต์ได้ โปรดลองอีกครั้ง')),
      );
    }

    setState(() => _isPosting = false);
  }

  void _startReply(String commentId, String userName) {
    setState(() {
      _replyingToCommentId = commentId; // Set the ID of the comment to reply to
      _replyingToUserName =
          userName; // Set the username of the comment to reply to
    });
  }

  void deleteComment(String commentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('comments')
          .doc(commentId)
          .delete();
      setState(() {
        _comments.removeWhere((comment) => comment.id == commentId);
      });
    } catch (e) {
      print("Error deleting comment: $e");
    }
  }

  Widget buildCommentItem(DocumentSnapshot comment, String currentUserId) {
    var data = comment.data() as Map<String, dynamic>;
    String username = data['userName'] ?? 'Anonymous';
    String commentText = data['text'] ?? '';
    String formattedDate = 'Unknown';
    String commentId = comment.id;
    String? replyToUserName = data['replyToUserName'];

    if (data['timestamp'] is String) {
      try {
        DateTime parsedDate = DateTime.parse(data['timestamp']);
        formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
      } catch (e) {
        print('Error formatting timestamp: $e');
        formattedDate = 'Invalid Date';
      }
    }

    return ListTile(
      leading: const Icon(Icons.account_circle),
      title: Text(username),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (replyToUserName != null) // If there's a reply, show the username
            Text('Replying to: $replyToUserName',
                style: const TextStyle(fontStyle: FontStyle.italic)),
          Text(commentText),
          Text("เมื่อ $formattedDate",
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
      trailing: (data['userId'] == currentUserId)
          ? PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  deleteComment(commentId);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            )
          : IconButton(
              icon: Icon(Icons.reply),
              onPressed: () => _startReply(commentId, username),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Comments",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (_replyingToCommentId != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Replying to: $_replyingToUserName'),
          ),
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: _replyingToCommentId != null
                ? 'Replying to $_replyingToUserName'
                : 'Add a comment...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _addComment,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _isPosting
            ? const Center(child: CircularProgressIndicator())
            : Container(),
        _comments.isEmpty
            ? const Center(child: Text('No comments yet.'))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  var comment = _comments[index];
                  return buildCommentItem(
                      comment, _auth.currentUser?.uid ?? '');
                },
              ),
        if (_hasMore)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: _loadComments,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Load More Comments"),
              ),
            ),
          ),
      ],
    );
  }
}
