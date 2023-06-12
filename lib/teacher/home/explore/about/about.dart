import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/widgets/open_app.dart';
import '../../../../models/profile_data.dart';

class About extends StatelessWidget {
  static const routeName = '/about';

  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileData? profileData = Get.arguments['profileData'];

    return Scaffold(
      appBar: AppBar(
        title: Text(profileData!.department),
        centerTitle: true,
        elevation: 0,
      ),

      //
      body: StreamBuilder<DocumentSnapshot>(

          ///Universities/University of Chittagong/Departments/Department of Psychology
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc(profileData.university)
              .collection('Departments')
              .doc(profileData.department)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('some thing wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            //
            var data = snapshot.data;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 1000
                      ? MediaQuery.of(context).size.width * .2
                      : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //
                    Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey.shade100,
                      child: CachedNetworkImage(
                        imageUrl: data!.get('imageUrl'),
                        fadeInDuration: const Duration(milliseconds: 500),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                const CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade100,
                          ),
                        ),
                      ),
                    ),

                    //site
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            OpenApp.withUrl(data.get('website'));
                          },
                          visualDensity: const VisualDensity(vertical: -3),
                          title: Text(data.get('website')),
                          subtitle: const Text('website'),
                          leading: const Icon(
                            Icons.public,
                            size: 36,
                          ),
                          horizontalTitleGap: 8,
                          trailing: const Icon(Icons.arrow_right_alt_rounded),
                        ),
                      ),
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(data.get('about')),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
