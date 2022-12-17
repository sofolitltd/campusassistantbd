import 'package:campusassistant/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../models/stuff_model.dart';

class AddEmergency extends StatefulWidget {
  static const routeName = 'add_staff';

  const AddEmergency({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  final UserModel userModel;

  @override
  State<AddEmergency> createState() => _AddEmergencyState();
}

class _AddEmergencyState extends State<AddEmergency> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Emergency Numbers'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ButtonTheme(
          alignedDropdown: true,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .2
                  : 16,
              vertical: 16,
            ),
            children: [
              //serial
              TextFormField(
                controller: _serialController,
                validator: (value) => value!.isEmpty ? 'Enter serial' : null,
                decoration: const InputDecoration(
                  hintText: 'serial',
                  labelText: 'serial',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.segment_rounded),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),
              //name
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Name',
                  prefixIcon: const Icon(Icons.person_pin_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              //post
              TextFormField(
                controller: _postController,
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return 'Enter post';
                //   }
                //   return null;
                // },
                decoration: const InputDecoration(
                  hintText: 'post',
                  labelText: 'post',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.ac_unit_outlined),
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 16),

              //phone
              TextFormField(
                controller: _phoneController,
                // validator: (value) => (value!.isEmpty)?'Enter phone no': null,
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

                            //
                            var ref = FirebaseFirestore.instance
                                .collection('Universities')
                                .doc(widget.userModel.university)
                                .collection('Emergency');

                            //
                            StaffModel staffModel = StaffModel(
                              name: _nameController.text.trim(),
                              post: _postController.text.trim(),
                              phone: _phoneController.text.trim(),
                              serial: int.parse(_serialController.text.trim()),
                              imageUrl: '',
                            );

                            ref.doc().set(staffModel.toJson());

                            setState(() => _isLoading = false);

                            //
                            Navigator.pop(context);
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Upload'))
            ],
          ),
        ),
      ),
    );
  }
}
