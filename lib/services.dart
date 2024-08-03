import 'package:dio/dio.dart';

class Api {
  Future<String> getConversion({
    required String crypto,
    required String fiat,
  }) async {
    Dio dio = Dio();
    Response response;
    double finalRes = double.infinity;
    String finalResult = "noResponse";
    var url =
        "https://apiv2.bitcoinaverage.com/indices/global/ticker/$crypto$fiat";
    await Future.delayed(const Duration(seconds: 2));
    finalResult = "$crypto->$fiat";

    // try {
    //   response = await dio.get(url);

    //   if (response.statusCode == 200) {
    //     var data = response.data;
    //     finalResult = data['last'];
    //   }
    // } catch (e) {
    //   print(e.toString());
    // }
    return finalResult;
    //return finalRes;
  }
}
