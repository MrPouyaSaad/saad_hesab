// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:saad_hesab/data/data.dart';

class InfoScreen extends StatelessWidget {
  InfoScreen({
    Key? key,
    required this.box,
  }) : super(key: key);
  final Box<TransactionData> box;
  int cal({required bool isDeposit}) {
    int response = 0;
    if (isDeposit) {
      for (var i = 0; i < box.length; i++) {
        final transaction = box.values.toList()[i];
        if (transaction.isDeposit) {
          response += transaction.price;
        }
      }
      return response;
    } else {
      for (var i = 0; i < box.length; i++) {
        final transaction = box.values.toList()[i];
        if (!transaction.isDeposit) {
          response += transaction.price;
        }
      }
      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int res = cal(isDeposit: true) - cal(isDeposit: false);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'گزارش',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CalWidget(
                price: cal(isDeposit: true).toString(),
                title: 'واریز',
                color: Colors.greenAccent,
              ),
              CalWidget(
                  color: Colors.redAccent,
                  price: cal(isDeposit: false).toString(),
                  title: 'برداشت'),
              CalWidget(
                  color: res > 0
                      ? Colors.greenAccent
                      : res == 0
                          ? Colors.grey
                          : Colors.redAccent,
                  price: res.toString(),
                  title: 'کل'),
            ],
          ),
        ),
      ),
    );
  }
}

class CalWidget extends StatelessWidget {
  const CalWidget({
    Key? key,
    required this.title,
    required this.price,
    required this.color,
  }) : super(key: key);
  final String title;
  final String price;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Row(
        children: [
          Text(
            '$title :',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            price,
            textDirection: TextDirection.ltr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 6),
          const Text(
            'تومان',
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ).marginSymmetric(vertical: 24, horizontal: 24),
    ).marginSymmetric(vertical: 8, horizontal: 16);
  }
}
