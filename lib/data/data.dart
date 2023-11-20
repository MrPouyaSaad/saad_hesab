import 'package:hive/hive.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class TransactionData extends HiveObject {
  @HiveField(0)
  String price = '';

  @HiveField(1)
  String title = '';

  @HiveField(2)
  bool isDeposit = false;

  @HiveField(3)
  String date = '';
}
