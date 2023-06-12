import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import 'single_batch.dart';

class AllBatchList extends StatefulWidget {
  static const routeName = 'all_batch_list_screen';

  const AllBatchList({
    Key? key,
    required this.userModel,
    required this.batchList,
  }) : super(key: key);

  final UserModel userModel;
  final List batchList;

  @override
  State<AllBatchList> createState() => _AllBatchListState();
}

class _AllBatchListState extends State<AllBatchList> {
  @override
  Widget build(BuildContext context) {
    // UserModel userModel =
    //     ModalRoute.of(context)!.settings.arguments as UserModel;

    return DefaultTabController(
      length: widget.batchList.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text('All Student'),
          bottom: TabBar(
            tabs: widget.batchList.reversed
                .map((batch) => Tab(text: batch))
                .toList(),
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: widget.batchList.reversed
              .map(
                (selectedBatch) => SingleBatchScreen(
                  userModel: widget.userModel,
                  selectedBatch: selectedBatch,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
