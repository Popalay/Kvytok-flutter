import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_crop/image_crop.dart';
import 'package:kvytok_flutter/ticket.dart';
import 'package:kvytok_flutter/ticket_layout.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripListPage extends StatefulWidget {
  TripListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TripListPageState createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  List<Ticket> _tickets = [];
  bool _isLoading = false;

  /// render at 150 dpi
  static const scale = 150 ~/ 72;

  Future<Ticket> _parseTicketFromPage(PDFPage page, BarcodeDetector detector) async {
    final pageImage = await page.render(
      width: page.width * scale,
      height: page.height * scale,
      backgroundColor: "#FFFFFF",
    );
    await page.close();
    final imageFilePath = (await getTemporaryDirectory()).path + "/qr_code_${page.id}.png";
    final imageFile = await File(imageFilePath).writeAsBytes(pageImage.bytes);
    final barcodes = await detector.detectInImage(FirebaseVisionImage.fromFile(imageFile));
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      final qrCodeImage = await ImageCrop.cropImage(
        file: imageFile,
        area: Rect.fromLTRB(
          barcode.boundingBox.left / pageImage.width,
          barcode.boundingBox.top / pageImage.height,
          barcode.boundingBox.right / pageImage.width,
          barcode.boundingBox.bottom / pageImage.height,
        ),
      );
      final ticket = Ticket.parseTicket(barcode.rawValue, qrCodeImage);
      return ticket;
    } else {
      return null;
    }
  }

  Future<void> _chosePdfFile() async {
    final filePath = await FilePicker.getFilePath(type: FileType.CUSTOM, fileExtension: "pdf");
    if (filePath != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("filePath", filePath);
      return _parsePdfToTickets(filePath);
    }
  }

  Future<void> _parsePdfToTickets(String filePath) async {
    setState(() {
      _isLoading = true;
    });
    final document = await PDFDocument.openFile(filePath);

    var barcodeDetector = FirebaseVision.instance.barcodeDetector(BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode));

    final List<Ticket> tickets = [];
    for (var i = 1; i <= document.pagesCount; ++i) {
      final page = await document.getPage(i);
      final ticket = await _parseTicketFromPage(page, barcodeDetector);
      if (ticket != null) tickets.add(ticket);
    }

    barcodeDetector.close();
    setState(() {
      _tickets = tickets;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initList();
  }

  _initList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final filePath = prefs.getString("filePath");
    if (filePath != null) {
      await _parsePdfToTickets(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.display2.apply(color: Colors.white),
        ),
      ),
      body: SafeArea(
        bottom: false,
        top: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                const Color.fromARGB(255, 28, 31, 35),
                const Color.fromARGB(255, 48, 52, 57),
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: _buildBody(_isLoading),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          onPressed: _chosePdfFile,
          label: Text("Pick ticket file"),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBody(bool isLoading) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Swiper(
        itemCount: _tickets.length,
        viewportFraction: 0.85,
        scale: 0.9,
        fade: 0.7,
        loop: false,
        itemBuilder: (context, position) => TicketLayout(_tickets[position], key: Key(_tickets[position].ticketNumber)),
      );
    }
  }
}
