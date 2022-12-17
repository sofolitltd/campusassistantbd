import 'package:campusassistant/screens/study/widgets/pdf_viewer_web.dart';
import 'package:flutter/material.dart';

import '/models/content_model.dart';
import '/models/user_model.dart';
import '/widgets/open_app.dart';
import 'bookmark_button.dart';

class ContentCardWeb extends StatelessWidget {
  final UserModel userModel;
  final ContentModel courseContentModel;

  const ContentCardWeb({
    Key? key,
    required this.userModel,
    required this.courseContentModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          //
          ListTile(
            onTap: () async {
              //
              OpenApp.openPdf(courseContentModel.fileUrl);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            // horizontalTitleGap: 8,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: courseContentModel.imageUrl == ''
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 56),
                      child: Image.asset(
                        'assets/images/placeholder.jpg',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.network(
                      courseContentModel.imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
            title: Text(
              courseContentModel.contentTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text.rich(
              TextSpan(
                text: '${courseContentModel.contentSubtitleType}:  ',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 12,
                    ),
                children: [
                  TextSpan(
                    text: courseContentModel.contentSubtitle,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(),
                  )
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          //
          const Divider(height: 1),

          //
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 4, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // r1
                Row(
                  children: [
                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Code:',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.grey),
                        ),

                        //time
                        Text(courseContentModel.courseCode,
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                      child: VerticalDivider(thickness: 1),
                    ),

                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload on:',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.grey),
                        ),

                        //time
                        Text(courseContentModel.uploadDate,
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                      child: VerticalDivider(thickness: 1),
                    ),

                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload by:',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.grey),
                        ),

                        //uploader
                        Text(courseContentModel.uploader,
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ],
                ),

                //r2
                Row(
                  children: [
                    // preview
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        tooltip: 'Preview file',
                        onPressed: () {
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewerWeb(
                                contentTitle: courseContentModel.contentTitle,
                                fileUrl: courseContentModel.fileUrl,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.visibility_outlined,
                        ),
                      ),
                    ),

                    // fav
                    BookmarkButton(
                      userModel: userModel,
                      courseContentModel: courseContentModel,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
