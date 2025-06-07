import 'dart:core';

import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/measurement_unit_model/measurement_unit_model.dart';


abstract class IMeasurementUnitRepository {
  Future<Result<List<MeasurementUnitModel>>> getAllMeasurementUnits();
}