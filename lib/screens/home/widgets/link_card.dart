import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkCard extends StatelessWidget {
  const LinkCard({
    Key? key,
    required this.title,
    this.color,
    required this.link,
    required this.imageUrl,
    this.enableBorder,
  }) : super(key: key);

  final String title;
  final Color? color;
  final String link;
  final String imageUrl;
  final bool? enableBorder;

  void _launchURL() async => await canLaunch(link)
      ? await launch(link)
      : throw 'Could not launch $link';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (link == '') {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: 'No Link Found');
        } else {
          Fluttertoast.showToast(msg: 'Opening...');
          _launchURL();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // color: Colors.purpleAccent.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: .2),
        ),

        //
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color ?? Colors.transparent,
              ),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
