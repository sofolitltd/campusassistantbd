import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '/models/profile_data.dart';
import '/models/stuff_model.dart';
import '/widgets/open_app.dart';

class Staff extends StatelessWidget {
  const Staff({super.key, required this.profileData});
  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(profileData.university)
        .collection('Departments')
        .doc(profileData.department);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Office Staff'),
      ),
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.collection('Staff').orderBy('serial').snapshots(),
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
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              //
                              Row(
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
                                    CachedNetworkImage(
                                      imageUrl: staffModel.imageUrl,
                                      fadeInDuration:
                                          const Duration(milliseconds: 500),
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        backgroundImage: imageProvider,
                                        radius: 32,
                                      ),
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              const CircleAvatar(
                                        radius: 32,
                                        backgroundImage: AssetImage(
                                          'assets/images/pp_placeholder.png',
                                        ),
                                        child: CupertinoActivityIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                        radius: 32,
                                        backgroundImage: AssetImage(
                                            'assets/images/pp_placeholder.png'),
                                      ),
                                    ),

                                  const SizedBox(width: 12),

                                  //name, post, phone
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //name
                                      Row(
                                        children: [
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
                                                '${staffModel.name}\n${staffModel.post}\n\nPhone:\n+88${staffModel.phone}\n';

                                            //
                                            await Share.share(shareableText,
                                                subject: 'Phone number');
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
                                                      .bodyLarge,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                      // Row(
                                      //     children: [
                                      //       //
                                      //       const Icon(
                                      //         Icons.phone_android_outlined,
                                      //         size: 16,
                                      //       ),
                                      //
                                      //       const SizedBox(width: 8),
                                      //       //
                                      //       SelectableText(
                                      //         staffModel.phone,
                                      //         style: Theme.of(context)
                                      //             .textTheme
                                      //             .bodyText1,
                                      //       ),
                                      //     ],
                                      //   ),
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
