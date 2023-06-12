import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/user_model.dart';
import '/utils/constants.dart';
import 'add_routine.dart';
import 'routine_details.dart';

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
      floatingActionButton: userModel.role[UserRole.admin.name]
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRoutine(userModel: userModel),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(userModel.university)
            .collection('Departments')
            .doc(userModel.department)
            .collection('Routine')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('some thing wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //
          var data = snapshot.data!.docs;

          return data.isEmpty
              ? const Center(child: Text('No data found'))
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: MediaQuery.of(context).size.width > 1000
                        ? MediaQuery.of(context).size.width * .2
                        : 10,
                  ),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RoutineDetails(data: data[index])));
                    },
                    child: Card(
                      elevation: 3,
                      child: SizedBox(
                        height: 250,
                        child: GridTile(
                          //footer
                          footer: Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                            decoration: BoxDecoration(
                              color:
                                  // Theme.of(context).cardColor.withOpacity(.8),
                                  Colors.blue.shade50.withOpacity(.9),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index].get('title'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                    ),

                                    const SizedBox(height: 4),

                                    //
                                    Text(
                                      data[index].get('time'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w100,
                                            color: Colors.black,
                                          ),
                                    ),
                                  ],
                                ),

                                if (userModel.role[UserRole.admin.name])
                                  IconButton(
                                    onPressed: () async {
                                      //
                                      await FirebaseFirestore.instance
                                          .collection('Universities')
                                          .doc(userModel.university)
                                          .collection('Departments')
                                          .doc(userModel.department)
                                          .collection('Routine')
                                          .doc(data[index].id)
                                          .delete();

                                      //
                                      await FirebaseStorage.instance
                                          .refFromURL(
                                              data[index].get('imageUrl'))
                                          .delete()
                                          .then((value) {
                                        Fluttertoast.showToast(
                                            msg: 'Delete successfully');
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ),
                                  ),
                                //
                              ],
                            ),
                          ),

                          //image
                          child: CachedNetworkImage(
                            imageUrl: data[index].get('imageUrl'),
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 6),
                );
        },
      ),
    );
  }
}
