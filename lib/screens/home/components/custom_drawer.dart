import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/utils/constants.dart';
import '/widgets/open_app.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Divider(height: 0),
                    const SizedBox(height: 8),
                    const Text('Developed by:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    const SizedBox(height: 8),
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
                              image: AssetImage('assets/images/reyad.jpg'))),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      kDeveloperName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text('UX Designer & App Developer'),
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
                      style: Theme.of(context).textTheme.bodyText1!,
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
                              OpenApp.openPdf(kDeveloperMobile);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.green,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(kIsWeb ? 16 : 10),
                            child: const Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 8),

                          //mail
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withEmail(kDeveloperEmail);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.red,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(kIsWeb ? 16 : 10),
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
                            padding: const EdgeInsets.all(kIsWeb ? 16 : 10),
                            child: const Icon(
                              Icons.facebook,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'More',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                ],
              ),
            ),

            // fb
            ListTile(
              onTap: () {
                OpenApp.withUrl(kFbGroup);
              },
              leading: const Icon(Icons.facebook_outlined),
              title: const Text('Facebook Page'),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18,
              ),
            ),

            // website
            ListTile(
              onTap: () {
                //todo: youtube
                // OpenApp.withUrl(kFbGroup);
              },
              leading: const Icon(Icons.video_collection_rounded),
              title: const Text('Youtube Channel'),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  Widget contributorCard(String name, String session, String imageName) {
    return Column(
      children: [
        CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/$imageName')),
        const SizedBox(height: 8),
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Text('session: $session'),
      ],
    );
  }
}
