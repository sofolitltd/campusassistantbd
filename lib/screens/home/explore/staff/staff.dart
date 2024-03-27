import 'package:cached_network_image/cached_network_image.dart';
import 'package:campusassistant/screens/home/explore/staff/staff_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../widgets/open_app.dart';
import '/models/profile_data.dart';
import '/models/staff_model.dart';
import '/screens/home/explore/staff/staff_add.dart';

class Staff extends StatelessWidget {
  const Staff({
    super.key,
    required this.university,
    required this.department,
    required this.profileData,
  });

  final String university;
  final String department;
  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(profileData.university)
        .collection('Departments')
        .doc(profileData.department)
        .collection('Staff');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Office Staff'),
      ),

      // add staff
      floatingActionButton: profileData.information.status!.moderator!
          ? FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddStaff(
                        university: university,
                        department: department,
                        profileData: profileData),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.orderBy('serial').snapshots(),
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
                  // shrinkWrap: true,\
                  physics: const BouncingScrollPhysics(),
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
                      onLongPress: () {
                        if (profileData.information.status!.moderator!) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditStaff(
                                university: university,
                                department: department,
                                profileData: profileData,
                                staffModel: staffModel,
                                docID: data[index].id,
                              ),
                            ),
                          );
                        }
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              //image

                              if (staffModel.imageUrl == '')
                                const CircleAvatar(
                                  radius: 32,
                                  backgroundImage: AssetImage(
                                    'assets/images/pp_placeholder.png',
                                  ),
                                ),

                              //
                              if (staffModel.imageUrl != '')
                                SizedBox(
                                  width: 64,
                                  height: 78,
                                  child: CachedNetworkImage(
                                    imageUrl: staffModel.imageUrl,
                                    fadeInDuration:
                                        const Duration(milliseconds: 500),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/images/pp_placeholder.png',
                                            )),
                                      ),
                                      child: const CupertinoActivityIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/images/pp_placeholder.png',
                                            )),
                                      ),
                                      child: const CupertinoActivityIndicator(),
                                    ),
                                  ),
                                ),

                              const SizedBox(width: 12),

                              //name, post, phone
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  Row(
                                    children: [
                                      //serial
                                      if (profileData
                                          .information.status!.moderator!)
                                        Text(
                                          '${staffModel.serial} .  ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      Text(
                                        staffModel.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  //post
                                  Text(
                                    staffModel.post,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),

                                  const SizedBox(height: 12),

                                  //
                                  if (staffModel.phone.isNotEmpty)
                                    Row(
                                      children: [
                                        // call
                                        if (staffModel.phone.isNotEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              OpenApp.withNumber(
                                                  staffModel.phone);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 4, 16, 4),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .dividerColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.call_outlined,
                                                    color: Colors.green,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    staffModel.phone,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        const SizedBox(width: 8),
                                        //share
                                        GestureDetector(
                                          onTap: () async {
                                            String shareableText =
                                                '${staffModel.name}\n${staffModel.post}\n\nPhone:\n+88${staffModel.phone}\n';

                                            //
                                            await Share.share(shareableText,
                                                subject: staffModel.name);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 4, 16, 4),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              children: [
                                                //
                                                const Icon(
                                                  Icons.share_outlined,
                                                  size: 16,
                                                ),

                                                const SizedBox(width: 8),
                                                //
                                                Text(
                                                  'Share'.toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
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
