import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String search = "";
  String total = "";

  List universityList = [];
  String? _selectedUniversity;
  String? _selectedDepartment;

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
        appBar: AppBar(centerTitle: true, title: Text('All Users$total')),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .2
                    : 16,
                vertical: 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField(
                    isExpanded: true,
                    hint: const Text('Select your university'),
                    value: _selectedUniversity,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 13, horizontal: 13),
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 13),
                            labelText: 'Department',
                          ),
                          items: [].map((item) {
                            // university name
                            return DropdownMenuItem<String>(
                                value: item, child: Text(item));
                          }).toList(),
                          onChanged: (String? value) {},
                          validator: (value) => value == null
                              ? 'please select a department'
                              : null,
                        );
                      }

                      var docs = snapshot.data!.docs;
                      // select department
                      return DropdownButtonFormField(
                        hint: const Text('Select your department'),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 13),
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
                            _selectedDepartment = value!;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'please select a department' : null,
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  //roll
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 13,
                        ),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                        hintText: 'Search by Student ID'),
                    onChanged: (val) {
                      setState(() {
                        search = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            //
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('university', isEqualTo: _selectedUniversity)
                    .where('department', isEqualTo: _selectedDepartment)
                    // .orderBy('name')
                    .snapshots(),
                builder: (context, snapshots) {
                  if ((snapshots.connectionState == ConnectionState.waiting)) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    total = '(${snapshots.data!.size})';
                    //
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width > 800
                              ? MediaQuery.of(context).size.width * .2
                              : 16,
                          vertical: 0,
                        ),
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          //
                          Map<String, dynamic> data =
                              snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;

                          if (search.isEmpty) {
                            return card(data);
                          }
                          if (data['information']['id']
                              .toString()
                              .toLowerCase()
                              .startsWith(search.toLowerCase())) {
                            return card(data);
                          }
                          return Container();
                        });
                  }
                },
              ),
            ),
          ],
        ));
  }

  //
  card(Map<String, dynamic> profile) {
    return Container(
      // height: 86,
      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: .5, color: Colors.blueGrey.shade100),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image & badge
          Column(
            children: [
              //image
              CachedNetworkImage(
                imageUrl: profile['image'],
                fadeInDuration: const Duration(milliseconds: 500),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: 24,
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      AssetImage('assets/images/pp_placeholder.png'),
                  child: CupertinoActivityIndicator(),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        AssetImage('assets/images/pp_placeholder.png')),
              ),

              //badge
              if (profile['information']['status']['.subscriber'] == 'pro')
                const Row(
                  children: [
                    //
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.blue,
                    ),
                    //
                    Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(width: 12),

          //name , status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile['name'],
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),

                //
                Row(
                  children: [
                    Text(profile['information']['batch']),
                    const Text(' | '),
                    Text(
                      profile['information']['id'],
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(' | '),
                    Text(profile['information']['session']),
                  ],
                ),

                //

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.mail_outline_rounded,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(profile['email']),
                  ],
                ),

                //
                const SizedBox(height: 2),
                Row(
                  children: [
                    // is admin
                    if (profile['information']['status']['admin']) ...[
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.greenAccent.shade100,
                          ),
                          child: const Text('Admin')),
                      const SizedBox(width: 8),
                    ],

                    // is moderator
                    if (profile['information']['status']['moderator']) ...[
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.blue.shade100,
                          ),
                          child: const Text('Moderator')),
                      const SizedBox(width: 8),
                    ],

                    // is cr
                    if (profile['information']['status']['cr']) ...[
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.orange.shade100,
                          ),
                          child: const Text('CR')),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ],
            ),
          ),

          PopupMenuButton(
            itemBuilder: (context) => [
              //admin
              PopupMenuItem(
                value: 1,
                onTap: () async {
                  //
                  if (profile['information']['status']['admin']) {
                    //remove as moderator
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': false,
                          'moderator': profile['information']['status']
                              ['moderator'],
                          'cr': profile['information']['status']['cr'],
                        }
                      },
                    });
                  } else {
                    //add as admin
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': true,
                          'moderator': profile['information']['status']
                              ['moderator'],
                          'cr': profile['information']['status']['cr'],
                        }
                      },
                    });
                  }
                },
                child: (profile['information']['status']['admin'])
                    ? const Text('Remove as Admin')
                    : const Text('Add as Admin'),
              ),

              //moderator
              PopupMenuItem(
                value: 2,
                onTap: () async {
                  //
                  if (profile['information']['status']['moderator']) {
                    //remove as moderator
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': profile['information']['status']['admin'],
                          'moderator': false,
                          'cr': profile['information']['status']['cr'],
                        }
                      },
                    });
                  } else {
                    //add as admin
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': profile['information']['status']['admin'],
                          'moderator': true,
                          'cr': profile['information']['status']['cr'],
                        }
                      },
                    });
                  }
                },
                child: (profile['information']['status']['moderator'])
                    ? const Text('Remove as Moderator')
                    : const Text('Add as Moderator'),
              ),

              //cr
              PopupMenuItem(
                value: 3,
                onTap: () async {
                  // cr
                  if (profile['information']['status']['cr']) {
                    //remove as moderator
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': profile['information']['status']['admin'],
                          'moderator': profile['information']['status']
                              ['moderator'],
                          'cr': false,
                        }
                      },
                    });
                  } else {
                    //add as admin
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(profile['uid'])
                        .update({
                      'information': {
                        'batch': profile['information']['batch'],
                        'id': profile['information']['id'],
                        'session': profile['information']['session'],
                        'hall': profile['information']['hall'],
                        'blood': profile['information']['blood'],
                        'status': {
                          'admin': profile['information']['status']['admin'],
                          'moderator': profile['information']['status']
                              ['moderator'],
                          'cr': true,
                        }
                      },
                    });
                  }
                },
                child: (profile['information']['status']['cr'])
                    ? const Text('Remove as CR')
                    : const Text('Add as CR'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
