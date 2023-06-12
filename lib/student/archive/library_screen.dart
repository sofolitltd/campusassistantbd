import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/models/content_model.dart';
import '../study/widgets/content_card.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  String? university;
  String? department;

  //
  getData() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.getString('role');
    university = prefs.getString('university');
    department = prefs.getString('department');
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      //
      body: (university == null || department == null)
          ? CircularProgressIndicator()
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Universities')
                  .doc(university)
                  .collection('Departments')
                  .doc(department)
                  .collection('Books')
                  .orderBy('courseCode')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return const Center(child: Text('No data Found!'));
                }

                var data = snapshot.data!.docs;

                //
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: data.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 1000
                        ? MediaQuery.of(context).size.width * .2
                        : 12,
                    vertical: 12,
                  ),
                  itemBuilder: (context, index) {
                    //model
                    ContentModel courseContentModel =
                        ContentModel.fromJson(data[index]);

                    var contentData = data[index];

                    // // for web browser
                    // if (kIsWeb) {
                    //   return ContentCardWeb(
                    //     userModel: userModel!,
                    //     courseContentModel: courseContentModel,
                    //   );
                    // }

                    // for mobile
                    return ContentCard(
                      // userModel: userModel!,
                      courseContentModel: courseContentModel,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 12);
                  },
                );
              },
            ),
    );
  }
}
