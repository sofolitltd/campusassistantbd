import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';

class Admin extends StatelessWidget {
  final UserModel userModel;

  const Admin({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('university', isEqualTo: userModel.university)
        .orderBy('batch', descending: true)
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
                  // shrinkWrap: true,
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
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        horizontalTitleGap: 8,
                        leading: CachedNetworkImage(
                          imageUrl: data[index].get('imageUrl'),
                          fadeInDuration: const Duration(milliseconds: 500),
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 32,
                          ),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  const CircleAvatar(
                            radius: 32,
                            backgroundImage:
                                AssetImage('assets/images/pp_placeholder.png'),
                            child: CupertinoActivityIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  radius: 32,
                                  backgroundImage: AssetImage(
                                      'assets/images/pp_placeholder.png')),
                        ),
                        title: Row(
                          children: [
                            //name
                            Text(data[index].get('name')),

                            const SizedBox(width: 8),

                            //badge
                            if (data[index].get('status') == 'Pro')
                              const Icon(
                                Icons.check_circle,
                                size: 22,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            // is admin
                            data[index].get('role')['admin'] == true
                                ? Flexible(
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          // border: Border.all(color: Colors.grey.shade400),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.greenAccent,
                                        ),
                                        child: const Text('Admin')),
                                  )
                                : Text(data[index].get('batch')),

                            const SizedBox(width: 8),

                            // is cr
                            data[index].get('role')['cr'] == true
                                ? Flexible(
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          // border: Border.all(color: Colors.grey.shade400),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.orangeAccent,
                                        ),
                                        child: const Text('Moderator')),
                                  )
                                : Text('>>  ${data[index].get('id')}'),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            //admin
                            PopupMenuItem(
                              value: 1,
                              onTap: () async {
                                //
                                if (data[index].get('role')['admin'] == true) {
                                  //remove as admin
                                  data[index].reference.update({
                                    'role': {
                                      'admin': false,
                                      'cr': data[index].get('role')['cr'],
                                    },
                                  });
                                } else {
                                  //add as admin
                                  data[index].reference.update({
                                    'role': {
                                      'admin': true,
                                      'cr': data[index].get('role')['cr'],
                                    },
                                  });
                                }
                              },
                              child: data[index].get('role')['admin'] == true
                                  ? const Text('Remove as admin')
                                  : const Text('Add as admin'),
                            ),

                            //cr
                            PopupMenuItem(
                              value: 2,
                              onTap: () {
                                //
                                //
                                if (data[index].get('role')['cr'] == true) {
                                  //remove as admin
                                  data[index].reference.update({
                                    'role': {
                                      'admin': data[index].get('role')['admin'],
                                      'cr': false,
                                    },
                                  });
                                } else {
                                  //add as admin
                                  data[index].reference.update({
                                    'role': {
                                      'admin': data[index].get('role')['admin'],
                                      'cr': true,
                                    },
                                  });
                                }
                              },
                              child: data[index].get('role')['cr'] == true
                                  ? const Text('Remove as moderator')
                                  : const Text('Add as moderator'),
                            ),

                            //cr
                            PopupMenuItem(
                              value: 3,
                              onTap: () {
                                //
                                //
                                if (data[index].get('status') == 'Pro') {
                                  //remove as admin
                                  data[index].reference.update({
                                    'status': 'Basic',
                                  });
                                } else {
                                  //add as admin
                                  data[index].reference.update({
                                    'status': 'Pro',
                                  });
                                }
                              },
                              child: data[index].get('status') == 'Pro'
                                  ? const Text('Remove as Pro user')
                                  : const Text('Add as Pro user'),
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
