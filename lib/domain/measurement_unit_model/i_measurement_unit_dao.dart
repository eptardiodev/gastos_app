import 'package:gastos_app/domain/measurement_unit_model/measurement_unit_model.dart';

abstract class IMeasurementUnitDao {

  Future<List<MeasurementUnitModel>> getAllMeasurementUnits();
}
