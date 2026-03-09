import 'package:flutter/material.dart';

class Price extends StatelessWidget {
  final int price;
  late String priceFormatted;

  Price({required this.price}) {
    int dollars = price ~/ 100;
    int cents = price % 100;
    priceFormatted = "\$$dollars.$cents";
  }

  @override
  Widget build(BuildContext context) {
    return Text(priceFormatted);
  }
}
