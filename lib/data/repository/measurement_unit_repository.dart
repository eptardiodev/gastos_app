import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/data/repository/base_repository.dart';
import 'package:gastos_app/domain/measurement_unit_model/i_measurement_unit_dao.dart';
import 'package:gastos_app/domain/measurement_unit_model/i_measurement_unit_repository.dart';
import 'package:gastos_app/domain/measurement_unit_model/measurement_unit_model.dart';
import 'package:gastos_app/utils/logger.dart';

class MeasurementUnitRepository extends BaseRepository implements IMeasurementUnitRepository {
  final Logger _logger;
  final IMeasurementUnitDao _measurementUnitDao;

  MeasurementUnitRepository(
      this._logger,
      this._measurementUnitDao,
      );

  @override
  Future<Result<List<MeasurementUnitModel>>> getAllMeasurementUnits() async {
    try {
      final res = await _measurementUnitDao.getAllMeasurementUnits();
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getAllMeasurementUnits: $ex');
      return Result.error(error: ex);
    }
  }
}