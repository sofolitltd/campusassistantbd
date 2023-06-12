import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/content_model.dart';

class ResearchScreen extends StatefulWidget {
  const ResearchScreen({Key? key}) : super(key: key);

  @override
  State<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
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
                  .collection('Study')
                  .doc('Archive')
                  .collection('Research')
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
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 12),
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    //model
                    ContentModel courseContentModel =
                        ContentModel.fromJson(data[index]);

                    var contentData = data[index];
                    //
                    return Text('data');
                    // return ContentCard(
                    //   userModel: userModel!,
                    //   contentData: contentData,
                    //   courseContentModel: courseContentModel,
                    // );
                  },
                );
              }),
    );
  }
}
