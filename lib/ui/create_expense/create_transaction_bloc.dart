import 'package:gastos_app/base/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gastos_app/base/bloc_base.dart';
import '../../base/loading_handler.dart';

class CreateTransactionBloc extends BaseBloC with LoadingHandler, ErrorHandler {

  CreateTransactionBloc();

  @override
  void dispose() {
  }
}
