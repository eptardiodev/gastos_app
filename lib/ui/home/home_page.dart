import 'package:gastos_app/app_globals/R.dart';
import 'package:gastos_app/base/bloc_state.dart';
import 'package:flutter/material.dart';
import 'home_bloc.dart';



class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends StateWithBloC<HomePage, HomeBloC> {


  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: R.color.primaryColor,
      //   onPressed: () {},
      //   child: Container(
      //     padding: const EdgeInsets.all(5),
      //     decoration: const BoxDecoration(
      //       shape: BoxShape.circle,
      //       color: Colors.white,
      //     ),
      //     child: Icon(
      //       Icons.add,
      //       color: R.color.primaryColor,
      //     ),
      //   ),
      // ),
      body: Center(
        child: Column(
          children: [],
        )
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Gastos",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
        backgroundColor: R.color.primaryColor,
      ),
      drawer: Drawer(

      ),
    );
  }
}
