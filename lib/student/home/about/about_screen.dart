import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../../../utils/constants.dart';
import 'add_about.dart';
import 'edit_about.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About '),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: userModel.role[UserRole.admin.name]
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAbout(userModel: userModel),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: StreamBuilder<DocumentSnapshot>(

          ///Universities/University of Chittagong/Departments/Department of Psychology
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc(userModel.university)
              .collection('Departments')
              .doc(userModel.department)
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
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        //
                        Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey.shade100,
                          child: CachedNetworkImage(
                            imageUrl: data!.get('imageUrl'),
                            fadeInDuration: const Duration(milliseconds: 500),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
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

                        //
                        Container(
                          color: Colors.grey.shade100.withOpacity(.7),
                          padding: const EdgeInsets.only(left: 16, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //
                              Text(
                                data.id,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),

                              //
                              if (userModel.role[UserRole.admin.name])
                                IconButton(
                                  onPressed: () {
                                    //
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditAbout(
                                          userModel: userModel,
                                          data: data,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                )
                            ],
                          ),
                        ),
                        //
                      ],
                    ),
                    //image

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
