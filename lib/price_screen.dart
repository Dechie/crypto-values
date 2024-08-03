import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';
import 'services.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD", toBtc = "first";
  double toEth = 0, toLtc = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  //'1 BTC = $toBtc USD',
                  toBtc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            //child: dropDownAndroid(),
            //child: Platform.isIOS ? cupertinoPicker() : dropDownAndroid(),
            child: cupertinoPicker(),
          ),
        ],
      ),
    );
  }

  CupertinoPicker cupertinoPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        fetchConversionValues();
      },
      children: currenciesList
          .map(
            (curr) => Text(curr),
          )
          .toList(),
    );
  }

  DropdownButton<String> dropDownAndroid() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currenciesList
          .map<DropdownMenuItem<String>>(
            (curr) => DropdownMenuItem(
              value: curr,
              child: Text(curr),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });

        fetchConversionValues();
      },
    );
  }

  void fetchConversionValues() async {
    Api api = Api();
    String finalValue =
        await api.getConversion(crypto: "BTC", fiat: selectedCurrency);
    setState(() {
      toBtc = finalValue;
    });
    print(toBtc);
  }
}
