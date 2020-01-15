import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kvytok_flutter/ticket.dart';
import 'package:kvytok_flutter/ticket_card.dart';

class TicketLayout extends StatefulWidget {
  final Ticket ticket;

  const TicketLayout(this.ticket, {Key key}) : super(key: key);

  @override
  _TicketLayoutState createState() => _TicketLayoutState();
}

class _TicketLayoutState extends State<TicketLayout> {
  Color backgroundColor;

  @override
  void initState() {
    super.initState();
    backgroundColor = colors[Random(widget.ticket.ticketNumber.hashCode).nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runAlignment: WrapAlignment.center,
      children: <Widget>[Container(child: TicketCard(widget.ticket, backgroundColor))],
    );
  }
}
