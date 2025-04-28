import 'package:gastos_app/app_globals/R.dart';
import 'package:gastos_app/base/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:gastos_app/base/navigation_utils.dart';
import 'package:gastos_app/ui/create_expense/create_expense_page.dart';
import '../../domain/expense/expense_model.dart';
import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends StateWithBloC<HomePage, HomeBloC> {
  List<ExpenseModel> expenseList = [];

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: R.color.primaryColor,
        onPressed: () async {
          ExpenseModel newExpense = ExpenseModel(
              date: DateTime.now(), product: "", price: 0.0, amount: 0);

          final ExpenseModel? res = await NavigationUtils.push(
              context,
              CreateExpenseWidget(
                expense: newExpense,
              ));
          if (res != null && (res.product ?? "").isNotEmpty) {
            setState(() {
              expenseList.add(res);
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            Icons.add,
            color: R.color.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.only(left: 20, right: 12),
              title: Text(
                R.string.products,
                style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20,
                  color: R.color.grayDarkestColor
                ),
              ),
              trailing: Text(
                R.string.price,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20,
                    color: R.color.grayDarkestColor
                ),
              ),
            ),
            Divider(),
            SingleChildScrollView(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: expenseList.length,
                  itemBuilder: (context, index) {
                    final ExpenseModel expense = expenseList[index];
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(index.toString()),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.only(left: 10, right: 25),
                            title: Text(expense.product ?? ""),
                            trailing: Text("\$${expense.price}"),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Gastos",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: R.color.primaryColor,
      ),
      drawer: Drawer(),
    );
  }
}
