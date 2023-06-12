import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../widgets/headline.dart';
import '../widgets/link_card.dart';

class ImportantLinks extends StatelessWidget {
  const ImportantLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //category title
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Headline(title: 'Important links'),
          ),

          // category card grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: linksList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: 8,
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemBuilder: (BuildContext context, int index) => LinkCard(
              title: linksList[index].title,
              link: linksList[index].link,
              imageUrl: linksList[index].image,
              color: linksList[index].color,
            ),
          ),

          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              //
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Batch')
                    .doc(snapshot.data!.get('batch'))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 8,
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    children: [
                      // psychology family
                      LinkCard(
                        title: 'Psychology family, CU Group',
                        link: snapshot.data!.get('family_group'),
                        imageUrl: 'assets/logo/facebook.png',
                      ),

                      //batch fb
                      LinkCard(
                        title: 'Batch Facebook Group',
                        link: snapshot.data!.get('fb_group'),
                        imageUrl: 'assets/logo/facebook.png',
                      ),

                      //psy cu.net
                      LinkCard(
                        title: 'Batch WhatsApp Group',
                        link: snapshot.data!.get('wa_group'),
                        imageUrl: 'assets/logo/whatsapp.png',
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class Links {
  final String title;
  final String image;
  final String link;
  final Color color;

  Links({
    required this.title,
    required this.image,
    required this.link,
    required this.color,
  });
}

List<Links> linksList = [
  Links(
    title: 'University of chittagong',
    image: 'assets/logo/cu_logo.png',
    link: 'https://cu.ac.bd/',
    color: Colors.white,
  ),
  Links(
    title: 'Department of psychology',
    image: 'assets/logo/psy_cu.png',
    link: 'https://www.psycu.net',
    color: Colors.orange,
  ),
  Links(
    title: 'Department of Psychology, CU',
    image: 'assets/logo/facebook.png',
    link: 'https://www.facebook.com/groups/psycu',
    color: Colors.blue,
  ),
];
