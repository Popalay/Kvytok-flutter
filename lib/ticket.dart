import 'dart:convert';
import 'dart:io';

class Ticket {
  final String ticketNumber;
  final String passenger;
  final String trainNumber;
  final String carNumber;
  final String seatNumber;
  final String departure;
  final String arrival;
  final String departureDate;
  final String arrivalDate;
  final File qrCodeFile;

  const Ticket(
    this.ticketNumber,
    this.passenger,
    this.trainNumber,
    this.carNumber,
    this.seatNumber,
    this.departure,
    this.arrival,
    this.departureDate,
    this.arrivalDate,
    this.qrCodeFile,
  );

  @override
  String toString() {
    return """
Ticket number: $ticketNumber
Passenger: $passenger
Train number: $trainNumber
Car number: $carNumber
Seat number: $seatNumber
Departure: $departure
Arrival: $arrival
Departure date: $departureDate
Arrival date: $arrivalDate
    """;
  }

  static Ticket parseTicket(String rawText, File qrCode) {
    final lines = LineSplitter().convert(rawText.trim());
    assert(lines.length > 14);
    return Ticket(
      lines[14]?.trim() ?? "",
      lines[8]?.toLowerCase()?.split(" ")?.map((string) => string.capitalize())?.join(" ")?.trim(),
      lines[0]?.trim() ?? "",
      lines[5]?.trim() ?? "",
      lines[6]?.trim() ?? "",
      lines[1]?.substringAfterLast(")")?.trim()?.toLowerCase()?.capitalize(),
      lines[2]?.substringAfterLast(")")?.trim()?.toLowerCase()?.capitalize(),
      lines[3]?.trim() ?? "",
      lines[4]?.trim() ?? "",
      qrCode,
    );
  }
}

extension StringOperations on String {
  String capitalize() => this[0].toUpperCase() + this.substring(1);

  String substringAfterLast(String delimiter) {
    final index = lastIndexOf(delimiter);
    return index == -1 ? this : substring(index + delimiter.length, length);
  }
}
