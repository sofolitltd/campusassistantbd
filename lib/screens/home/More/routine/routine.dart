import 'package:cached_network_image/cached_network_image.dart';
import 'package:campusassistant/screens/home/More/routine_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';

class Routine extends StatelessWidget {
  static const routeName = '/routine';

  const Routine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine'),
        centerTitle: true,
      ),

      //
      body: StreamBuilder<DocumentSnapshot>(
        ///Universities/University of Chittagong/Departments/Department of Psychology
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(userModel.university)
            .collection('Departments')
            .doc(userModel.department)
            // .collection('Routine')
            // .doc()
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

          return ListView.separated(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 10,
            ),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) => Card(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoutineDetails(data: data!)));
                },
                child: SizedBox(
                  height: 200,
                  child: GridTile(
                    //footer
                    footer: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(.7),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Routine 2022',
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),

                          const SizedBox(height: 4),

                          //
                          Text(
                            'Aug 15 AT 11:16 PM',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w100,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    //image
                    child: CachedNetworkImage(
                      imageUrl: data!.get('imageUrl'),
                      fadeInDuration: const Duration(milliseconds: 500),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
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
                ),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 6),
          );
        },
      ),
    );
  }
}
