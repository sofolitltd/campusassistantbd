// show dialog
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

progressDialog(BuildContext context, UploadTask task) {
  FocusManager.instance.primaryFocus!.unfocus();

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.all(12),
      title: Stack(
        alignment: Alignment.centerRight,
        children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Uploading File',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),

          //
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: const Icon(
                Icons.close_outlined,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      titlePadding: const EdgeInsets.all(12),
      content: StreamBuilder<TaskSnapshot>(
          stream: task.snapshotEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final snap = snapshot.data!;
              final progress = snap.bytesTransferred / snap.totalBytes;
              final percentage = (progress * 100).toStringAsFixed(0);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: LinearProgressIndicator(
                      minHeight: 16,
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueAccent.shade200),
                      backgroundColor:
                          Colors.lightBlueAccent.shade100.withOpacity(.2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('$percentage %'),
                  const SizedBox(height: 8),
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: LinearProgressIndicator(
                      minHeight: 16,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueAccent.shade200),
                      backgroundColor:
                          Colors.lightBlueAccent.shade100.withOpacity(.2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(' '),
                  const SizedBox(height: 8),
                ],
              );
            }
          }),
    ),
  );
}
