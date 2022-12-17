import 'package:campusassistant/widgets/open_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/utils/constants.dart';

class GetVerificationCode extends StatelessWidget {
  const GetVerificationCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Get verification code'),
      ),

      //
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: MediaQuery.of(context).size.width > 1000
                ? MediaQuery.of(context).size.width * .2
                : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // with fb
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: Text(">>> 1.Contact with facebook")),
              ),
              //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // instruction
                    const Text(
                        "Like our page and send a message with your\n 1. Name,\n 2. Batch No and\n 3. Student ID."),

                    const SizedBox(height: 12),
                    const Text(
                        "We will send your verification code as soon as possible."),

                    const SizedBox(height: 16),

                    //code with fb
                    OutlinedButton.icon(
                      onPressed: () {
                        OpenApp.withUrl(kFbGroup);
                      },
                      icon: const Icon(
                        Icons.facebook_outlined,
                        color: Colors.blue,
                      ),
                      label: const Text('Go to facebook page'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // with cr
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text(" >>> 2. Contact with CR")),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                    "Contact with class Representative with your\n 1. Name,\n 2. Batch No and\n 3. Student ID."),
              ),

              const SizedBox(height: 24),

              // 3
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  " >>> 3. Contact with Developer",
                  textAlign: TextAlign.center,
                ),
              ),

              //
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(8),
                          color: Colors.pink.shade100,
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/reyad.jpg'))),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      kDeveloperName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text('UI/UX Designer, App Developer'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.orange[100],
                          ),
                          child: const Text(
                            kDeveloperBatch,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.greenAccent[100],
                          ),
                          child: const Text(
                            kDeveloperSession,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Department of Psychology',
                      style: Theme.of(context).textTheme.bodyText1!,
                    ),
                    Text(
                      'University of Chittagong',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    //
                    Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //call
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withNumber(kDeveloperMobile);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.green,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(kIsWeb ? 16 : 10),
                            child: const Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 8),

                          //mail
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withEmail(kDeveloperEmail);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.red,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(kIsWeb ? 16 : 10),
                            child: const Icon(
                              Icons.mail,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 8),

                          //facebook
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withUrl(kDeveloperFb);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.blue,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(kIsWeb ? 16 : 10),
                            child: const Icon(
                              Icons.facebook,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
