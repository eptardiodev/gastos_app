import 'package:flutter/material.dart';
import 'package:gastos_app/base/bloc_state.dart';
import 'package:gastos_app/base/navigation_utils.dart';
import 'package:gastos_app/domain/expense/expense_model.dart';
import 'package:gastos_app/ui/create_expense/create_expense_bloc.dart';
import 'package:gastos_app/ui/tx_widgets/tx_main_app_bar_widget.dart';
import 'package:intl/intl.dart';


class CreateExpenseWidget extends StatefulWidget {

  final ExpenseModel? expense;

  CreateExpenseWidget({
    this.expense,
    super.key,
  });

  @override
  State<CreateExpenseWidget> createState() => _CreateExpenseWidgetState();
}


final productController = TextEditingController();
final priceController = TextEditingController();
final amountController = TextEditingController();

List<String> uMedidas = ["Kg","Lb","Paquetes","Maso"];
String? unidadSelected;
ExpenseModel newExpense = ExpenseModel();

final List<DropdownMenuItem<String>> dropDownMenuItems = uMedidas
    .map(
      (String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  ),
)
    .toList();

class _CreateExpenseWidgetState
    extends StateWithBloC<CreateExpenseWidget, CreateExpenseBloc> {

  @override
  void initState() {
    super.initState();
    newExpense = widget.expense!;
    productController.text = widget.expense!.product!;
  }

  @override
  void dispose() {
    super.dispose();

    productController.clear();
    priceController.clear();
    amountController.clear();

  }

  @override
  Widget buildWidget(BuildContext context) {
    DateTime date = widget.expense!.date ?? DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy  hh:mm a').format(date);
    //String format = "${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute}";

    return WillPopScope(
      onWillPop: () async {
        NavigationUtils.pop(context, result: widget.expense);
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
                  child: Text("Date: ${formattedDate}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),),
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
                      onChanged: (value){
                        widget.expense!.product = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Expense Product',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        )
                      ),
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Amount Spent',
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          )
                      ),
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          suffixIcon: DropdownButton(
                              items: dropDownMenuItems,
                              value: unidadSelected,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() => unidadSelected = newValue);
                                }
                              }
                          ),
                          labelText: 'Product Quantity',
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          )
                      ),
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
