//
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  final String title;
  final String imageUrl;

  const FullImage({Key? key, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
      body: GestureDetector(
        // onDoubleTap: () {
        //   // Navigator.pop(context);
        // },
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: imageUrl == ''
                ? InteractiveViewer(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          scale: .5,
                          image: AssetImage(
                            'assets/images/pp_placeholder.png',
                          ),
                        ),
                      ),
                    ),
                  )
                : CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    imageUrl: imageUrl,
                    fadeInDuration: const Duration(milliseconds: 500),
                    imageBuilder: (context, imageProvider) => InteractiveViewer(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                          ),
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
    );
  }
}
