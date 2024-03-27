import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/profile_data.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen(
      {super.key, required this.noticeId, required this.profileData});

  final String noticeId;
  final ProfileData profileData;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
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
                  return const Center(child: SizedBox());
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
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.width * .2
                        : 16,
                    vertical: 16,
                  ),
                  itemBuilder: (context, index) {
                    return Row(
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data[index].get('name'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  if (data[index].get('uid') ==
                                      widget.profileData.uid)
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: InkWell(
                                          onTap: () async {
                                            await ref
                                                .doc(data[index].id)
                                                .delete()
                                                .then((value) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Delete comment successfully');
                                            });
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            size: 16,
                                            color: Colors.grey,
                                          )),
                                    ),
                                ],
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
                    );
                  },
                );
              },
            ),
          ),

          //
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .2
                  : 16,
              vertical: 16,
            ),
            child: MessageField(
              ref: ref,
              profileData: widget.profileData,
            ),
          ),
        ],
      ),
    );
  }
}

///
class MessageField extends StatefulWidget {
  const MessageField({
    super.key,
    required this.ref,
    required this.profileData,
  });

  final CollectionReference ref;
  final ProfileData profileData;

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
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
    return Row(
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

                  await widget.ref.doc().set({
                    'uid': widget.profileData.uid,
                    'image': widget.profileData.image,
                    'name': widget.profileData.name,
                    'message': _messageController.text.trim(),
                    'time': '',
                  }).whenComplete(() {
                    _messageController.clear();
                    setState(() {});
                  });
                }
              : null,
          icon: Icon(
            Icons.send_rounded,
            size: 32,
            color: isButtonActive ? Colors.blueAccent : Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}
