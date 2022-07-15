import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/teacher_model.dart';
import '../../../models/user_model.dart';

class TeacherEdit extends StatefulWidget {
  const TeacherEdit({
    Key? key,
    required this.teacherModel,
    required this.userModel,
  }) : super(key: key);
  final UserModel userModel;
  final TeacherModel teacherModel;

  @override
  State<TeacherEdit> createState() => _TeacherEditState();
}

class _TeacherEditState extends State<TeacherEdit> {
  int? _selectedSerial;
  String? _selectedPost;
  bool? _isPresent;
  final GlobalKey<FormState> _globalKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phdController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _publicationsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    _isPresent = widget.teacherModel.present;

    _selectedSerial ??= widget.teacherModel.serial;
    _selectedPost ??= widget.teacherModel.post;
    _nameController.text = widget.teacherModel.name;
    _phdController.text = widget.teacherModel.phd;
    _mobileController.text = widget.teacherModel.mobile;
    _emailController.text = widget.teacherModel.email;
    _interestController.text = widget.teacherModel.interests;
    _publicationsController.text = widget.teacherModel.publications;
    _imageUrlController.text = widget.teacherModel.imageUrl;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Teacher'),
          elevation: 0,
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
              // status & serial
              Row(
                children: [
                  // present / absent
                  Expanded(
                    child: Row(
                      children: [
                        const Text('Present: '),
                        Switch(
                            value: _isPresent!,
                            onChanged: (newValue) {
                              setState(() {
                                _isPresent = newValue;
                              });
                            }),
                      ],
                    ),
                  ),

                  // serial no
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        label: Text('Serial No'),
                        hintText: 'Serial No',
                      ),
                      value: _selectedSerial,
                      isExpanded: true,
                      items: List<int>.generate(25, (index) => index + 1)
                          .map((serial) {
                        return DropdownMenuItem<int>(
                          value: serial,
                          child: Text(serial.toString()),
                        );
                      }).toList(),
                      onChanged: (newSerial) {
                        setState(() {
                          _selectedSerial = newSerial;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              // post
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Select Post'),
                    hintText: 'Select Post',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 18, horizontal: 12)),
                value: _selectedPost,
                isExpanded: true,
                items: postList
                    .map(
                      (post) => DropdownMenuItem<String>(
                        value: post,
                        child: Text(post),
                      ),
                    )
                    .toList(),
                onChanged: (newPost) {
                  setState(() {
                    _selectedPost = newPost;
                  });
                },
              ),

              const SizedBox(height: 10),
              //name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  label: Text('Name'),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (String? val) =>
                    val!.isEmpty ? 'Field must not be empty' : null,
              ),

              const SizedBox(height: 10),
              // phd
              TextFormField(
                controller: _phdController,
                decoration: const InputDecoration(
                  hintText: 'Phd',
                  label: Text('Phd'),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 10),
              //mobile
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  hintText: 'Mobile',
                  label: Text('Mobile'),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                textInputAction: TextInputAction.next,
                // maxLength: 11,
                keyboardType: TextInputType.phone,
                // validator: (String? val) => val!.isEmpty
                //     ? 'Field must not be empty'
                //     : val.length < 11
                //         ? 'Mobile number must be 11 digit'
                //         : null,
              ),

              const SizedBox(height: 10),
              //email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  label: Text('Email'),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                // validator: (String? val) =>
                //     val!.isEmpty ? 'Field must not be empty' : null,
              ),

              const SizedBox(height: 10),
              //interest
              TextFormField(
                controller: _interestController,
                decoration: const InputDecoration(
                  hintText: 'Interest',
                  label: Text('Interest'),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                // validator: (String? val) =>
                //     val!.isEmpty ? 'Field must not be empty' : null,
              ),

              const SizedBox(height: 10),
              //publications
              TextFormField(
                controller: _publicationsController,
                decoration: const InputDecoration(
                  hintText: 'Publications',
                  label: Text('Publications'),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
              ),

              const SizedBox(height: 10),

              //imageUrl
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  hintText: 'Image Url',
                  label: Text('Image Url'),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.url,
                minLines: 1,
                maxLines: 5,
                // validator: (String? val) =>
                //     val!.isEmpty ? 'Field must not be empty' : null,
              ),

              const SizedBox(height: 16),
              //
              SizedBox(
                height: 48,
                child: ElevatedButton(
                    onPressed: () {
                      //validate
                      if (_globalKey.currentState!.validate()) {
                        TeacherModel teacher = TeacherModel(
                          id: widget.teacherModel.id,
                          serial: _selectedSerial!,
                          present: _isPresent!,
                          chairman: widget.teacherModel.chairman,
                          name: _nameController.text.trim(),
                          post: _selectedPost!,
                          phd: _phdController.text.trim(),
                          mobile: _mobileController.text.trim(),
                          email: _emailController.text.trim(),
                          imageUrl: _imageUrlController.text.trim(),
                          interests: _interestController.text.trim(),
                          publications: _publicationsController.text.trim(),
                        );

                        //
                        var ref = FirebaseFirestore.instance
                            .collection('Universities')
                            .doc(widget.userModel.university)
                            .collection('Departments')
                            .doc(widget.userModel.department)
                            .collection('Teachers');

                        // Todo: delete old teacher info
                        ref
                            .doc(widget.teacherModel.id)
                            .set(teacher.toJson())
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Edit successful')));

                          //
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: const Text('Save Changes')),
              ),
            ],
          ),
        ));
  }

  //
  List<String> postList = [
    'Professor',
    'Associate Professor',
    'Assistant Professor',
    'Lecturer',
  ];
}
