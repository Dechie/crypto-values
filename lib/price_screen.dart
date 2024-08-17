import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';
import 'constants.dart';
import 'services.dart';
import 'show_result.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";
  int toBtc = 0, toEth = 0, toLtc = 0;
  List<double> conversionResults = List.generate(3, (i) => 0.0);
  List<Map<String, dynamic>> allData = [];
  // [{} btc, {} eth, {} ltc]
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: isLoading
                ? showCircularProgress()
                : ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) => ShowResult(
                      child: Text(
                          textAlign: TextAlign.center,
                          style: resultTextStyle,
                          "1 ${cryptoList[index]} = ${conversionResults[index]} $selectedCurrency"),
                    ),
                  ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            //child: dropDownAndroid(),
            child: Platform.isIOS ? cupertinoPicker() : dropDownAndroid(),
            //child: cupertinoPicker(),
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
        fetchSpecificValues();
      },
      children: currenciesList
          .map(
            (curr) => Text(
              curr,
              style: const TextStyle(color: commonDropDownBlue),
            ),
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
              child: Text(
                curr,
                style: const TextStyle(
                  color: commonDropDownBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          print(selectedCurrency);
        });
        fetchSpecificValues();
      },
    );
  }

  void fetchConversionValues() async {
    Api api = Api();

    setState(() {
      isLoading = true;
    });
    var results = await api.getConversion();
    allData = results;
    fetchConversionValues();

    setState(() {
      isLoading = false;
    });
  }

  void fetchSpecificValues() {
    String lookupValue = selectedCurrency.toLowerCase();
    for (int i = 0; i < 3; i++) {
      conversionResults[i] = allData[i][lookupValue].toDouble();
      // allData => ['btc': {}, 'eth': {}, 'ltc': {}]
      // allData[0][usd] => btc['usd']
      print("value $i: ${conversionResults[i]}");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchConversionValues();
  }

  Center showCircularProgress() => Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Column(
            children: [
              Text(
                "Fetching Conversion Values",
                style: resultTextStyle.copyWith(
                  color: Colors.lightBlue,
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.lightBlue),
            ],
          ),
        ),
      );
}
