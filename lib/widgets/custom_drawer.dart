import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/utils/constants.dart';
import '/widgets/open_app.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            //
            Drawer(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Developer:'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
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
                                    image:
                                        AssetImage('assets/images/reyad.jpg'))),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            kDeveloperName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          const Text('UI/UX Designer, App Developer'),
                          const SizedBox(height: 8),
                          Row(
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
                          Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                  padding:
                                      const EdgeInsets.all(kIsWeb ? 16 : 10),
                                  child: const Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                //mail
                                MaterialButton(
                                  onPressed: () {
                                    OpenApp.withEmail(kAppEmail);
                                  },
                                  minWidth: 32,
                                  elevation: 4,
                                  color: Colors.red,
                                  shape: const CircleBorder(),
                                  padding:
                                      const EdgeInsets.all(kIsWeb ? 16 : 10),
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
                                  padding:
                                      const EdgeInsets.all(kIsWeb ? 16 : 10),
                                  child: const Icon(
                                    Icons.facebook,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'More'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    //
                    ListTileTheme(
                      horizontalTitleGap: 0,
                      minVerticalPadding: 0,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey, width: .2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // fb
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kFbGroup);
                              },
                              visualDensity: const VisualDensity(vertical: -2),
                              leading: const Icon(
                                Icons.facebook_outlined,
                                color: Colors.blue,
                              ),
                              title: const Text(
                                'Facebook Page',
                              ),
                              trailing: const Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 18,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // youtube
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kYoutubeUrl);
                              },
                              visualDensity: const VisualDensity(vertical: -2),
                              leading: const Icon(
                                Icons.video_collection_rounded,
                                color: Colors.red,
                              ),
                              title: const Text(
                                'Youtube Channel',
                              ),
                              trailing: const Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 18,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Rate us
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kPlayStoreUrl);
                              },
                              visualDensity: const VisualDensity(vertical: -2),
                              leading: const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              title: const Text(
                                'Rate Us',
                              ),
                              trailing: const Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 18,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // contributors
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Contributors()));
                                },
                                child: Text('Our contributors'.toUpperCase()),
                              ),
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                right: 8,
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear)),
            ),
          ],
        ),
      ),
    );
  }
}

//

class Contributors extends StatelessWidget {
  const Contributors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contributors'),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('contributors').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            var data = snapshot.data!.docs;

            if (data.isEmpty) {
              return const Center(child: Text('No contributors found'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) =>
                  ContributorCard(data: data[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            );
          }),
    );
  }
}

class ContributorCard extends StatelessWidget {
  const ContributorCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //img
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade200,
                image: data.get('image') == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(
                          data.get('image'),
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            //
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.get('name'),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  data.get('university'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  data.get('department'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
