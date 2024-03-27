import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDepartment extends StatefulWidget {
  const AddDepartment({super.key, required this.university});

  final String university;

  @override
  State<AddDepartment> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _establishController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Department'),
        centerTitle: true,
      ),

      //
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .2
                : 16,
            vertical: 16,
          ),
          children: [
            //
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: 'Name',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter Name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _establishController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Establish',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter Establish';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _aboutController,
              minLines: 3,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'About',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter Establish';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _websiteController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                hintText: 'Website',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _imageUrlController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Image Url',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            //
            ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_globalKey.currentState!.validate()) {
                          setState(() => _isLoading = true);

                          //
                          DepartmentModel departmentModel = DepartmentModel(
                            name: _nameController.text.trim(),
                            establish: _establishController.text.trim(),
                            about: _aboutController.text.trim(),
                            website: _websiteController.text.trim().isNotEmpty
                                ? _websiteController.text.trim()
                                : '',
                            imageUrl: _imageUrlController.text.trim().isNotEmpty
                                ? _imageUrlController.text.trim()
                                : "",
                          );

                          //
                          await FirebaseFirestore.instance
                              .collection('Universities')
                              .doc(widget.university)
                              .collection('Departments')
                              .doc(_nameController.text.trim())
                              .set(departmentModel.toJson())
                              .then((value) {
                            setState(() => _isLoading = false);
                            Navigator.pop(context);
                          });
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text('Add now'.toUpperCase()))
          ],
        ),
      ),
    );
  }
}

//
class DepartmentModel {
  final String name;
  final String establish;
  final String about;
  final String website;
  final String imageUrl;

  DepartmentModel({
    required this.name,
    required this.establish,
    required this.about,
    required this.website,
    required this.imageUrl,
  });

  factory DepartmentModel.fromJson(var json) {
    return DepartmentModel(
      name: json['name'],
      establish: json['establish'],
      about: json['about'],
      website: json['website'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'establish': establish,
        'about': about,
        'website': website,
        'imageUrl': imageUrl,
      };
}
