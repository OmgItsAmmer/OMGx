import 'package:get/get.dart';

class DashboardController extends GetxController {
  var DataList = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDummyData();
  }

  void fetchDummyData() {
    DataList.addAll(List.generate(
        36,
            (index) => {
          'Column 1': 'Data ${index + 1}-1',
          'Column 2': 'Data ${index + 1}-2',
          'Column 3': 'Data ${index + 1}-3',
          'Column 4': 'Data ${index + 1}-4',
        }));
  }
}