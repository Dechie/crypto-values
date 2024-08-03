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
  String selectedCurrency = "USD", toBtc = "first";
  String toLtc = "second", toEth = "third";
  //double toEth = 0, toLtc = 0;
  bool btcIsLoading = false, ethIsLoading = false, ltcIsLoading = false;

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
          ShowResult(
            child: btcIsLoading
                ? showCircularProgress()
                : Text(
                    //toBtc,
                    "1 BTC = ? $selectedCurrency",
                    textAlign: TextAlign.center,
                    style: resultTextStyle,
                  ),
          ),
          ShowResult(
            child: ethIsLoading
                ? showCircularProgress()
                : Text(
                    //toEth,
                    "1 ETH = ? $selectedCurrency",
                    textAlign: TextAlign.center,
                    style: resultTextStyle,
                  ),
          ),
          ShowResult(
            child: ltcIsLoading
                ? showCircularProgress()
                : Text(
                    //toLtc,
                    "1 LTC = ? $selectedCurrency",
                    textAlign: TextAlign.center,
                    style: resultTextStyle,
                  ),
          ),
          const Spacer(),
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
        fetchConversionValues();
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
        });

        fetchConversionValues();
      },
    );
  }

  void fetchConversionValues() async {
    Api api = Api();
    btcIsLoading = true;
    ethIsLoading = true;
    ltcIsLoading = true;
    String finalValue1 =
        await api.getConversion(crypto: "BTC", fiat: selectedCurrency);
    setState(() {
      btcIsLoading = false;
      toBtc = finalValue1;
    });

    String finalValue2 =
        await api.getConversion(crypto: "ETH", fiat: selectedCurrency);
    setState(() {
      ethIsLoading = false;
      toEth = finalValue2;
    });

    String finalValue3 =
        await api.getConversion(crypto: "LTC", fiat: selectedCurrency);
    setState(() {
      ltcIsLoading = false;
      toLtc = finalValue3;
    });

    print(toBtc);
  }

  Center showCircularProgress() => const Center(
        child: CircularProgressIndicator(color: commonDarkBlue),
      );
}
