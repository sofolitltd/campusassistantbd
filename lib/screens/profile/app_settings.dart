import '/utils/constants.dart';
import '/utils/constants.dart';
import 'package:flutter/material.dart';

import '/screens/profile/change_password.dart';
import '/widgets/open_app.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Settings',
        ),
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
          // pass change
          Text(
            'Change Password',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(),
          ),

          // pass
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(top: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePassword()));
              },
              visualDensity: const VisualDensity(vertical: -1),
              subtitle: Text(
                'Change your old password',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              title: Text(
                'Change Password',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(
                  (Icons.lock_outline),
                  color: Colors.purple,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // info title
          Text(
            'Contact us',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(),
          ),

          //
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // call
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    //
                    OpenApp.withNumber(kDeveloperMobile);
                  },
                  visualDensity: const VisualDensity(vertical: -1),
                  subtitle: Text(
                    'call us for more query',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    kDeveloperMobile,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    child: const Icon(
                      (Icons.call),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // facebook
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    //
                    OpenApp.withUrl(kFbGroup);
                  },
                  visualDensity: const VisualDensity(vertical: -1),
                  subtitle: Text(
                    'Facebook Page',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    kFbGroup,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      Icons.facebook,
                      size: 24,
                    ),
                  ),
                ),
              ),

              // email
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    //
                    OpenApp.withEmail(kAppEmail);
                  },
                  visualDensity: const VisualDensity(vertical: -1),
                  subtitle: Text(
                    'Official email address',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    kAppEmail,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade100,
                    child: const Icon(
                      Icons.email_outlined,
                      size: 24,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

              // youtube
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    //
                    OpenApp.withUrl(kYoutubeUrl);
                  },
                  visualDensity: const VisualDensity(vertical: -1),
                  subtitle: Text(
                    'Official youtube channel',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    'Youtube',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      Icons.play_arrow,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          //dev
          Text(
            'Develop by',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(),
          ),

          const SizedBox(height: 8),

          // call
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ExpansionTile(
              initiallyExpanded: true,
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              title: Text(
                'Sofol IT',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              subtitle: Text(
                'Contact to developer',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              leading: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.blue.shade50.withOpacity(.5),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.network(
                    kDevLogo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              children: [


                const Divider(height: 8),

                //web
                ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  onTap: () {
                    OpenApp.withUrl('https://$kDevWebsite');
                  },
                  title: const Text(kDevWebsite),
                  subtitle: const Text('visit website'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      (Icons.language),
                      color: Colors.black54,
                    ),
                  ),
                ),
                const Divider(height: 8),

                //call
                ListTile(
                  onTap: () {
                    OpenApp.withNumber(kDeveloperMobile);
                  },
                  visualDensity: const VisualDensity(vertical: -4),
                  title: const Text(kDeveloperMobile),
                  subtitle: const Text('call now'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      (Icons.call),
                      color: Colors.green.shade400,
                    ),
                  ),
                ),

                const Divider(height: 8),

                // email
                ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  onTap: () {
                    //
                    OpenApp.withEmail(kDevEmail);
                  },
                  title: const Text(kDevEmail),
                  subtitle: const Text('email address'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      (Icons.email),
                      color: Colors.black54,
                    ),
                  ),
                ),

                const Divider(height: 8),

                // youtube
                ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  onTap: () {
                    //
                    OpenApp.withUrl(kDevYoutube);
                  },
                  title: const Text(kDevYoutube),
                  subtitle: const Text('youtube channel'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      (Icons.play_arrow),
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
