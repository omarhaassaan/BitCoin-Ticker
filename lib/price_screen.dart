import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'services/networking.dart';
import 'coin_data.dart';
import 'customCard.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String chosenValue = currenciesList[0];
  String value = '?';
  List<Widget> list = [];
  void updateList() async {
    list = [];
    for (var i = 0; i < cryptoList.length; i++) {
      dynamic val = await getValue(cryptoList[i], chosenValue);
      setState(() {
        list.add(CustomCard(cryptoList[i], chosenValue, val.toString()));
      });
    }
  }

  Future<String> getValue(String coin, String currency) async {
    String url =
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/${coin}${currency}';
    NetworkingAdapter na = NetworkingAdapter(url);
    dynamic data = await na.getData();
    print(data['display_symbol'].toString() + ':' + data['last'].toString());

    return data['last'].toString();
  }

  @override
  void initState() {
    super.initState();
    updateList();
  }

  Widget getDropdown() {
    if (Platform.isAndroid)
      return DropdownButton<String>(
        dropdownColor: Colors.lightBlueAccent,
        value: chosenValue,
        icon: Icon(Icons.add),
        onChanged: (String newValue) {
          setState(() {
            chosenValue = newValue;
            updateList();
          });
        },
        items: currenciesList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      );

    if (Platform.isIOS)
      return CupertinoPicker(
        itemExtent: 20,
        onSelectedItemChanged: (v) {
          chosenValue = currenciesList[v];
          updateList();
        },
        children: currenciesList.map((e) {
          return Text(e);
        }).toList(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: list,
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlueAccent,
            child: getDropdown(),
          ),
        ],
      ),
    );
  }
}

//
//Padding(
//padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
//child: Card(
//color: Colors.lightBlueAccent,
//elevation: 5,
//shadowColor: Colors.red,
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(10.0),
//),
//child: Padding(
//padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
//child: Text(
//'1 BTC = $value $chosenValue',
//textAlign: TextAlign.center,
//style: TextStyle(
//fontSize: 20.0,
//color: Colors.white,
//),
//),
//),
//),
//),
