import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/cr_model.dart';
import '/widgets/headline.dart';
import '/widgets/open_app.dart';
import '../../../../models/profile_data.dart';

class CrCard extends StatelessWidget {
  const CrCard({
    Key? key,
    required this.profileData,
    required this.year,
    required this.ref,
  }) : super(key: key);

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
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.all(8),

                          //image
                          leading: CachedNetworkImage(
                            imageUrl: crModel.imageUrl,
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
                              backgroundImage: AssetImage(
                                  'assets/images/pp_placeholder.png'),
                              child: CupertinoActivityIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              radius: 32,
                              backgroundImage: AssetImage(
                                  'assets/images/pp_placeholder.png'),
                            ),
                          ),

                          //
                          title: Text(
                            crModel.name,
                            overflow: TextOverflow.ellipsis,
                          ),

                          subtitle: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 3,
                                ),
                                margin: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.orange[100],
                                ),
                                child: Text(
                                  crModel.batch,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                              const Expanded(child: Text('')),
                            ],
                          ),
                          children: [
                            ListTileTheme(
                              horizontalTitleGap: 0,
                              child: Column(
                                children: [
                                  //
                                  Container(
                                    height: .5,
                                    width: double.infinity,
                                    color: Theme.of(context).dividerColor,
                                  ),
//phone
                                  if (crModel.phone.isNotEmpty)
                                    ListTile(
                                      onTap: () {
                                        OpenApp.withNumber(crModel.phone);
                                      },
                                      title: Text(crModel.phone),
                                      trailing: const Icon(
                                        Icons.call_outlined,
                                        color: Colors.green,
                                      ),
                                    ),

                                  //
                                  Container(
                                    height: .5,
                                    width: double.infinity,
                                    color: Theme.of(context).dividerColor,
                                  ),

                                  //mail
                                  if (crModel.email.isNotEmpty)
                                    ListTile(
                                      onTap: () {
                                        OpenApp.withEmail(crModel.email);
                                      },
                                      title: Text(crModel.email),
                                      trailing: const Icon(
                                        Icons.email_outlined,
                                        color: Colors.redAccent,
                                      ),
                                    ),

                                  //
                                  Container(
                                    height: .5,
                                    width: double.infinity,
                                    color: Theme.of(context).dividerColor,
                                  ),

                                  //fb
                                  if (crModel.fb.isNotEmpty)
                                    ListTile(
                                      onTap: () {
                                        OpenApp.withUrl(crModel.fb);
                                      },
                                      title: Text(crModel.fb),
                                      trailing: const Icon(
                                        Icons.facebook_outlined,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                ],
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
