// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import 'package:saad_hesab/data/data.dart';
import 'package:saad_hesab/main.dart';

// ignore: must_be_immutable

class AddScreen extends StatefulWidget {
  const AddScreen({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  final TransactionData transactionData;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late int groupValue = widget.transactionData.isDeposit ? 1 : 0;
  bool isAutoDate = true;
  void onTapWithdraw() {
    setState(() {
      groupValue = 0;
    });
  }

  void onTapWDeposit() {
    setState(() {
      groupValue = 1;
    });
  }

  void pickDate() async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1402, 1),
      lastDate: Jalali.now(),
    );

    _dateController.text =
        '${picked!.formatter.d} ${picked.formatter.mN}  ,${picked.formatter.yyyy}';
  }

  late final TextEditingController _priceController = TextEditingController(
      text: widget.transactionData.price == 0
          ? ''
          : widget.transactionData.price.toString());
  late final TextEditingController _titleController =
      TextEditingController(text: widget.transactionData.title);
  late final TextEditingController _dateController =
      TextEditingController(text: widget.transactionData.date);
  late bool isDeposit = widget.transactionData.isDeposit;

  bool isError = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,

        //! floataction button
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004D40),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36.0),
              ),
            ),
            onPressed: () async {
              if (_titleController.text.isNotEmpty &&
                  _priceController.text.isNotEmpty) {
                widget.transactionData.title = _titleController.text;
                widget.transactionData.price = int.parse(_priceController.text);
                widget.transactionData.isDeposit = groupValue == 1;
                widget.transactionData.date = _dateController.text.isEmpty
                    ? Jalali.now().formatShortDate().toString()
                    : _dateController.text;

                if (widget.transactionData.isInBox) {
                  widget.transactionData.save();
                  Navigator.pop(context);
                } else {
                  final Box<TransactionData> box =
                      await Hive.openBox(tranactionBoxName);
                  box.add(widget.transactionData);
                  Navigator.pop(context);
                }
              } else {
                setState(() {
                  isError = true;
                });
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('افزودن'),
                SizedBox(width: 8),
                Icon(Icons.check),
              ],
            ),
          ),
        ).marginOnly(left: 16, right: 16),
        //! AppbBar
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent[400],
          foregroundColor: Colors.white,
          title: const Text(
            'افزودن تراکنش',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          elevation: 0.0,
          leading: const BackButton(),
        ),
        body: Column(
          children: [
            AddScreenTextFields(
              isError: isError,
              title: 'عنوان',
              controller: _titleController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.text,
            ),
            AddScreenTextFields(
              isError: isError,
              title: 'مبلغ',
              controller: _priceController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.number,
            ),
            Visibility(
              visible: !isAutoDate,
              child: Row(
                children: [
                  Expanded(
                    child: AddScreenTextFields(
                      onTap: pickDate,
                      isError: false,
                      title: 'تاریخ',
                      controller: _dateController,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      enable: false,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: pickDate,
                    borderRadius: BorderRadius.circular(36.0),
                    child: Icon(
                      Icons.edit_calendar_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: onTapWithdraw,
                  child: Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = 0;
                          });
                        },
                      ),
                      const Text('برداشت'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    onTapWDeposit();
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = 1;
                          });
                        },
                      ),
                      const Text('واریز'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isAutoDate,
                      onChanged: (value) async {
                        setState(() {
                          isAutoDate = !isAutoDate;
                        });

                        if (!isAutoDate) {
                          pickDate();
                        } else {
                          _dateController.text =
                              Jalali.now().formatShortDate().toString();
                        }
                      },
                    ),
                    const Text('تاریخ خودکار')
                  ],
                ).marginOnly(left: 16)
              ],
            ).marginOnly(bottom: 16, top: 16),
          ],
        ).paddingAll(16.0),
      ),
    );
  }
}

class AddScreenTextFields extends StatelessWidget {
  const AddScreenTextFields({
    Key? key,
    required this.title,
    required this.textInputType,
    required this.controller,
    required this.textInputAction,
    this.enable = true,
    required this.isError,
    this.onTap,
  }) : super(key: key);
  final String title;
  final TextInputType textInputType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final bool enable;
  final bool isError;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      controller: controller,
      enableSuggestions: true,
      textInputAction: textInputAction,
      onTap: onTap,
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        enabled: enable,
        errorText: isError ? 'خالی!' : null,
        errorBorder: isError
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    BorderSide(color: Colors.redAccent.shade700, width: 1),
              )
            : null,
        focusedErrorBorder: isError
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    BorderSide(color: Colors.redAccent.shade700, width: 1),
              )
            : null,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.teal.shade200, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.teal.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.teal.shade900, width: 1),
        ),
        fillColor: Colors.white,
        label: Text(title),
      ),
    ).marginOnly(bottom: 16, top: 16);
  }
}
