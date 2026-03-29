import 'package:get/get.dart';
import '../services/api_service.dart';

class MentalHealthController extends GetxController {
  var isPredicting = false.obs;
  var latestResult = "".obs;
  var confidenceScore = 0.0.obs;
  var modelBreakdown = {}.obs;

  Future<void> runPrediction(Map<String, dynamic> data) async {
    isPredicting.value = true;
    try {
      final response = await ApiService.getPrediction(data);
      latestResult.value = response['result'];
      confidenceScore.value = response['confidence'];
      modelBreakdown.value = response['breakdown'];

      Get.toNamed('/result');
    } finally {
      isPredicting.value = false;
    }
  }
}
