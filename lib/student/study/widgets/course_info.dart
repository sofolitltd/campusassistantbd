//
import 'package:flutter/material.dart';

Column courseInfo(BuildContext context, {required title, required value}) {
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      // SizedBox(width: 8),
      Text(
        value,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        // const TextStyle(
        //   fontSize: 16,
        //   fontWeight: FontWeight.w600,
        //   // color: Colors.black87,
        // ),
      ),
    ],
  );
}
