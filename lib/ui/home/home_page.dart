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
import 'package:syncfusion_flutter_charts/charts.dart';
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
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
  @override
  void initState() {
    super.initState();
    bloc.init(date: DateTime.now());
  }

  @override
  Widget buildWidget(BuildContext context) {
    String today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton:
      FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          await NavigationUtils.push(
              context,
              ProductListPage(
                // date: DateTime(2025, 6, 7) ?? DateTime.now(),
                date: _focusDate,
              ));
          await bloc.refreshData(_focusDate);
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            Icons.add,
            size: 30,
            color: R.color.primaryColor,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar:
      // ConvexAppBar.badge(
      //   style: TabStyle.reactCircle,
      //   items: <TabItem>[
      //     TabItem(
      //       label: "Home",
      //       icon: Icon(Icons.home,)),
      //     TabItem(
      //       label: "Templates",
      //       icon: Icon(Icons.text_snippet)),
      //     TabItem(
      //       label: "Products",
      //       icon: Icon(Icons.fastfood_rounded)),
      //     TabItem(
      //       label: "Statistics",
      //       icon: Icon(Icons.query_stats)),
      //   ],
      //   onTap: (index) {},
      //
      // ),
      BottomAppBar(
        // shape: CircularNotchedRectan,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: (){}, icon: Icon(Icons.home)),
            IconButton(
                onPressed: (){}, icon: Icon(Icons.text_snippet)),
            IconButton(
                onPressed: (){}, icon: Icon(Icons.fastfood_rounded)),
            IconButton(
                onPressed: (){}, icon: Icon(Icons.query_stats)),
          ],
        ),
      ),
      // BottomNavigationBar(
      //   currentIndex: 0,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         label: "Home",
      //         icon: Icon(Icons.home, color: Colors.black,)),
      //     BottomNavigationBarItem(
      //         label: "Templates",
      //         icon: Icon(Icons.text_snippet, color: Colors.black,)),
      //     BottomNavigationBarItem(
      //         label: "Products",
      //         icon: Icon(Icons.fastfood_rounded, color: Colors.black,)),
      //     BottomNavigationBarItem(
      //         label: "Statistics",
      //         icon: Icon(Icons.query_stats, color: Colors.black,)),
      //   ],
      //   onTap: (value){
      //
      //   },
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                title: Text(
                  "${R.string.hi} Eduardo",
                  style: GoogleFonts.alkatra(fontSize: 35),
                ),
                subtitle: Text(
                  today,
                  style: GoogleFonts.alkatra(fontSize: 18),
                ),
                trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.person,
                      size: 50,
                    )),
              ),

              /// DateTime Line
              buildEasyInfiniteDateTimeLine(),

              /// Graphical weekly resume
              StreamBuilder<List<GraphData>>(
                stream: bloc.weeklySummaryListStream,
                builder: (context, snapshot) {
                  final graphDataList = snapshot.data ?? [];
                  return SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(
                        text: 'Weekly summary',
                        alignment: ChartAlignment.near,
                        textStyle: GoogleFonts.alkatra(fontSize: 17),
                      ),
                      legend: Legend(
                        isVisible: false,
                      ),
                      // tooltipBehavior: _tooltipBehavior,
                      series: <LineSeries<GraphData, String>>[
                    LineSeries<GraphData, String>(
                      color: R.color.blueColor,

                      dataSource: graphDataList,
                      xValueMapper: (GraphData sales, _) => sales.day,
                      yValueMapper: (GraphData sales, _) => sales.amountDiary,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                      ),
                      markerSettings: MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                        borderWidth: 2,
                        borderColor: R.color.blueColor,
                        color: Colors.white,
                      ),
                    )
                  ]);
                }
              ),

              /// Today expenses
              Padding(
                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                child: buildTodayExpensesList(),
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

  SingleChildScrollView buildTodayExpensesList() {
    return SingleChildScrollView(
      child: StreamBuilder<List<AllTransactionDataModel>>(
          stream: bloc.transactionListStream,
          initialData: [],
          builder: (context, snapshot) {
            final List<AllTransactionDataModel> allDataTodayList =
                snapshot.data ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Today Expenses",
                          style: GoogleFonts.alkatra(fontSize: 20)),
                      Text(allDataTodayList.isEmpty
                          ? ''
                          : "Total: ${allDataTodayList.length}",
                        style: GoogleFonts.alkatra(fontSize: 18)),
                    ],
                  ),
                ),
                allDataTodayList.isEmpty
                    ? Text(
                        "You have not made any expenses today.",
                        style: GoogleFonts.alkatra(fontSize: 17),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allDataTodayList.length,
                        itemBuilder: (context, index) {
                          final AllTransactionDataModel data =
                              allDataTodayList[index];
                          final String bougthDate = DateFormat('h:mm a')
                              .format(data.transaction!.date);
                          final String pricePerUnit =
                              (data.transaction!.amount /
                                      (data.transaction!.quantity ?? 1))
                                  .toStringAsFixed(2);

                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.5,
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      data.product!.name,
                                      style: GoogleFonts.alkatra(fontSize: 17),
                                      maxLines: 3,
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.access_time_rounded,
                                                size: 18,
                                                color: R.color.greenColor,
                                              ),
                                              Text(
                                                " $bougthDate ",
                                                style: GoogleFonts.alkatra(
                                                  fontSize: 15,
                                                  color: R.color.greenColor,
                                                ),
                                              ),
                                              Icon(
                                                Icons.lens,
                                                size: 8,
                                                color: Colors.black,
                                              ),
                                              Icon(
                                                Icons.attach_money,
                                                size: 18,
                                                color: R.color.blueColor,
                                              ),
                                              Text(
                                                "$pricePerUnit/unit",
                                                style: GoogleFonts.alkatra(
                                                  fontSize: 15,
                                                  color: R.color.blueColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4,
                                                  left: 4,
                                                  bottom: 4,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1.5,
                                                        color: Colors
                                                            .grey.shade400,
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.5),
                                                    child: Text(
                                                      data.category!.name,
                                                      style:
                                                          GoogleFonts.alkatra(
                                                        fontSize: 13,
                                                        color:
                                                            R.color.blackColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4,
                                                    top: 4,
                                                    bottom: 4),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1.5,
                                                        color: Colors
                                                            .grey.shade400,
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.5),
                                                    child: Text(
                                                      data.subcategory!.name,
                                                      style:
                                                          GoogleFonts.alkatra(
                                                        fontSize: 13,
                                                        color:
                                                            R.color.blackColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    // leading: Container(
                                    //   decoration: BoxDecoration(
                                    //       shape: BoxShape.circle,
                                    //       color: Colors.green,
                                    //       border: Border.all(
                                    //           color: Colors.blueGrey.shade200,
                                    //           width: 2)),
                                    //   child: CircleAvatar(
                                    //     radius: 10,
                                    //     backgroundColor:
                                    //         Colors.blueGrey.shade100,
                                    //     foregroundColor: Colors.black,
                                    //     child: Text(
                                    //       (index + 1).toString(),
                                    //       style: GoogleFonts.alkatra(
                                    //         fontSize: 14,
                                    //         color: R.color.blackColor,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    horizontalTitleGap: 3,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 6),
                                    trailing: Text(
                                      data.transaction!.amount
                                          .toStringAsFixed(2),
                                      style: GoogleFonts.alkatra(
                                        fontSize: 24,
                                        color: R.color.blackColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                SizedBox(
                  height: 200,
                )
              ],
            );
          }),
    );
  }

  EasyInfiniteDateTimeLine buildEasyInfiniteDateTimeLine() {
    return EasyInfiniteDateTimeLine(
      controller: _controller,
      firstDate: DateTime(2024),
      focusDate: _focusDate,
      lastDate: DateTime(2026),
      selectionMode: const SelectionMode.autoCenter(),
      headerBuilder: (context, date) {
        String monthYear = DateFormat('MMMM yyyy').format(date);
        return Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                monthYear,
                style: GoogleFonts.alkatra(fontSize: 18),
              ),
            ],
          ),
        );
      },
      onDateChange: (selectedDate) async {
        await bloc.refreshData(selectedDate);
        setState(() {
          _focusDate = selectedDate;
        });
      },
      dayProps: const EasyDayProps(
        height: 80.0,
      ),
      itemBuilder: (
        BuildContext context,
        DateTime date,
        bool isSelected,
        VoidCallback onTap,
      ) {
        bool today = date.month == DateTime.now().month &&
            date.day == DateTime.now().day &&
            date.year == DateTime.now().year;
        return InkResponse(
          onTap: onTap,
          child: Column(
            children: [
              Flexible(
                child: Text(
                  EasyDateFormatter.shortDayName(date, "en_US"),
                  style: TextStyle(
                    color: today ? R.color.blueColor : Colors.black,
                  ),
                ),
              ),
              Flexible(
                child: CircleAvatar(
                  // use `isSelected` to specify whether the widget is selected or not.
                  backgroundColor:
                      isSelected ? R.color.blueColor : R.color.whiteColor,
                  radius: 23.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GraphData {
  GraphData(this.day, this.amountDiary);
  final String day;
  final double amountDiary;
}

String getGreetings() {
  String greeting = '';
  int hour = DateTime.now().hour;
  if (hour <= 12) {
    greeting = 'Good Morning';
  } else if (hour > 12 && hour <= 6) {
    greeting = 'Good Afternoon';
  } else if (hour > 6) {
    greeting = 'Good Evening';
  }
  return greeting;
}
