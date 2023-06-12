import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '/auth/new/widgets/common_dropdown_widget.dart';
import '/auth/new/widgets/common_text_field_widget.dart';
import '../../utils/constants.dart';
import 'new_student_create_account_screen.dart';

class NewStudentSignUpScreen extends StatefulWidget {
  const NewStudentSignUpScreen({
    Key? key,
    required this.university,
    required this.department,
    required this.profession,
    required this.name,
    required this.information,
    required this.hallList,
  }) : super(key: key);

  final String university;
  final String department;
  final String profession;
  final String name;
  final Map<dynamic, dynamic> information;
  final List<String> hallList;

  @override
  State<NewStudentSignUpScreen> createState() => _NewStudentSignUpScreenState();
}

class _NewStudentSignUpScreenState extends State<NewStudentSignUpScreen> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String? _selectedHall;
  String? _selectedBloodGroup;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    if (widget.information['blood'] != '') {
      _selectedBloodGroup = widget.information['blood'];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up(2/1)'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .3
                  : 16,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                Card(
                  elevation: 6,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Hello'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                        ),

                        Text(
                          'Fill your user information',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.w100,
                                  ),
                        ),

                        const Divider(height: 24),
                        Text(
                          widget.university,
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.w100,
                                    // color: Colors.blueGrey,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.department.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 4),

                        Text(
                          '${widget.information['batch']} : ID(${widget.information['id']})'
                              .toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),

                        const SizedBox(height: 16),

                        CommonTextFieldWidget(
                          controller: _nameController,
                          heading: 'Name',
                          hintText: 'Enter full name',
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter your name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: CommonTextFieldWidget(
                                controller: _mobileController,
                                heading: 'Mobile',
                                hintText: 'Enter mobile number',
                                keyboardType: TextInputType.phone,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Enter mobile number';
                                  }
                                  if (val.length < 11) {
                                    return 'Mobile number at least 11 digits';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            //
                            const SizedBox(width: 10),

                            Expanded(
                              flex: 2,
                              child: CommonDropDownWidget(
                                heading: 'Blood Group',
                                hint: 'Blood group',
                                value: _selectedBloodGroup,
                                itemList: kBloodGroup,
                                onChanged: (value) =>
                                    setState(() => _selectedBloodGroup = value),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        CommonDropDownWidget(
                          heading: 'Halls ',
                          hint: 'Select your hall',
                          value: _selectedHall,
                          itemList: widget.hallList,
                          onChanged: (value) =>
                              setState(() => _selectedHall = value),
                        ),

                        const SizedBox(height: 24),

                        //log in
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48)),
                          onPressed: () async {
                            if (_globalKey.currentState!.validate()) {
                              //
                              Get.to(
                                () => CreateAccountScreen(
                                  university: widget.university,
                                  department: widget.department,
                                  profession: widget.profession,
                                  name: _nameController.text.trim(),
                                  mobile: _mobileController.text.trim(),
                                  batch: widget.information['batch'],
                                  id: widget.information['id'],
                                  session: widget.information['session'],
                                  hall: _selectedHall ?? '',
                                  blood: _selectedBloodGroup ?? '',
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Next'.toUpperCase(),
                            style: const TextStyle(
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
