import 'package:flutter/material.dart';

import '/screens/home/office/staff_list.dart';
import '../../../models/user_model.dart';
import 'cr_list.dart';

class OfficeScreen extends StatelessWidget {
  static const routeName = '/office_screen';

  const OfficeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CR & Office Staff'),
          centerTitle: true,
          bottom: TabBar(
            isScrollable:
                MediaQuery.of(context).size.width > 800 ? true : false,
            tabs: const [
              Tab(text: 'Class Representative'),
              Tab(text: 'Office Staff'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //cr list
            CrList(userModel: userModel),

            // stuff list
            StuffList(userModel: userModel),
          ],
        ),
      ),
    );
  }
}
