import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../widgets/open_app.dart';

class GetVerificationCodeScreen extends StatelessWidget {
  const GetVerificationCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Verification Code'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .3
                : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Get verification code from CR'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                    ),
                    // instruction
                    const Text(
                      "Connect with your class representative",
                      style: TextStyle(fontWeight: FontWeight.w100),
                    ),

                    const SizedBox(height: 16),

                    //code with fb
                    OutlinedButton.icon(
                      onPressed: () {
                        Get.to(() => const ContactWithCR());
                      },
                      icon: const Icon(
                        Icons.play_circle_fill_outlined,
                        color: Colors.green,
                      ),
                      label: Text(
                        'Contact with CR/Moderator'.toUpperCase(),
                        style: const TextStyle(
                          letterSpacing: .5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Register with facebook'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                    ),
                    // instruction
                    const Text(
                      "Like the page and send a message with",
                      style: TextStyle(fontWeight: FontWeight.w100),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "Requirements:".toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Colors.deepOrange,
                            letterSpacing: .4,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),

                    const Text(
                      "1. Full Name (as per certificate)."
                      "\n2. University, Department & Student ID."
                      "\n3. Photo of Student ID (Clear photo).",
                      style: TextStyle(height: 1.4),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                        "We will register your email as soon as possible."),

                    const SizedBox(height: 8),

                    //code with fb
                    OutlinedButton.icon(
                      onPressed: () {
                        OpenApp.withUrl(kFbGroup);
                      },
                      icon: const Icon(
                        Icons.facebook_outlined,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Go to facebook page'.toUpperCase(),
                        style: const TextStyle(
                          letterSpacing: .5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Contact with Developer".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
              ),

              //
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(8),
                          color: Colors.pink.shade100,
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/reyad.jpg'))),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      kDeveloperName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text('UI/UX Designer, App Developer'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.orange[100],
                          ),
                          child: const Text(
                            kDeveloperBatch,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.greenAccent[100],
                          ),
                          child: const Text(
                            kDeveloperSession,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Department of Psychology',
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    Text(
                      'University of Chittagong',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    //
                    Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //call
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withNumber(kDeveloperMobile);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.green,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(kIsWeb ? 16 : 10),
                            child: const Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 8),

                          //mail
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withEmail(kDeveloperEmail);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.red,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(kIsWeb ? 16 : 10),
                            child: const Icon(
                              Icons.mail,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 8),

                          //facebook
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withUrl(kDeveloperFb);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.blue,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(kIsWeb ? 16 : 10),
                            child: const Icon(
                              Icons.facebook,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
class ContactWithCR extends StatefulWidget {
  const ContactWithCR({super.key});

  @override
  State<ContactWithCR> createState() => _ContactWithCRState();
}

class _ContactWithCRState extends State<ContactWithCR> {
  List universityList = [];
  String? _selectedUniversity;
  String? _selectedDepartment;
  String? _selectedBatch;

  @override
  void initState() {
    getUniversityList();
    super.initState();
  }

  // get university
  getUniversityList() {
    FirebaseFirestore.instance.collection('Universities').get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() => universityList.add(doc.id));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact with CR/Moderator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .3
                : 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // university list
              DropdownButtonFormField(
                isExpanded: true,
                hint: const Text('Select your university'),
                value: _selectedUniversity,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'University',
                ),
                items: universityList
                    .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedUniversity = null;
                    _selectedDepartment = null;
                    _selectedUniversity = value!;
                  });
                },
                validator: (value) =>
                    value == null ? 'please select a university' : null,
              ),

              const SizedBox(height: 16),

              // Departments
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Universities')
                    .doc(_selectedUniversity)
                    .collection('Departments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Some thing went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // loading state
                    return DropdownButtonFormField(
                      hint: const Text('Select your department'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Department',
                      ),
                      items: [].map((item) {
                        // university name
                        return DropdownMenuItem<String>(
                            value: item, child: Text(item));
                      }).toList(),
                      onChanged: (String? value) {},
                      validator: (value) =>
                          value == null ? 'please select a department' : null,
                    );
                  }

                  var docs = snapshot.data!.docs;
                  // select department
                  return DropdownButtonFormField(
                    hint: const Text('Select your department'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Department',
                    ),
                    value: _selectedDepartment,
                    items: docs.map((item) {
                      // university name
                      return DropdownMenuItem<String>(
                          value: item.id, child: Text(item.id));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedBatch = null;
                        _selectedDepartment = value!;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'please select a department' : null,
                  );
                },
              ),

              const SizedBox(height: 16),

              //batches
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Universities')
                    .doc(_selectedUniversity)
                    .collection('Departments')
                    .doc(_selectedDepartment)
                    .collection('Batches')
                    .orderBy('name', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Some thing went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // loading state
                    return DropdownButtonFormField(
                      hint: const Text('Select your batch'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Batch',
                      ),
                      items: [].map((item) {
                        // university name
                        return DropdownMenuItem<String>(
                            value: item, child: Text(item));
                      }).toList(),
                      onChanged: (String? value) {},
                      validator: (value) =>
                          value == null ? 'please select your batch' : null,
                    );
                  }

                  var docs = snapshot.data!.docs;
                  //batch
                  return DropdownButtonFormField(
                    hint: const Text('Select your batch'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Batch',
                    ),
                    value: _selectedBatch,
                    items: docs.map((item) {
                      // university name
                      return DropdownMenuItem<String>(
                          value: item.get('name'),
                          child: Text(item.get('name')));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedBatch = value!;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'please select your batch' : null,
                  );
                },
              ),

              const SizedBox(height: 24),

              Text(
                'CR/Moderator List',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              // cr
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('contributors')
                    .where('university', isEqualTo: _selectedUniversity)
                    .where('department', isEqualTo: _selectedDepartment)
                    .where('batch', isEqualTo: _selectedBatch)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Some thing went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // loading state
                    return const Text('...');
                  }

                  var docs = snapshot.data!.docs;
                  if (docs.length.isEqual(0)) {
                    // loading state
                    return const Text('No Cr/Moderator found!');
                  }

                  //batch
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        OpenApp.withUrl(docs[index].get('facebook'));
                      },
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(docs[index].get('image')),
                      ),
                      title: Text(
                        docs[index].get('name'),
                      ),
                      subtitle: Text(
                        docs[index].get('facebook'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: const Icon(Icons.arrow_right_alt_outlined),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
