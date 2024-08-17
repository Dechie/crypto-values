import 'package:dio/dio.dart';

class Api {
  Future<List<Map<String, dynamic>>> getConversion() async {
    Dio dio = Dio();
    Response response;
    double finalRes = double.infinity;
    String finalResult = "noResponse";
    List<Map<String, dynamic>> results = [];
    var url =
        "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,litecoin&vs_currencies=AUD,BRL,CAD,CNY,EUR,GBP,HKD,IDR,ILS,INR,JPY,MXN,NOK,NZD,PLN,RON,RUB,SEK,SGD,USD,ZAR";
    //await Future.delayed(const Duration(seconds: 2));
    //finalResult = "$crypto->$fiat";
    finalResult = "";

    try {
      response = await dio.get(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        results.add(data['bitcoin']);
        results.add(data['ethereum']);
        results.add(data['litecoin']);
      }
    } catch (e) {
      print(e.toString());
    }
    return results;
    //return finalRes;
  }
}
