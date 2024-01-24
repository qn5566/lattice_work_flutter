import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'package:sliver_tools/sliver_tools.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MainState();
}

class _MainState extends State<MyApp> {
  final _scrollController = ScrollController();
  List<int> dataList = [];

  @override
  void initState() {
    // 基礎設定0
    dataList = List<int>.generate(0, (index) => index);
    super.initState();
  }

  // 每按一次增加30筆資料
  void _addMoreData() {
    setState(() {
      dataList
          .addAll(List<int>.generate(30, (index) => dataList.length + index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('photo list')),
        body: DraggableScrollbar.semicircle(
          labelTextBuilder: (double offset) => Text(
              "${offset ~/ (MediaQuery.sizeOf(context).height * 0.25 + 55) + 1}"),
          controller: _scrollController,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              ...List<Widget>.generate(dataList.length, (index) {
                return MultiSliver(
                  pushPinnedChildren: true,
                  children: [
                    SliverPersistentHeader(
                        pinned: true,
                        delegate: PinnedSliverPersistentHeaderDelegate(
                            (index + 1).toString())),
                    SliverToBoxAdapter(
                      child: Container(
                          height: _calculateRandomHeight(context),
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(1.0),
                          child: Center(child: Text("Content #${index + 1}"))),
                    )
                  ],
                );
              }),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: _addMoreData,
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      ),
    );
  }
}

// 計算隨機高度
double _calculateRandomHeight(BuildContext context) {
  // 計算隨機高度，但至少為屏幕高度的1/4
  double minHeight = MediaQuery.of(context).size.height * 0.25;
  double maxHeight = MediaQuery.of(context).size.height;

  return math.Random().nextDouble() * (maxHeight - minHeight) + minHeight;
}

// Sliver 標題
class PinnedSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  PinnedSliverPersistentHeaderDelegate(this.title);

  String title;

  @override
  double get maxExtent => 55.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text('Header $title', style: const TextStyle(color: Colors.white)),
    );
  }
}
