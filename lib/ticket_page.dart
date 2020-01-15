import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kvytok_flutter/ticket.dart';

class TicketPage extends StatelessWidget {
  final Ticket ticket;

  const TicketPage(this.ticket);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: ticket.ticketNumber,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          title: Text(
            ticket.ticketNumber,
            style: Theme.of(context).textTheme.title.apply(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          bottom: false,
          top: false,
          child: Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${ticket.trainNumber} ${ticket.departure}-${ticket.arrival}",
                  style: Theme.of(context).textTheme.body2.apply(color: Colors.black),
                ),
                Text(
                  ticket.passenger,
                  style: Theme.of(context).textTheme.body2.apply(color: Colors.black),
                ),
                Spacer(),
                Image.file(ticket.qrCodeFile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
