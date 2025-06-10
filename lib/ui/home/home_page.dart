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

  @override
  void initState(){
    super.initState();
    bloc.init();
  }


  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: R.color.primaryColor,
        onPressed: () async {


          final TransactionModel? res = await NavigationUtils.push(context,
            ProductListPage(
              date: DateTime(2025,6,7) ?? DateTime.now(),
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
      body: Container(),
      // body: StreamBuilder<List<AllTransactionDataModel>>(
      //     stream: bloc.transactionListStream,
      //     initialData: [],
      //     builder: (context, snapshot) {
      //       final List<AllTransactionDataModel> transactionList = snapshot.data ?? [];
      //     return PageView.builder(
      //       itemCount: transactionList.length,
      //       itemBuilder: (context, index) {
      //         final AllTransactionDataModel transaction = transactionList[index];
      //         return Container(
      //           padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      //           color: Color(0x3586B5FA),
      //           child: SingleChildScrollView(
      //             child: Column(
      //               children: [
      //                 // SingleChildScrollView(
      //                 //   child: StreamBuilder<List<CategoryModel>>(
      //                 //     stream: bloc.categoryListStream,
      //                 //     builder: (context, snapshot) {
      //                 //       final List<CategoryModel> categoryList = snapshot.data ?? [];
      //                 //       return ListView.builder(
      //                 //             physics: const NeverScrollableScrollPhysics(),
      //                 //             shrinkWrap: true,
      //                 //             itemCount: categoryList.length,
      //                 //             itemBuilder: (context, index) {
      //                 //               final CategoryModel category = categoryList[index];
      //                 //               return Row(
      //                 //                 children: [
      //                 //                   Padding(
      //                 //                     padding: const EdgeInsets.only(left: 5),
      //                 //                     child: Text(category.name),
      //                 //                   ),
      //                 //
      //                 //                 ],
      //                 //               );
      //                 //             });
      //                 //     }
      //                 //   ),
      //                 // ),
      //                 Row(mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Text("Date: ${transaction.transaction!.date.day}/${transaction.transaction!.date!.month}/${transaction.transaction!.date!.year}",
      //                       style: TextStyle(
      //                         fontWeight: FontWeight.bold,
      //                         fontSize: 20
      //                       ),
      //                     )
      //                   ],
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(10.0),
      //                   child: Column(
      //                     children: [
      //                       ListTile(
      //                         dense: true,
      //                         contentPadding: EdgeInsets.only(left: 20, right: 12),
      //                         title: Text(
      //                           R.string.products,
      //                           style: TextStyle(
      //                               fontWeight: FontWeight.bold, fontSize: 18,
      //                               color: R.color.grayDarkestColor
      //                           ),
      //                         ),
      //                         trailing: Text(
      //                           R.string.price,
      //                           style: TextStyle(
      //                               fontWeight: FontWeight.bold, fontSize: 18,
      //                               color: R.color.grayDarkestColor
      //                           ),
      //                         ),
      //                       ),
      //                       Divider(),
      //                       SingleChildScrollView(
      //                         child: StreamBuilder<List<AllTransactionDataModel>>(
      //                             stream: bloc.transactionListStream,
      //                             initialData: [],
      //                             builder: (context, snapshot) {
      //                               final List<AllTransactionDataModel> transactionList = snapshot.data ?? [];
      //                               return ListView.builder(
      //                                   physics: const NeverScrollableScrollPhysics(),
      //                                   shrinkWrap: true,
      //                                   itemCount: transactionList.length,
      //                                   itemBuilder: (context, index) {
      //                                     final AllTransactionDataModel transaction = transactionList[index];
      //                                     return Row(
      //                                       children: [
      //                                         Padding(
      //                                           padding: const EdgeInsets.only(left: 5),
      //                                           child: Text((index + 1).toString()),
      //                                         ),
      //                                         Expanded(
      //                                           child: ListTile(
      //                                             contentPadding: EdgeInsets.only(left: 10, right: 25),
      //                                             title: Text(transaction.product!.name.toString() ?? ""),
      //                                             trailing: Text("\$${transaction.transaction!.amount}"),
      //                                           ),
      //                                         ),
      //                                       ],
      //                                     );
      //                                   });
      //                             }
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         );
      //       },
      //
      //     );
      //   }
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          R.string.expenses,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: R.color.primaryColor,
      ),
      drawer: Drawer(),
    );
  }
}
