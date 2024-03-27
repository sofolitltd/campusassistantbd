import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../models/profile_data.dart';
import '../../../../widgets/open_app.dart';
import '/models/cr_model.dart';
import '/widgets/headline.dart';
import 'cr_edit.dart';

class CrCard extends StatelessWidget {
  const CrCard({
    super.key,
    required this.profileData,
    required this.year,
    required this.ref,
  });

  final ProfileData profileData;
  final String year;
  final CollectionReference ref;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ref.where('year', isEqualTo: year).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              child: const Center(child: CircularProgressIndicator()));
        }

        var data = snapshot.data!.docs;
        //

        if (data.isNotEmpty) {
          return Column(
            children: [
              Headline(title: year),

              //
              ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  CrModel crModel = CrModel.fromJson(data[index]);

                  //
                  return GestureDetector(
                    //edit cr
                    onLongPress: profileData.information.status!.moderator!
                        ? () async {
                            List<String> batchList = [];
                            await FirebaseFirestore.instance
                                .collection('Universities')
                                .doc(profileData.university)
                                .collection('Departments')
                                .doc(profileData.department)
                                .collection('batches')
                                .orderBy('name')
                                .get()
                                .then(
                              (QuerySnapshot snapshot) {
                                for (var batch in snapshot.docs) {
                                  batchList.add(batch.get('name'));
                                }
                              },
                            ).then(
                              (value) {
                                //
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditCR(
                                      docID: data[index].id,
                                      profileData: profileData,
                                      crModel: crModel,
                                      batchList: batchList,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        : null,
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          crModel.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        // const SizedBox(height: 8),

                                        //batch, email, fb
                                        Row(
                                          children: [
                                            //batch
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 8),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 4, 12, 4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.orange[100],
                                              ),
                                              child: Text(crModel.batch),
                                            ),

                                            if (crModel.email.isNotEmpty)
                                              GestureDetector(
                                                onTap: () {
                                                  OpenApp.withEmail(
                                                      crModel.email);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 8),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 4, 12, 4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Colors.red[100],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.alternate_email,
                                                        color: Colors.black,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text('Email'
                                                          .toUpperCase()),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            // fb
                                            if (crModel.fb.isNotEmpty)
                                              GestureDetector(
                                                onTap: () {
                                                  OpenApp.withUrl(crModel.fb);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 4, 12, 4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Colors.blue[100],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.facebook_rounded,
                                                        color: Colors.black,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        'Fb'.toUpperCase(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // ph, share
                                  Row(
                                    children: [
                                      // call
                                      if (crModel.phone.isNotEmpty)
                                        GestureDetector(
                                          onTap: () {
                                            OpenApp.withNumber(crModel.phone);
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(right: 8),
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
                                                const Icon(
                                                  Icons.call_outlined,
                                                  color: Colors.green,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  crModel.phone,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                      //share
                                      GestureDetector(
                                        onTap: () async {
                                          String shareableText =
                                              '${crModel.name}\n\n${crModel.fb}\n\nPhone:\n+88${crModel.phone}\n';

                                          //
                                          await Share.share(shareableText,
                                              subject: crModel.name);
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
                            ),
                            //
                            const SizedBox(width: 16),
                            //
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: CachedNetworkImage(
                                imageUrl: crModel.imageUrl,
                                fadeInDuration:
                                    const Duration(milliseconds: 500),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: imageProvider,
                                  )),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/pp_placeholder.png'),
                                  )),
                                  child: const CupertinoActivityIndicator(),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/pp_placeholder.png'),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 12),
              ),
            ],
          );
        }

        // no data
        return Container();
      },
    );
  }
}
