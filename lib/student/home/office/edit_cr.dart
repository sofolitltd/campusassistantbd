import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/cr_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/constants.dart';

class EditCr extends StatefulWidget {
  const EditCr({
    Key? key,
    required this.userModel,
    required this.crModel,
    required this.docId,
    required this.batchList,
  }) : super(key: key);

  final UserModel userModel;
  final CrModel crModel;
  final String docId;
  final List<String> batchList;

  @override
  State<EditCr> createState() => _EditCrState();
}

class _EditCrState extends State<EditCr> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fbController = TextEditingController();

  String? _selectedYear;
  String? _selectedBatch;
  bool _isLoading = false;

  @override
  void initState() {
    _nameController.text = widget.crModel.name;
    _emailController.text = widget.crModel.email;
    _phoneController.text = widget.crModel.phone;
    _fbController.text = widget.crModel.fb;
    _selectedYear = widget.crModel.year;
    _selectedBatch = widget.crModel.batch;
    //
    super.initState();
  }

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
        title: const Text('Edit CR'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref
                  .doc(widget.docId)
                  .delete()
                  .then((value) => Navigator.pop(context));
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
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
                minLines: 1,
                maxLines: 3,
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
                items: widget.batchList.reversed.map((String val) {
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
                            await ref
                                .doc(widget.docId.toString())
                                .update(crModel.toJson())
                                .then((value) {
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
