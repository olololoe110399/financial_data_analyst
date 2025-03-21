import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> readFileAsPDFTextIsolate(Uint8List? bytes) async {
  return compute(_readFileAsPDFText, bytes);
}

String _readFileAsPDFText(Uint8List? bytes) {
  PdfDocument document = PdfDocument(inputBytes: bytes);
  String text = PdfTextExtractor(document).extractText();
  document.dispose();
  return text;
}
