import 'package:gastos_app/data/remote/result.dart';

abstract class ICommonRepository{
  Future<Result<bool>> cleanDB();
}