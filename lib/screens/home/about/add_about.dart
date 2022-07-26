import 'package:campusassistant/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddAbout extends StatefulWidget {
  const AddAbout({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  State<AddAbout> createState() => _AddAboutState();
}

class _AddAboutState extends State<AddAbout> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add About'),
        centerTitle: true,
      ),

      //
      body: Form(
        key: _globalKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //about
              TextFormField(
                controller: _aboutController,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 15,
                decoration: InputDecoration(
                  hintText: 'About',
                  prefixIcon: const Icon(Icons.align_vertical_bottom_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter something';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              //image
              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Image Url',
                  prefixIcon: const Icon(Icons.image_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter something';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // btn
              ElevatedButton(
                  onPressed: () async {
                    if (_globalKey.currentState!.validate()) {
                      await FirebaseFirestore.instance
                          .collection('Universities')
                          .doc(widget.userModel.university)
                          .collection('Departments')
                          .doc(widget.userModel.department)
                          .set(
                        {
                          'about': _aboutController.text.trim(),
                          'imageUrl': _imageUrlController.text.trim(),
                        },
                      ).then((value) {
                        Navigator.pop(context);
                      });
                    }
                    //
                  },
                  child: const Text('Upload')),
            ],
          ),
        ),
      ),
    );
  }
}
