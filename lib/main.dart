import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lattice_work_flutter/config/RxConfig.dart';

import 'dart:math' as math;
import 'package:sliver_tools/sliver_tools.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MainState();
}

class _MainState extends State<MyHomePage> {
  final controller = Get.put(RxConfig());
  final _scrollController = ScrollController();

  // List<int> dataList = [];

  @override
  void initState() {
    // 基礎設定0
    controller.dataList.value = List<int>.generate(0, (index) => index);
    super.initState();
  }

  //
  // // 每按一次增加30筆資料
  // void _addMoreData() {
  //   setState(() {
  //     dataList
  //         .addAll(List<int>.generate(30, (index) => dataList.length + index));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('photo list')),
        body: Obx(
          () => DraggableScrollbar.semicircle(
            labelTextBuilder: (double offset) =>
                Text("${controller.pos.value}"),
            controller: _scrollController,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                ...List<Widget>.generate(controller.dataList.length, (index) {
                  return MultiSliver(
                    pushPinnedChildren: true,
                    children: [
                      SliverPersistentHeader(
                          pinned: true,
                          delegate: PinnedSliverPersistentHeaderDelegate(
                              (index + 1).toString(), onShouldRebuild: (index) {
                            controller.pos.value = int.parse(index);
                          })),
                      SliverToBoxAdapter(
                        child: Container(
                            height: _calculateRandomHeight(context),
                            color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                    .toInt())
                                .withOpacity(1.0),
                            child:
                                Center(child: Text("Content #${index + 1}"))),
                      )
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: controller.addMoreData,
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
// class PinnedSliverPersistentHeaderDelegate
//     extends SliverPersistentHeaderDelegate {
//   PinnedSliverPersistentHeaderDelegate(this.title);
//
//   String title;
//
//   @override
//   double get maxExtent => 55.0;
//
//   @override
//   double get minExtent => 50.0;
//
//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.blue,
//       alignment: Alignment.center,
//       child: Text('Header $title', style: const TextStyle(color: Colors.white)),
//     );
//   }
// }

class PinnedSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  PinnedSliverPersistentHeaderDelegate(this.title,
      {required this.onShouldRebuild});

  final ValueChanged<String> onShouldRebuild; // 回調函數

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
    onShouldRebuild(title);
    return Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text('Header $title', style: const TextStyle(color: Colors.white)),
    );
  }
}
