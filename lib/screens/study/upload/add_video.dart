import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '/utils/constants.dart';
import '../../../models/course_model.dart';
import '../../../models/user_model.dart';
import '../../../services/database_service.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    required this.courseModel,
    // required this.courseType,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final CourseModel courseModel;
  // final String courseType;

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  int? _selectedChapterNo;
  List<String>? _selectedSessionList;

  final TextEditingController _videoTitleController = TextEditingController();
  final TextEditingController _videoSubtitleController =
      TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();

  @override
  void initState() {
    _selectedSessionList = kSessionList;
    super.initState();
  }

  @override
  void dispose() {
    _videoTitleController.dispose();
    _videoSubtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('Add Video'),
        ),

        //

        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .2
                : 16,
            vertical: 16,
          ),
          children: [
            //top path
            // buildPathSection(
            //   widget.selectedYear,
            //   widget.courseModel.courseCategory,
            //   widget.courseModel.courseCode,
            //   'Chapters',
            // ),

            const SizedBox(height: 16),

            //
            Form(
              key: _formState,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // chapter
                    Row(
                      children: [
                        Expanded(child: Container()),

                        //
                        Expanded(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField(
                              value: _selectedChapterNo,
                              hint: const Text('Chapter No'),
                              decoration: const InputDecoration(
                                label: Text('Chapter No'),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 8),
                              ),
                              onChanged: (int? value) {
                                setState(() {
                                  _selectedChapterNo = value;
                                });
                              },
                              validator: (value) =>
                                  value == null ? "Choose Chapter No" : null,
                              items: List.generate(15, (index) => 1 + index++)
                                  .map((int value) {
                                return DropdownMenuItem(
                                  alignment: Alignment.center,
                                  value: value,
                                  child: Text(
                                    '$value',
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // title
                    TextFormField(
                      controller: _videoTitleController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        hintText: 'Title',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Enter Title" : null,
                    ),

                    const SizedBox(height: 16),

                    // subtitle
                    TextFormField(
                      controller: _videoSubtitleController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Subtitle',
                        hintText: 'Subtitle',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Enter subtitle" : null,
                    ),

                    const SizedBox(height: 16),

                    // url
                    TextFormField(
                      controller: _videoUrlController,
                      keyboardType: TextInputType.url,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Video Url',
                        hintText: 'www.youtube.com/abc',
                      ),
                      validator: (value) => value!.isEmpty ? "Enter url" : null,
                    ),

                    const SizedBox(height: 16),

                    // session list
                    MultiSelectDialogField(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      selectedColor: Colors.blueAccent.shade100,
                      selectedItemsTextStyle:
                          const TextStyle(color: Colors.black),
                      title: const Text('Session List'),
                      buttonText: const Text('Session List'),
                      buttonIcon: const Icon(Icons.arrow_drop_down),
                      initialValue: _selectedSessionList,
                      items: kSessionList
                          .map((e) => MultiSelectItem(e, e))
                          .toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (List<String> values) {
                        setState(() {
                          _selectedSessionList = values;
                        });
                      },
                      validator: (values) => (values == null || values.isEmpty)
                          ? "Select session"
                          : null,
                    ),

                    const SizedBox(height: 16),

                    //
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formState.currentState!.validate()) {
                              //
                              await DatabaseService.refUniversities
                                  .doc(widget.userModel.university)
                                  .collection('Departments')
                                  .doc(widget.userModel.department)
                                  .collection('Videos')
                                  .doc()
                                  .set({
                                'title': _videoTitleController.text,
                                'subtitle': _videoSubtitleController.text,
                                'url': _videoUrlController.text,
                                'status': 'Basic',
                                'courseCode': widget.courseModel.courseCode,
                                'chapterNo': _selectedChapterNo,
                                'sessionList': _selectedSessionList,
                              });

                              //
                              Fluttertoast.showToast(msg: 'Add successfully')
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Text('Upload'))),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  // top path
  Wrap buildPathSection(String year, courseCategory, courseCode, chapter) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        //
        const Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.account_tree_outlined,
            color: Colors.black87,
            size: 20,
          ),
        ),

        // year
        Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(width: .5, color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(year)),

        //
        const Icon(Icons.keyboard_arrow_right_rounded),
        Text(courseCategory),

        //
        const Icon(Icons.keyboard_arrow_right_rounded),
        Text(courseCode),

        //
        const Icon(Icons.keyboard_arrow_right_rounded),
        Text(chapter),
      ],
    );
  }
}

//
