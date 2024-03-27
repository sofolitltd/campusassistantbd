import 'package:campusassistant/widgets/open_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/profile_data.dart';
import '/utils/constants.dart';

class BloodBank extends StatefulWidget {
  const BloodBank({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  State<BloodBank> createState() => _BloodBankState();
}

class _BloodBankState extends State<BloodBank> {
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Bank'),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: DropdownMenu<String>(
                width: 120,
                hintText: 'Group',
                inputDecorationTheme: const InputDecorationTheme(
                  contentPadding: EdgeInsets.only(left: 12),
                  isDense: true,
                  border: OutlineInputBorder(gapPadding: 0),
                  constraints: BoxConstraints(maxHeight: 40),
                ),
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                dropdownMenuEntries:
                    kBloodGroup.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ),
          ),
        ],
      ),

      //
      // floatingActionButton: userModel.role[UserRole.admin.name]
      //     ? Padding(
      //         padding: const EdgeInsets.only(bottom: 32),
      //         child: FloatingActionButton(
      //           onPressed: () async {
      //             //
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) =>
      //                         AddEmergency(userModel: userModel)));
      //           },
      //           child: const Icon(Icons.add),
      //         ),
      //       )
      //     : null,
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('university', isEqualTo: widget.profileData.university)
            .where('information.blood',
                isEqualTo: dropdownValue.isNotEmpty ? dropdownValue : null)
            .orderBy('name')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;
          //
          return data.isEmpty
              ? const Center(child: Text('No data found'))
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.width * .2
                        : 16,
                    vertical: 16,
                  ),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    //
                    return Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //1st
                            Row(
                              children: [
                                //name, post, phone
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //name
                                      Text(
                                        data[index].get('name'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),

                                      const SizedBox(height: 4),
                                      //dept
                                      Text(
                                        data[index].get('department'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),

                                      //
                                    ],
                                  ),
                                ),

                                //blood
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                  constraints: const BoxConstraints(
                                      minHeight: 40, minWidth: 56),
                                  alignment: Alignment.center,
                                  child: Text(
                                    data[index].get('information.blood'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),
                            //2nd
                            GestureDetector(
                              onTap: () {
                                //
                                String message =
                                    "Hello ${data[index].get('name')},\n\nI hope you're doing well.\n\nI urgently need ${data[index].get('information.blood')} blood and found your profile on the Campus Assistant app.\n\nYour help could save a life. If you're able to donate, it would mean a lot.\n\nPlease let me know soon if you can donate.\n\nThank you for considering my request.\n\nBest regards,\n${widget.profileData.name}\n${widget.profileData.mobile}";

                                //
                                OpenApp.withEmailNew(
                                  data[index].get('email'),
                                  subject: "Urgent Request for Blood Donation",
                                  message: message,
                                );
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 10,
                                  ),
                                  child:
                                      Text('Request for blood'.toUpperCase())),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 15),
                );
        },
      ),
    );
  }
}
