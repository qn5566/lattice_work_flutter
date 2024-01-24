import 'package:get/get.dart';

/// 動態參數設定
class RxConfig extends GetxController {
  // tab Title
  RxInt pos = 0.obs;

  var dataList = <int>[].obs;

  // 每按一次增加30筆資料
  void addMoreData() {
    dataList.addAll(List<int>.generate(30, (index) => dataList.length + index));
  }
}
