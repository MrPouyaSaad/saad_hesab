// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:saad_hesab/add_item/add_item.dart';
import 'package:saad_hesab/consts/logo.dart';
import 'package:saad_hesab/data/data.dart';
import 'package:saad_hesab/info_screen/info_screen.dart';
import 'package:saad_hesab/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final ThemeData themeData = Theme.of(context);
    final box = Hive.box<TransactionData>(tranactionBoxName);
    final backgroundColor = Colors.grey.shade50;
    double sizeOfContainer = 69;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ValueListenableBuilder<Box<TransactionData>>(
        valueListenable: box.listenable(),
        builder: (context, value, child) {
          if (box.isEmpty) {
            return Scaffold(
              backgroundColor: backgroundColor,
              //! ─── Appbar ──────────
              appBar: AppBar(
                backgroundColor: const Color(0xFF004D40),
                elevation: 0.0,
                title: Image.asset(
                  logoPath,
                  height: 56,
                ),
                centerTitle: true,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('تراکنشی وجود ندارد !'),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: ElevatedButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.greenAccent[700]),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  AddScreen(transactionData: TransactionData()),
                            ),
                          );
                        },
                        label: const Text(
                          'افزودن',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).marginOnly(top: 8, bottom: 8, right: 32),
                        icon: const Icon(Icons.add)
                            .marginOnly(top: 8, bottom: 8, left: 32),
                      ).marginOnly(top: 32),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: backgroundColor,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          AddScreen(transactionData: TransactionData()),
                    ),
                  );
                },
                backgroundColor: Colors.orangeAccent[400],
                label: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'افزودن تراکنش',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(Icons.add),
                  ],
                ).marginOnly(left: 32, right: 32),
              ),
              //! AppBar -------------------------------
              appBar: AppBar(
                backgroundColor: const Color(0xFF004D40),
                elevation: 0.0,
                title: Image.asset(
                  logoPath,
                  height: 56,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) {
                          return InfoScreen(
                            box: box,
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                ),
                actions: [
                  DeleteAll(box: box),
                ],
              ),
              body: ListView.builder(
                padding: const EdgeInsets.only(bottom: 64),
                reverse: false,
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  final TransactionData transaction =
                      box.values.toList()[index];
                  double borderRadius = 32;
                  //! HOME SCREEN ITEM ---------------------------------
                  return InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(borderRadius),
                            topLeft: Radius.circular(borderRadius),
                          ),
                        ),
                        useSafeArea: true,
                        builder: (context) => Container(
                          height: 124,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(borderRadius),
                              topLeft: Radius.circular(borderRadius),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: BottomSheetItem(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddScreen(
                                          transactionData: transaction,
                                        ),
                                      ),
                                    );
                                  },
                                  borderRadius: borderRadius,
                                  title: 'ویرایش',
                                  icon: CupertinoIcons.pen,
                                ),
                              ),
                              Expanded(
                                child: BottomSheetItem(
                                  onTap: () {
                                    Navigator.pop(context);
                                    transaction.delete();
                                  },
                                  borderRadius: borderRadius,
                                  title: 'حذف',
                                  icon: CupertinoIcons.delete,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: HomeScreenItem(
                        sizeOfContainer: sizeOfContainer,
                        transaction: transaction),
                  ).marginOnly(bottom: 8, left: 16, right: 16, top: 16);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class DeleteAll extends StatelessWidget {
  const DeleteAll({
    super.key,
    required this.box,
  });

  final Box<TransactionData> box;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              alignment: Alignment.center,
              title: const Text(
                'حذف همه',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: const Text(
                'همه تراکنش ها برای همیشه حذف خواهند شد، مطمئن هستید؟',
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () {
                    box.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'بله',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent[700]),
                  ).marginOnly(left: 32.0, right: 32.0, top: 16, bottom: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'خیر',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ).marginOnly(left: 32.0, right: 32.0, top: 16, bottom: 16),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(
        CupertinoIcons.delete,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

class HomeScreenItem extends StatelessWidget {
  const HomeScreenItem({
    super.key,
    required this.sizeOfContainer,
    required this.transaction,
  });

  final double sizeOfContainer;
  final TransactionData transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: sizeOfContainer,
      // margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16, top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 9,
          ),
        ],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      transaction.date,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${transaction.price} تومان',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ).marginOnly(left: 16, right: 16, top: 8, bottom: 8),
          ),
          Container(
            height: sizeOfContainer,
            width: sizeOfContainer,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: transaction.isDeposit
                  ? Colors.greenAccent[700]
                  : Colors.redAccent[700],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              transaction.isDeposit ? CupertinoIcons.add : CupertinoIcons.minus,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetItem extends StatelessWidget {
  const BottomSheetItem({
    Key? key,
    required this.title,
    required this.onTap,
    required this.icon,
    required this.borderRadius,
  }) : super(key: key);
  final String title;
  final Function() onTap;
  final IconData icon;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ).marginOnly(top: 16, bottom: 16, right: 16, left: 16),
        ],
      ),
    );
  }
}
