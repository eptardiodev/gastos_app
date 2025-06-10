import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastos_app/app_globals/R.dart';
import 'package:gastos_app/base/bloc_state.dart';
import 'package:gastos_app/base/navigation_utils.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';
import 'package:gastos_app/ui/add_product/add_product_page.dart';
import 'package:gastos_app/ui/product_list/product_list_bloc.dart';
import 'package:intl/intl.dart';

class ProductListPage extends StatefulWidget {
  // final List<TransactionModel>? transactionList;
  final DateTime? date;

  const ProductListPage({
    super.key,
    // this.transactionList,
    this.date,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState
    extends StateWithBloC<ProductListPage, ProductListBloC> {
  @override
  void initState() {
    super.initState();
    bloc.init(widget.date!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: R.color.primaryColor,
        onPressed: () async {
          AllTransactionDataModel newTransaction = AllTransactionDataModel(
              transaction: TransactionModel(
                  date: widget.date!, userId: "12", amount: 0));

          final TransactionModel? res = await NavigationUtils.push(
              context,
              AddProductPage(
                transaction: newTransaction.transaction,
                categoryList: bloc.categories,
                subcategoryList: bloc.subcategories,
                productList: bloc.products,
              ));
          if (res != null && res.productId != null) {
            newTransaction.transaction = res;
            await bloc.saveTransaction(newTransaction);
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
      body: SingleChildScrollView(
          child: StreamBuilder<List<AllTransactionDataModel>>(
              stream: bloc.transactionListStream,
              initialData: [],
              builder: (context, snapshot) {
                final List<AllTransactionDataModel> transactionList =
                    snapshot.data ?? [];
                return Column(
                  children: [
                    transactionList.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Date: ${transactionList.first.transaction!.date.day}/${transactionList.first.transaction!.date.month}/${transactionList.first.transaction!.date!.year}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                        )
                      : Container(),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              contentPadding:
                                  EdgeInsets.only(left: 20, right: 12),
                              title: Text(
                                R.string.products,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: R.color.grayDarkestColor),
                              ),
                              trailing: Text(
                                R.string.price,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: R.color.grayDarkestColor),
                              ),
                            ),
                            Divider(),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: transactionList.length,
                                itemBuilder: (context, index) {
                                  final AllTransactionDataModel transaction =
                                      transactionList[index];
                                  return Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text((index + 1).toString()),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.only(
                                              left: 10, right: 25),
                                          title: Text(transaction.product!.name
                                                  .toString() ??
                                              ""),
                                          trailing: Text(
                                              "\$${transaction.transaction!.amount}"),
                                        ),
                                      ),
                                    ],
                                  );
                                })
                          ],
                        ))
                  ],
                );
              })),
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
