import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:gastos_app/app_globals/R.dart';
import 'package:gastos_app/base/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:gastos_app/base/navigation_utils.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';
import 'package:gastos_app/ui/create_expense/create_transaction_page.dart';
import 'package:gastos_app/ui/product_list/product_list_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../domain/expense/expense_model.dart';
import '../add_product/add_product_page.dart';
import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends StateWithBloC<HomePage, HomeBloC> {

  DateTime _focusDate = DateTime.now();
  @override
  void initState(){
    super.initState();
    bloc.init();
  }


  @override
  Widget buildWidget(BuildContext context) {
    String today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: R.color.primaryColor,
        onPressed: () async {

          List<TransactionModel> transactionList = [];

          final TransactionModel? res = await NavigationUtils.push(context,
            ProductListPage(
              transactionList: transactionList ?? [],
          ));
          if (res != null && res.productId != null) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text("${R.string.hi} Eduardo",
                    style: GoogleFonts.alkatra(fontSize: 35),
                  ),
                  subtitle: Text(today,
                    style: GoogleFonts.alkatra(fontSize: 18),
                  ),
                  trailing: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.person,
                      size: 50,
                    )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: EasyInfiniteDateTimeLine(
                  selectionMode: const SelectionMode.autoCenter(),
        firstDate: DateTime(2024),
        focusDate: _focusDate,
        lastDate: DateTime(2024, 12, 31),
        onDateChange: (selectedDate) {
          setState(() {
            _focusDate = selectedDate;
          });
        },
        dayProps: const EasyDayProps(
          // You must specify the width in this case.
          width: 64.0,
          // The height is not required in this case.
          height: 64.0,
        ),
        itemBuilder: (
            BuildContext context,
            DateTime date,
            bool isSelected,
            VoidCallback onTap,
            ) {
          return InkResponse(
            // You can use `InkResponse` to make your widget clickable.
            // The `onTap` callback responsible for triggering the `onDateChange`
            // callback and animating to the selected date if the `selectionMode` is
            // SelectionMode.autoCenter() or SelectionMode.alwaysFirst().
            onTap: onTap,
            child: CircleAvatar(
              // use `isSelected` to specify whether the widget is selected or not.
              backgroundColor:
              isSelected ? Colors.red : Colors.red,
              radius: 32.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      EasyDateFormatter.shortDayName(date, "en_US"),
                      style: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
              )
            ],
          ),
        ),
      ),

      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   title: Text(
      //     R.string.expenses,
      //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: R.color.primaryColor,
      // ),
      drawer: Drawer(),
    );
  }
}

String getGreetings(){
  String greeting = '';
  int hour = DateTime.now().hour;
  if(hour <= 12){
    greeting = 'Good Morning';
  } else if(hour > 12 && hour <= 6){
    greeting = 'Good Afternoon';
  } else if(hour > 6){
    greeting = 'Good Evening';
  }
  return greeting;
}
