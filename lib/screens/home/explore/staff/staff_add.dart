import 'package:campusassistant/models/profile_data.dart';
import 'package:campusassistant/models/stuff_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  final ProfileData profileData;

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.profileData.university)
        .collection('Departments')
        .doc(widget.profileData.department)
        .collection('Staff');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Staff'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ButtonTheme(
          alignedDropdown: true,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              //serial
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _serialController,
                      validator: (value) =>
                          (value!.isEmpty) ? 'Enter serial' : null,
                      decoration: const InputDecoration(
                        hintText: '1',
                        labelText: 'Serial',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),

                  const SizedBox(width: 16),

                  //post
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _postController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Assistant',
                        labelText: 'Post',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter post';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              //name
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'MD ...',
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person_pin_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter a name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              //phone
              TextFormField(
                controller: _phoneController,
                validator: (value) =>
                    (value!.isEmpty) ? 'Enter phone no' : null,
                decoration: const InputDecoration(
                  hintText: 'Phone',
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.call_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 24),

              //
              ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_globalKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            StaffModel staffModel = StaffModel(
                              name: _nameController.text.trim(),
                              post: _postController.text.trim(),
                              phone: _phoneController.text.trim(),
                              serial: int.parse(_serialController.text.trim()),
                              imageUrl: '',
                            );

                            //
                            await ref
                                .doc()
                                .set(staffModel.toJson())
                                .then((value) {
                              setState(() => _isLoading = false);

                              Navigator.pop(context);
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text('Upload'.toUpperCase()))
            ],
          ),
        ),
      ),
    );
  }
}
