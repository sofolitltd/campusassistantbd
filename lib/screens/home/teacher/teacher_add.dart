import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '/models/teacher_model.dart';
import '../../../models/user_model.dart';

class TeacherAdd extends StatefulWidget {
  const TeacherAdd({Key? key, required this.userModel, required this.present})
      : super(key: key);

  final UserModel userModel;
  final bool present;

  @override
  State<TeacherAdd> createState() => _TeacherAddState();
}

class _TeacherAddState extends State<TeacherAdd> {
  int? _selectedSerial;
  String? _selectedPost;
  bool? _isPresent;
  bool _isLoading = false;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phdController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _publicationsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    _isPresent = widget.present;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
                      items: List.generate(20, (index) => 1 + index++)
                          .map((serial) {
                        return DropdownMenuItem<int>(
                          alignment: Alignment.center,
                          value: serial,
                          child: Text(serial.toString()),
                        );
                      }).toList(),
                      onChanged: (int? newSerial) {
                        setState(() => _selectedSerial = newSerial);
                      },
                      validator: (val) => val == null ? 'Select serial' : null,
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
                  setState(() => _selectedPost = newPost);
                },
                validator: (val) => val == null ? 'Select post' : null,
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
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
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
                // validator: (val) => val!.isEmpty
                //     ? 'Enter mobile no'
                //     : val.length < 11
                //         ? 'Mobile no must be 11 digits'
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
                // validator: (val) => val!.isEmpty ? 'Enter email' : null,
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
              ),

              const SizedBox(height: 16),
              //
              ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_globalKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            String id = const Uuid().v1();
                            //
                            TeacherModel teacher = TeacherModel(
                              id: id,
                              serial: _selectedSerial!,
                              present: _isPresent!,
                              chairman: false,
                              name: _nameController.text.trim(),
                              post: _selectedPost!,
                              mobile: _mobileController.text.trim(),
                              email: _emailController.text.trim(),
                              phd: _phdController.text.trim().isEmpty
                                  ? ''
                                  : _phdController.text.trim(),
                              interests: _interestController.text.trim().isEmpty
                                  ? ''
                                  : _interestController.text.trim(),
                              publications:
                                  _publicationsController.text.trim().isEmpty
                                      ? ''
                                      : _publicationsController.text.trim(),
                              imageUrl: _imageUrlController.text.trim(),
                            );

                            //
                            var ref = FirebaseFirestore.instance
                                .collection('Universities')
                                .doc(widget.userModel.university)
                                .collection('Departments')
                                .doc(widget.userModel.department)
                                .collection('Teachers')
                                .doc(id);

                            //
                            await ref.set(teacher.toJson()).then((value) {
                              //
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Successfully added')));

                              //
                              setState(() => _isLoading = false);
                              //
                              Navigator.pop(context);
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Add')),
            ],
          ),
        ));
  }

  //
  List<String> serialList = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
  ];
  List<String> postList = [
    'Professor',
    'Associate Professor',
    'Assistant Professor',
    'Lecturer',
  ];
}
