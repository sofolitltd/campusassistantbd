import 'package:campusassistant/admin/university_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Universities extends StatelessWidget {
  const Universities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = '';
    String faculties = '';
    String departments = '';
    String area = '';
    String website = '';
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
          // todo: change to page later
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              titlePadding: const EdgeInsets.only(left: 16),
              actionsPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  const Text('Add university'),

                  //
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
              actions: [
                //
                TextField(
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    name = val;
                  },
                ),

                const SizedBox(height: 16),

                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Faculties',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    faculties = val;
                  },
                ),

                const SizedBox(height: 16),

                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Departments',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    departments = val;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Area',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    area = val;
                  },
                ),

                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'Website',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    website = val;
                  },
                ),

                const SizedBox(height: 16),

                //
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        UniversityModel universityModel = UniversityModel(
                          name: name.trim(),
                          faculties: faculties.trim(),
                          departments: departments.trim(),
                          website: website.trim(),
                          area: area.trim(),
                          images: [
                            'https://cdn.vectorstock.com/i/1000x1000/48/06/image-preview-icon-picture-placeholder-vector-31284806.webp'
                          ],
                        );

                        //
                        if (name != '' &&
                            faculties != '' &&
                            departments != '' &&
                            area != '' &&
                            website != '') {
                          await FirebaseFirestore.instance
                              .collection('Universities')
                              .doc(name)
                              .set(universityModel.toJson())
                              .then((value) {
                            Navigator.pop(context);
                          });
                        } else {
                          Fluttertoast.showToast(msg: 'Enter all field');
                        }
                        //
                      },
                      child: Text('Add now'.toUpperCase())),
                )
              ],
            ),
          );
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
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(university.images[0]),
                        ),
                        title: Text(university.name),
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
