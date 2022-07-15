import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/cr_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/constants.dart';

class AddCr extends StatefulWidget {
  const AddCr({Key? key, required this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  State<AddCr> createState() => _AddCrState();
}

class _AddCrState extends State<AddCr> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fbController = TextEditingController();

  String? _selectedYear;
  String? _selectedBatch;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.userModel.university)
        .collection('Departments')
        .doc(widget.userModel.department)
        .collection('Cr');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add CR'),
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

              //email
              TextFormField(
                controller: _emailController,
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return 'Enter email';
                //   }
                //   //todo: email verify
                //   return null;
                // },
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
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

              const SizedBox(height: 16),

              //fb
              TextFormField(
                controller: _fbController,
                // validator: (value) => value!.isEmpty ?'Enter fb link': null,
                decoration: const InputDecoration(
                  hintText: 'Fb Link',
                  labelText: 'Fb Link',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.facebook_outlined),
                ),
                keyboardType: TextInputType.url,
              ),

              const SizedBox(height: 16),

              // batch
              DropdownButtonFormField(
                isExpanded: true,
                value: _selectedBatch,
                hint: const Text('Select Batch'),
                // isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                  prefixIcon: Icon(Icons.stacked_bar_chart_outlined),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _selectedBatch = value!;
                  });
                },
                validator: (value) => value == null ? "Select batch" : null,
                items: kBatchList.reversed.map((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // hall
              DropdownButtonFormField(
                isExpanded: true,
                value: _selectedYear,
                hint: const Text('Select Year'),
                // isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _selectedYear = value;
                  });
                },
                validator: (value) => value == null ? "Select year" : null,
                items: kYearList.map((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              //
              ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_globalKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            CrModel crModel = CrModel(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.isEmpty
                                  ? ''
                                  : _phoneController.text.trim(),
                              fb: _fbController.text.isEmpty
                                  ? ''
                                  : _fbController.text.trim(),
                              batch: _selectedBatch!,
                              year: _selectedYear!,
                              imageUrl: '',
                            );

                            //
                            await ref.doc().set(crModel.toJson()).then((value) {
                              setState(() => _isLoading = false);

                              Navigator.pop(context);
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
