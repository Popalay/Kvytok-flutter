import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kvytok_flutter/ticket.dart';
import 'package:kvytok_flutter/ticket_page.dart';

import 'label_widget.dart';

const colors = [
  Color(0xFF2DCF75),
  Color(0xFFF35764),
  Color(0xFF8F8EF7),
  Color(0xFFBD68F0),
  Color(0xFFD841A9),
];

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final Color backgroundColor;

  TicketCard(this.ticket, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Center(child: Text(ticket.departure + " --> " + ticket.arrival, textScaleFactor: 0.9, style: Theme.of(context).textTheme.title)),
            SizedBox(height: 8),
            Center(child: Text(ticket.passenger, style: Theme.of(context).textTheme.title)),
            SizedBox(height: 32),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(ticket.departureDate, style: Theme.of(context).textTheme.display1.apply(color: Colors.white)),
                SizedBox(height: 16),
                Icon(Icons.train),
                SizedBox(height: 16),
                Text(ticket.arrivalDate, style: Theme.of(context).textTheme.display1.apply(color: Colors.white)),
              ],
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                LabelWidget(label: "Car", value: ticket.carNumber),
                LabelWidget(label: "Seat", value: ticket.seatNumber),
              ],
            ),
            SizedBox(height: 16),
            Hero(
              tag: ticket.ticketNumber,
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                ),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => TicketPage(ticket)),
                  ),
                  child: Image.file(ticket.qrCodeFile, width: 100),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
