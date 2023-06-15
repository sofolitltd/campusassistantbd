import 'dart:developer';

import 'package:campusassistant/models/profile_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen(
      {super.key, required this.noticeId, required this.profileData});

  final String noticeId;
  final ProfileData profileData;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();

    //
    _messageController.addListener(() {
      final isButtonActive = _messageController.text.isNotEmpty;
      setState(() {
        this.isButtonActive = isButtonActive;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.profileData.university)
        .collection('Departments')
        .doc(widget.profileData.department)
        .collection('notices')
        .doc(widget.noticeId)
        .collection('comments');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment'),
      ),

      //
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ref.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SizedBox();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data!.docs;
                if (data.isEmpty) {
                  return const Center(child: Text('No comments yet!'));
                }
                //

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(data[index].get('image')),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].get('name'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  data[index].get('message'),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          //
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              bottom: 8,
              right: 8,
              top: 16,
            ),
            child: Row(
              children: [
                // write comment
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // sent
                IconButton(
                  onPressed: isButtonActive
                      ? () async {
                          log(_messageController.text.trim());

                          await ref.doc().set({
                            'uid': widget.profileData.uid,
                            'image': widget.profileData.image,
                            'name': widget.profileData.name,
                            'message': _messageController.text.trim(),
                            'time': '',
                          });
                        }
                      : null,
                  icon: Icon(
                    Icons.send_rounded,
                    size: 32,
                    color: isButtonActive
                        ? Colors.blueAccent
                        : Colors.grey.shade300,
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
