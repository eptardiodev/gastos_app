import 'package:flutter/material.dart';
import 'package:gastos_app/base/bloc_state.dart';
import 'package:gastos_app/base/navigation_utils.dart';
import 'package:gastos_app/domain/expense/expense_model.dart';
import 'package:gastos_app/ui/create_expense/create_expense_bloc.dart';
import 'package:gastos_app/ui/tx_widgets/tx_main_app_bar_widget.dart';
import 'package:intl/intl.dart';

class CreateExpenseWidget extends StatefulWidget {
  final ExpenseModel? expense;

  const CreateExpenseWidget({
    this.expense,
    super.key,
  });

  @override
  State<CreateExpenseWidget> createState() => _CreateExpenseWidgetState();
}

class _CreateExpenseWidgetState
    extends StateWithBloC<CreateExpenseWidget, CreateExpenseBloc> {

  final productController = TextEditingController();
  final priceController = TextEditingController();
  final amountController = TextEditingController();

  final List<String> uMedidas = ["Kg", "Lb", "Paquetes", "Maso"];
  String? unidadSelected;

  late final List<DropdownMenuItem<String>> dropDownMenuItems;
  late ExpenseModel newExpense;


  @override
  void initState() {
    super.initState();
    newExpense = widget.expense ?? ExpenseModel(date: DateTime.now());
    productController.text = widget.expense?.product ?? '';

    /// aqui se genera una lista de DropdownMenuItem por cada valor de la lista
    /// de medidas. (borrar este comentario)
    dropDownMenuItems = uMedidas.map(
      (String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      ),
    ).toList();
  }

  @override
  void dispose() {
    super.dispose();
    productController.dispose();
    priceController.dispose();
    amountController.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    DateTime date = newExpense.date ?? DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy  hh:mm a').format(date);


    return WillPopScope(
      onWillPop: () async {
        NavigationUtils.pop(context, result: newExpense);
        return false;
      },
      child: TXMainAppBarWidget(
        title: 'Create Expense',
        centeredTitle: true,
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.calendar_today,
                    size: 22,
                    color: Colors.blue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    /// aqui la interpolacion no es necesaria el uso de {}
                    /// por ejemplo:
                    /// "Date: ${hoy}" es igual que poner "Date: $hoy"
                    /// porque es una sola palabra, pero cuando es de este otro
                    /// tipo si tienes que acotar entre {}
                    /// "Date: ${hoy.name}" o "Costo: ${price.toString()}"
                    "Date: $formattedDate",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.add_circle,
                    size: 22,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: productController,
                      onChanged: (value) {
                        newExpense.product = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Expense Product',
                          border: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.monetization_on_sharp,
                    size: 22,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: priceController,
                      onChanged: (value) {
                        try{
                          /// esto convierte a los valores
                          /// estudiate el uso de parse y tryParse
                          /// la diferencia es que parse solo convierte valores
                          /// que sean validos porque lo que hay que tener cuidado
                          /// y devuelve no nulos. o sea no puede fallar. por eso
                          /// lo encierra en un try catch para si hay error que ejecute el cath y no
                          /// rompa la app.
                          /// sin embargo el tryParse devuleve un null si no se pudo
                          /// convertir
                          /// ejemplo
                          /// double? doublePrice = double.tryParse(value);
                          /// y ahi luego if(doubleParse != null){
                          /// bla bla
                          /// }
                          double doublePrice = double.parse(value);
                          newExpense.price = doublePrice;
                        } catch (e){
                          // Manejo de errores en caso de que la entrada no sea un número válido.
                          print("Error al convertir a double: $e"); //O mostrar un SnackBar o Dialog
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Amount Spent',
                          border: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.shopping_bag,
                    size: 22,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: amountController,
                      onChanged: (value) {
                        try{
                          int intAmount = int.parse(value);
                          newExpense.amount = intAmount;
                        } catch (e){
                          // Manejo de errores para el parseo de int
                          print("Error al convertir a int: $e"); // Mostrar un mensaje de error
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          suffixIcon: DropdownButton(
                              items: dropDownMenuItems,
                              value: unidadSelected,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() => unidadSelected = newValue);
                                }
                              }),
                          labelText: 'Product Quantity',
                          border: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
