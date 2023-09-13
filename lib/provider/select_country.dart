import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/Screens/utils/widgets.dart';
import 'package:flutterwhatsappclone/provider/countries.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'country.dart';

class SelectCountry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final countriesProvider = Provider.of<CountryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Search your country'.tr,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50.0),
          child:
              SearchCountryTF(controller: countriesProvider.searchController),
        ),
      ),
      body: ListView.builder(
        itemCount: countriesProvider.searchResults.length,
        itemBuilder: (BuildContext context, int i) {
          return SelectableWidget(
            country: countriesProvider.searchResults[i],
            selectThisCountry: (Country c) {
              print(i);
              countriesProvider.selectedCountry = c;
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
