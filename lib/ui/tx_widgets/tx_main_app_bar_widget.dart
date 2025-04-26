
import 'package:gastos_app/app_globals/R.dart';
import 'package:flutter/material.dart';
import 'package:gastos_app/ui/tx_widgets/tx_icon_button_widget.dart';
import 'package:gastos_app/ui/tx_widgets/tx_text_widget.dart';


class TXMainAppBarWidget extends StatefulWidget {
  final Widget body;
  final String title;
  final bool centeredTitle;
  final TXIconButtonWidget? leading;
  final Function()? onLeadingTap;
  final List<Widget> actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool hideLeading;
  final Color? textColor;

  const TXMainAppBarWidget(
      {Key? key,
      required this.body,
      this.title = "",
      this.centeredTitle = false,
      this.leading,
      this.actions = const [],
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.onLeadingTap,
      this.hideLeading = false,
      this.textColor
      })
      : super(key: key);

  @override
  State<TXMainAppBarWidget> createState() => _TXMainAppBarWidgetState();
}

class _TXMainAppBarWidgetState extends State<TXMainAppBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      appBar: AppBar(
        centerTitle: widget.centeredTitle,
        title: TXTextWidget(
          text: widget.title,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          size: 20,
          color: widget.textColor,
        ),
        actions: widget.actions,
      ),
      body: widget.body,
    );
  }
}
