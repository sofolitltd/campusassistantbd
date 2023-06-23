import 'package:flutter/material.dart';

Widget pathSectionWidget({
  required String year,
  required String courseCode,
  required String courseType,
  String? chapterNo,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //
      const Padding(
        padding: EdgeInsets.all(3),
        child: Icon(
          Icons.webhook,
          color: Colors.grey,
          size: 18,
        ),
      ),

      //
      Flexible(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // year
            Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(width: .5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(year)),

            //courseCode
            Text(' / $courseCode'),

            //chapterNo
            if (courseType == 'Notes') Text(' / Chapter ${chapterNo!}'),
            //courseType
            Text(' / $courseType'),
          ],
        ),
      ),
    ],
  );
}
