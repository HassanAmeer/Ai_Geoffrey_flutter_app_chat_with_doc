import 'dart:async';
import 'dart:io';

import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share_plus/share_plus.dart';

class TextToPdfPage extends StatefulWidget {
  final String content;
  const TextToPdfPage({Key? key, required this.content}) : super(key: key);

  @override
  State<TextToPdfPage> createState() => _TextToPdfPageState();
}

class _TextToPdfPageState extends State<TextToPdfPage> {

  XFile? f;
  bool isPdfReady = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildPDF();
  }
  void buildPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Ask Geoffery"),
              pw.Divider(),
              pw.Text(widget.content)
            ]
          );
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    f = XFile(file.path);
    await file.writeAsBytes(await pdf.save()).then((value) {
      setState(() {
        isPdfReady = true;
      });
      //
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.textFieldColor,
        actions: [
          Padding(padding: const EdgeInsets.only(right: 20),  child: GestureDetector(child: const Icon(Icons.share), onTap: () {
            if(isPdfReady){
              Share.shareXFiles([f!], text: 'Check out this PDF!');
            } else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to share pdf. Please try later")));
            }
          },))
        ],
        title: const Text("Text To PDF"),
      ),
      body: isPdfReady ? Container(
        height: 500,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20 ),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

        ),
        child: PdfView(
          path: f?.path ?? "",

          gestureNavigationEnabled: true,
        ),
      ) : const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),),
    );
  }
}
