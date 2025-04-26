import 'package:flutter/material.dart';
import 'package:gastos_app/base/bloc_state.dart';
import 'package:gastos_app/ui/create_expense/create_expense_bloc.dart';
import 'package:gastos_app/ui/tx_widgets/tx_main_app_bar_widget.dart';
import 'package:intl/intl.dart';


class CreateExpenseWidget extends StatefulWidget {
  const CreateExpenseWidget({super.key});

  @override
  State<CreateExpenseWidget> createState() => _CreateExpenseWidgetState();
}


List<String> uMedidas = ["Kg","Lb","Paquetes","Maso"];
String? unidadSelected;

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
  Widget buildWidget(BuildContext context) {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy  hh:mm a').format(date);
    //String format = "${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute}";

    return TXMainAppBarWidget(
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
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.send_outlined)),
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
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.send_outlined)),
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
    );
  }
}
