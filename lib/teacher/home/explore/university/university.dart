import 'package:cached_network_image/cached_network_image.dart';
import 'package:campusassistant/widgets/open_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/profile_data.dart';

class University extends StatelessWidget {
  static const routeName = '/university';

  const University({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileData? profileData = Get.arguments['profileData'];
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(profileData!.university);

    return Scaffold(
      appBar: AppBar(
        title: Text(profileData.university),
        centerTitle: true,
      ),

      //
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: ref.snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data!;

                //
                return Column(
                  children: [
                    //image
                    Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey.shade100,
                      child: CachedNetworkImage(
                        imageUrl: data.get('images')[0],
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

                    const SizedBox(height: 8),

                    //
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          //area
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    //
                                    Text(
                                      data.get('area'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),

                                    //
                                    const Text('Acres'),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 4),

                          //faculties
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    //
                                    Text(
                                      data.get('faculties'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),

                                    //
                                    const Text('Faculties'),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 4),

                          //dept
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    //
                                    Text(
                                      data.get('departments'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),

                                    //
                                    const Text('Departments'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
                  ],
                );
              },
            ),

            //
            Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                child: ExpansionTile(
                  title: const Text('Halls'),
                  backgroundColor: Colors.transparent,
                  children: [
                    //
                    StreamBuilder<QuerySnapshot>(
                      stream: ref.collection('Halls').orderBy('id').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        var data = snapshot.data!.docs;
                        //
                        return data.isEmpty
                            ? const Center(child: Text('No data found'))
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width > 800
                                          ? MediaQuery.of(context).size.width *
                                              .2
                                          : 10,
                                  vertical: 8,
                                ),
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //
                                  if (data[index].get('name') !=
                                      'None(Not in List)') {
                                    return Card(
                                      elevation: 0,
                                      margin: EdgeInsets.zero,
                                      child: ListTile(
                                        // visualDensity: const VisualDensity(vertical: -2),
                                        title: Text(data[index].get('name')),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(height: 8),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
