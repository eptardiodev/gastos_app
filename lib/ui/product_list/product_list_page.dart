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
  final List<TransactionModel>? transactionList;

  const ProductListPage({super.key,
    this.transactionList,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends StateWithBloC<ProductListPage, ProductListBloC> {


  @override
  void initState() {
    super.initState();
    bloc.init(/*widget.transactionList!.first.date ??*/ DateTime.now());
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
              date: DateTime.now(),
              userId: "12",
              amount: 0
          ));


          final AllTransactionDataModel? res = await NavigationUtils.push(context,
              AddProductPage(
                transaction: newTransaction.transaction,
                categoryList: bloc.categories,
                subcategoryList: bloc.subcategories,
                productList: bloc.products,
              ));
          if (res != null && res.transaction!.productId != null) {
            await bloc.saveTransaction(res);
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
      body: StreamBuilder<List<AllTransactionDataModel>>(
          stream: bloc.transactionListStream,
          initialData: [],
          builder: (context, snapshot) {
            final List<AllTransactionDataModel> transactionList = snapshot.data ?? [];
            return PageView.builder(
              itemCount: transactionList.length,
              itemBuilder: (context, index) {
                final AllTransactionDataModel transaction = transactionList[index];
                return Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  color: Color(0x3586B5FA),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // SingleChildScrollView(
                        //   child: StreamBuilder<List<CategoryModel>>(
                        //     stream: bloc.categoryListStream,
                        //     builder: (context, snapshot) {
                        //       final List<CategoryModel> categoryList = snapshot.data ?? [];
                        //       return ListView.builder(
                        //             physics: const NeverScrollableScrollPhysics(),
                        //             shrinkWrap: true,
                        //             itemCount: categoryList.length,
                        //             itemBuilder: (context, index) {
                        //               final CategoryModel category = categoryList[index];
                        //               return Row(
                        //                 children: [
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left: 5),
                        //                     child: Text(category.name),
                        //                   ),
                        //
                        //                 ],
                        //               );
                        //             });
                        //     }
                        //   ),
                        // ),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Date: ${transaction.transaction!.date.day}/${transaction.transaction!.date.month}/${transaction.transaction!.date!.year}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.only(left: 20, right: 12),
                                title: Text(
                                  R.string.products,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18,
                                      color: R.color.grayDarkestColor
                                  ),
                                ),
                                trailing: Text(
                                  R.string.price,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18,
                                      color: R.color.grayDarkestColor
                                  ),
                                ),
                              ),
                              Divider(),
                              SingleChildScrollView(
                                child: StreamBuilder<List<AllTransactionDataModel>>(
                                    stream: bloc.transactionListStream,
                                    initialData: [],
                                    builder: (context, snapshot) {
                                      final List<AllTransactionDataModel> transactionList = snapshot.data ?? [];
                                      return ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: transactionList.length,
                                          itemBuilder: (context, index) {
                                            final AllTransactionDataModel transaction = transactionList[index];
                                            return Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text((index + 1).toString()),
                                                ),
                                                Expanded(
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets.only(left: 10, right: 25),
                                                    title: Text(transaction.product!.name.toString() ?? ""),
                                                    trailing: Text("\$${transaction.transaction!.amount}"),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },

            );
          }
      ),
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