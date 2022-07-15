import 'package:flutter/material.dart';

import '/screens/auth/signup3.dart';
import '../../utils/constants.dart';

class SignUpScreen2 extends StatefulWidget {
  static const routeName = 'register_info_screen';

  const SignUpScreen2({
    Key? key,
    required this.university,
    required this.department,
    required this.batch,
    required this.session,
    required this.id,
    required this.hallList,
  }) : super(key: key);

  final String university;
  final String department;
  final String batch;
  final String session;
  final String id;
  final List<String> hallList;

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String? _selectedHall;
  String? _selectedBloodGroup;

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      // floatingActionButton: showFab
      //     ? FloatingActionButton.extended(
      //         onPressed: () async {
      //           showDialog(
      //               context: context,
      //               builder: (_) => AlertDialog(
      //                     title: Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         const Text('Help center'),
      //                         IconButton(
      //                           onPressed: () {
      //                             Navigator.pop(context);
      //                           },
      //                           icon: const Icon(Icons.clear),
      //                         )
      //                       ],
      //                     ),
      //                     titlePadding: const EdgeInsets.only(left: 16),
      //                     contentPadding:
      //                         const EdgeInsets.symmetric(horizontal: 16),
      //                     content: Column(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         const Text(
      //                             'Like our page and send a message with\n\nName:'
      //                             ' \nBatch: \nStudent id:\n\nWe will send code as soon as possible.'),
      //                         const SizedBox(height: 8),
      //                         OutlinedButton.icon(
      //                             onPressed: () async {
      //                               await canLaunch(kFbGroup)
      //                                   ? await launch(kFbGroup)
      //                                   : throw 'Could not launch $kFbGroup';
      //                             },
      //                             icon: const Icon(Icons.facebook,
      //                                 color: Colors.blue),
      //                             label: const Text('Get Code with Facebook')),
      //                         Row(
      //                           children: [
      //                             Expanded(
      //                                 child: Container(
      //                                     height: 1, color: Colors.grey)),
      //                             const Padding(
      //                               padding: EdgeInsets.all(8.0),
      //                               child: Text('OR'),
      //                             ),
      //                             Expanded(
      //                                 child: Container(
      //                                     height: 1, color: Colors.grey)),
      //                           ],
      //                         ),
      //                         const Text('Contact with Developer'),
      //                         const SizedBox(height: 16),
      //                         Container(
      //                           color: Colors.transparent,
      //                           // width: double.infinity,
      //                           child: Row(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: const [
      //                               //call
      //                               CustomButton(
      //                                   type: 'tel:',
      //                                   link: kDeveloperMobile,
      //                                   icon: Icons.call,
      //                                   color: Colors.green),
      //
      //                               SizedBox(width: 8),
      //
      //                               //mail
      //                               CustomButton(
      //                                   type: 'mailto:',
      //                                   link: kDeveloperEmail,
      //                                   icon: Icons.mail,
      //                                   color: Colors.red),
      //
      //                               SizedBox(width: 8),
      //
      //                               //facebook
      //                               CustomButton(
      //                                   type: '',
      //                                   link: kDeveloperFb,
      //                                   icon: Icons.facebook,
      //                                   color: Colors.blue),
      //                             ],
      //                           ),
      //                         ),
      //                         const SizedBox(height: 16),
      //                       ],
      //                     ),
      //                   ));
      //         },
      //         label: const Text('Need verification code'),
      //         icon: const Icon(Icons.help),
      //       )
      //     : null,

      //

      appBar: AppBar(
        title: const Text('User Information'),
        centerTitle: true,
      ),

      //
      body: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                //name
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
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

                //mobile
                TextFormField(
                  controller: _mobileController,
                  validator: (value) {
                    if (value == null) {
                      return 'Enter Mobile Number';
                    } else if (value.length < 11 || value.length > 11) {
                      return 'Mobile Number at least 11 digits';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Mobile Number',
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_android_outlined),
                  ),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),

                // hall
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: _selectedHall,
                    hint: const Text('Choose Hall'),
                    // isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                      prefixIcon: Icon(Icons.home_work_outlined),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedHall = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Select your hall" : null,
                    items: widget.hallList.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                //blood
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                    value: _selectedBloodGroup,
                    hint: const Text('Blood Group'),
                    // isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                      prefixIcon: Icon(Icons.bloodtype_outlined),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedBloodGroup = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Select your blood group" : null,
                    items: kBloodGroup.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // button
                ElevatedButton(
                  onPressed: () {
                    if (_globalKey.currentState!.validate()) {
                      //
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen3(
                            university: widget.university,
                            department: widget.department,
                            batch: widget.batch,
                            session: widget.session,
                            id: widget.id,
                            name: _nameController.text,
                            phone: _mobileController.text,
                            selectedHall: _selectedHall!,
                            bloodGroup: _selectedBloodGroup!,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Next'.toUpperCase()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
