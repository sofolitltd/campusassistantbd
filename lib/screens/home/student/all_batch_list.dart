import 'package:flutter/material.dart';

import '/screens/home/student/single_batch.dart';
import '/utils/constants.dart';
import '../../../models/user_model.dart';

class AllBatchList extends StatefulWidget {
  static const routeName = 'all_batch_list_screen';

  const AllBatchList({Key? key}) : super(key: key);

  @override
  State<AllBatchList> createState() => _AllBatchListState();
}

class _AllBatchListState extends State<AllBatchList> {
  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return DefaultTabController(
      length: kBatchList.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text('All Student List'),
          bottom: TabBar(
            tabs: kBatchList.reversed.map((batch) => Tab(text: batch)).toList(),
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: kBatchList.reversed
              .map((selectedBatch) => SingleBatchScreen(
                    userModel: userModel,
                    selectedBatch: selectedBatch,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
