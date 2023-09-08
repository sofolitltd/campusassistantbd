import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenApp {
  //
  static withUrl(String path) async {
    var url = Uri.parse(path);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      log('error');
    }
  }

  //
  static openPdf(String path) async {
    var url = Uri.parse(path);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.platformDefault,
      );
    } else {
      log('error');
    }
  }

  //
  static withNumber(number) async {
    if (number == '') {
      Fluttertoast.showToast(msg: 'No number found');
    } else {
      var url = Uri(scheme: 'tel', path: number);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
        );
      } else {
        log('error');
      }
    }
  }

  //
  static withEmail(email) async {
    if (email == '') {
      Fluttertoast.showToast(msg: 'No email found');
    } else {
      var url = Uri(scheme: 'mailto', path: email);
      try {
        await launchUrl(url);
      } catch (e) {
        log('error');
      }
    }
  }
}
