import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class TransportsDetails extends StatelessWidget {
  final DocumentSnapshot data;
  const TransportsDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              String shareableText = data.get('imageUrl');

              //
              await Share.share(shareableText, subject: 'Transports');
            },
            icon: const Icon(
              Icons.share,
              // size: 20,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          //image
          Container(
            alignment: Alignment.center,
            child: InteractiveViewer(
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                imageUrl: data.get('imageUrl'),
                fadeInDuration: const Duration(milliseconds: 500),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                    ),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
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

          //
          Container(
            width: double.infinity,
            color: Colors.black.withOpacity(.4),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                Text(
                  data.get('title'),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),

                const SizedBox(height: 16),

                //
                Text(
                  data.get('time'),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white54,
                        fontWeight: FontWeight.w100,
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
