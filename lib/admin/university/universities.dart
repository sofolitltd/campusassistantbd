import 'package:campusassistant/admin/university/edit_university.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/admin/university/add_university.dart';
import 'university_details.dart';

class Universities extends StatelessWidget {
  const Universities({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Universities',
          // style: TextStyle(color: Colors.black),
        ),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddUniversity()));
          //
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('Universities').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No data found'));
            }

            return ListView.separated(
              itemCount: docs.length,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .2
                    : 16,
                vertical: 16,
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 16),
              itemBuilder: (context, index) {
                UniversityModel university =
                    UniversityModel.fromJson(docs[index]);
                //
                return GestureDetector(
                  onTap: () {
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UniversityDetails(university: university.name),
                      ),
                    );
                  },
                  onLongPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditUniversity(university: university)));
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ListTile(
                        leading: Container(
                            height: 48,
                            width: 48,
                            decoration: university.images[0].toString().isEmpty
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue.shade50,
                                  )
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        university.images[0],
                                      ),
                                    ),
                                  )),
                        title: Text(
                          university.name,
                          style: const TextStyle(color: Colors.purple),
                        ),
                        subtitle: Text(
                          '${university.faculties} Faculty ,  ${university.departments} Department',
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

class UniversityModel {
  final String name;
  final String area;
  final String faculties;
  final String departments;
  final String website;
  final List<dynamic> images;

  UniversityModel({
    required this.name,
    required this.area,
    required this.faculties,
    required this.departments,
    required this.website,
    required this.images,
  });

  factory UniversityModel.fromJson(var json) {
    return UniversityModel(
      name: json['name'],
      area: json['area'],
      faculties: json['faculties'],
      departments: json['departments'],
      website: json['website'],
      images: json['images'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'area': area,
        'faculties': faculties,
        'departments': departments,
        'website': website,
        'images': images,
      };
}
