import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '/models/stuff_model.dart';
import '/models/user_model.dart';
import '/utils/constants.dart';
import '/widgets/open_app.dart';
import 'add_emergency.dart';

class Emergency extends StatelessWidget {
  static const routeName = '/emergency';

  const Emergency({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Numbers'),
        centerTitle: true,
      ),

      //
      floatingActionButton: userModel.role[UserRole.admin.name]
          ? Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: FloatingActionButton(
                onPressed: () async {
                  //
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddEmergency(userModel: userModel)));
                },
                child: const Icon(Icons.add),
              ),
            )
          : null,
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(userModel.university)
            .collection('Emergency')
            .orderBy('serial')
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
                    StaffModel staffModel = StaffModel.fromJson(data[index]);

                    //
                    return GestureDetector(
                      onLongPress: userModel.role[UserRole.admin.name]
                          ? () async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete?"),
                                  content:
                                      const Text('Are you sure to delete?'),
                                  actions: [
                                    //delete
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),

                                    //delete
                                    TextButton(
                                        onPressed: () async {
                                          //
                                          await data[index]
                                              .reference
                                              .delete()
                                              .then((value) {
                                            //
                                            Fluttertoast.showToast(
                                                msg: 'Delete successfully');
                                            //
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text('Delete')),

                                    const SizedBox(width: 4)
                                  ],
                                ),
                              );
                            }
                          : null,
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              //
                              Row(
                                children: [
                                  //image
                                  // CachedNetworkImage(
                                  //   imageUrl: staffModel.imageUrl,
                                  //   fadeInDuration:
                                  //       const Duration(milliseconds: 500),
                                  //   imageBuilder: (context, imageProvider) =>
                                  //       CircleAvatar(
                                  //     backgroundImage: imageProvider,
                                  //     radius: 32,
                                  //   ),
                                  //   progressIndicatorBuilder:
                                  //       (context, url, downloadProgress) =>
                                  //           const CircleAvatar(
                                  //     radius: 32,
                                  //     backgroundImage: AssetImage(
                                  //         'assets/images/pp_placeholder.png'),
                                  //     child: CupertinoActivityIndicator(),
                                  //   ),
                                  //   errorWidget: (context, url, error) =>
                                  //       const CircleAvatar(
                                  //           radius: 32,
                                  //           backgroundImage: AssetImage(
                                  //               'assets/images/pp_placeholder.png')),
                                  // ),

                                  const SizedBox(width: 4),

                                  //name, post, phone
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //serial, name
                                      Row(
                                        children: [
                                          //serial
                                          if (userModel
                                              .role[UserRole.admin.name])
                                            Text(
                                              '${staffModel.serial}. ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          //name
                                          Text(
                                            staffModel.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ],
                                      ),

                                      //post
                                      Text(
                                        staffModel.post,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(color: Colors.grey),
                                      ),

                                      const SizedBox(height: 8),

                                      //
                                      if (staffModel.phone.isNotEmpty)
                                        GestureDetector(
                                          onTap: () async {
                                            String shareableText =
                                                '${staffModel.name}\n${staffModel.post}\n\n${staffModel.phone}\n';

                                            //
                                            await Share.share(shareableText,
                                                subject: 'Emergency Numbers');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 4, 16, 4),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              children: [
                                                //
                                                const Icon(
                                                  Icons.share_outlined,
                                                  size: 18,
                                                ),

                                                const SizedBox(width: 8),
                                                //
                                                Text(
                                                  staffModel.phone,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      //
                                    ],
                                  ),
                                ],
                              ),

                              //
                              if (staffModel.phone.isNotEmpty)
                                IconButton(
                                  onPressed: () {
                                    OpenApp.withNumber(staffModel.phone);
                                  },
                                  icon: const Icon(
                                    Icons.call_outlined,
                                    color: Colors.green,
                                  ),
                                )
                            ],
                          ),
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
