import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/domain/measurement_unit_model/i_measurement_unit_dao.dart';
import 'package:gastos_app/domain/measurement_unit_model/measurement_unit_model.dart';
import 'package:sqflite/sqflite.dart';


class MeasurementUnitDao implements IMeasurementUnitDao {
  final AppDatabase _appDatabase;

  MeasurementUnitDao(this._appDatabase);

  Future<List<MeasurementUnitModel>> getAllMeasurementUnits() async {
    Database db = await _appDatabase.db;
    final maps = await db.query('measurement_units');
    return List.generate(maps.length, (i) => MeasurementUnitModel.fromMap(maps[i]));
  }

}
