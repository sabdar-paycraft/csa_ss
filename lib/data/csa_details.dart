import 'package:csa/utils/converter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CSADetails {
  var hexConverter = HexConverter();
  var decimal = DecimalConverter();
  var nibble = NibbleConverter();
  var binary = BinaryConverter();
  Map<String, Color> fieldColors = {};
  final Random random = Random();

  Color getColorForField(String fieldName) {
    if (!fieldColors.containsKey(fieldName)) {
      // Generate a random color
      fieldColors[fieldName] =
          Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.45);
    }
    return fieldColors[fieldName]!;
  }

  // Make csaDetails an instance field
  late final List<Map<String, dynamic>> csaDetails;

  CSADetails() {
    csaDetails = [
      {
        "type": "General Data",
        "caller": decimal,
        "name": "Version No",
        "color": getColorForField("Version No"),
        "bits": 8,
        "start": 0,
        "end": 7
      },
      {
        "type": "General Data",
        "caller": decimal,
        "name": "Language Info",
        "color": getColorForField("Language Info"),
        "bits": 5,
        "start": 8,
        "end": 12
      },
      {
        "type": "General Data",
        "caller": decimal,
        "name": "RFU",
        "color": getColorForField("RFU"),
        "bits": 3,
        "start": 13,
        "end": 15
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Error Code",
        "color": getColorForField("Error Code"),
        "bits": 8,
        "start": 16,
        "end": 23
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Product Type",
        "color": getColorForField("Product Type"),
        "bits": 8,
        "start": 24,
        "end": 31
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Acquirer ID",
        "color": getColorForField("Acquirer ID"),
        "bits": 8,
        "start": 32,
        "end": 39
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Operator ID",
        "color": getColorForField("Operator ID"),
        "bits": 16,
        "start": 40,
        "end": 55
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Station ID",
        "color": getColorForField("Station ID"),
        "bits": 12,
        "start": 56,
        "end": 67
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Device Category",
        "color": getColorForField("Device Category"),
        "bits": 6,
        "start": 68,
        "end": 73
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Device Number",
        "color": getColorForField("Device Number"),
        "bits": 6,
        "start": 74,
        "end": 79
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Transaction Date & Time",
        "color": getColorForField("Transaction Date & Time"),
        "bits": 24,
        "start": 80,
        "end": 103
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Fare Amount",
        "color": getColorForField("Fare Amount"),
        "bits": 16,
        "start": 104,
        "end": 119
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Route No.",
        "color": getColorForField("Route No."),
        "bits": 16,
        "start": 120,
        "end": 135
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Service Provider Data",
        "color": getColorForField("Service Provider Data"),
        "bits": 24,
        "start": 136,
        "end": 159
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "Transaction Status",
        "color": getColorForField("Transaction Status"),
        "bits": 4,
        "start": 160,
        "end": 163
      },
      {
        "type": "Validation",
        "caller": decimal,
        "name": "RFU",
        "color": getColorForField("RFU"),
        "bits": 4,
        "start": 164,
        "end": 167
      },
      //-------------History 1
      {
        "type": "History 1",
        "caller": decimal,
        "name": "Acquirer ID",
        "color": getColorForField("Acquirer ID"),
        "bits": 8,
        "start": 168,
        "end": 175
      },
      {
        "type": "History 1",
        "caller": decimal,
        "name": "Operator ID",
        "color": getColorForField("Operator ID"),
        "bits": 16,
        "start": 176,
        "end": 191
      },
      {
        "type": "History 1",
        "caller": decimal,
        "name": "Station ID",
        "color": getColorForField("Station ID"),
        "bits": 12,
        "start": 192,
        "end": 203
      },
      {
        "type": "History 1",
        "caller": decimal,
        "name": "Device Category",
        "color": getColorForField("Device Category"),
        "bits": 6,
        "start": 204,
        "end": 209
      },
      {
        "type": "History 1",
        "caller": decimal,
        "name": "Device Number",
        "color": getColorForField("Device Number"),
        "bits": 6,
        "start": 210,
        "end": 215
      },
      {
        "type": "History 1",
        "caller": decimal,
        "name": "Transaction Date & Time",
        "color": getColorForField("Transaction Date & Time"),
        "bits": 24,
        "start": 216,
        "end": 239
      },
      {
        "type": "History 1",
        "caller": decimal,
        "name": "Transaction Sequence No.",
        "color": getColorForField("Transaction Sequence No."),
        "bits": 16,
        "start": 240,
        "end": 255
      },
      {
        "type": "History 1",
        "caller": decimal,
        "name": "Transaction Amount",
        "color": getColorForField("Transaction Amount"),
        "bits": 16,
        "start": 256,
        "end": 271
      },
      {
        "type": "History 1",
        "caller": decimal,
        "name": "Card Balance",
        "color": getColorForField("Card Balance"),
        "bits": 20,
        "start": 272,
        "end": 291
      },
      {
        "type": "History 1",
        "caller": decimal,
        "name": "Transaction Status",
        "color": getColorForField("Transaction Status"),
        "bits": 4,
        "start": 292,
        "end": 295
      },
      {
        "type": "History 1",
        "caller": decimal,
        "name": "RFU",
        "color": getColorForField("RFU"),
        "bits": 8,
        "start": 296,
        "end": 303
      },
      // -----History 2
      {
        "type": "History 2",
        "caller": decimal,
        "name": "Acquirer ID",
        "color": getColorForField("Acquirer ID"),
        "bits": 8,
        "start": 304,
        "end": 311
      },
      {
        "type": "History 2",
        "caller": decimal,
        "name": "Operator ID",
        "color": getColorForField("Operator ID"),
        "bits": 16,
        "start": 312,
        "end": 327
      },
      {
        "type": "History 2",
        "caller": decimal,
        "name": "Station ID",
        "color": getColorForField("Station ID"),
        "bits": 12,
        "start": 328,
        "end": 339
      },
      {
        "type": "History 2",
        "caller": decimal,
        "name": "Device Category",
        "color": getColorForField("Device Category"),
        "bits": 6,
        "start": 340,
        "end": 345
      },
      {
        "type": "History 2",
        "caller": decimal,
        "name": "Device Number",
        "color": getColorForField("Device Number"),
        "bits": 6,
        "start": 346,
        "end": 351
      },
      {
        "type": "History 2",
        "caller": decimal,
        "name": "Transaction Date & Time",
        "color": getColorForField("Transaction Date & Time"),
        "bits": 24,
        "start": 352,
        "end": 375
      },
      {
        "type": "History 2",
        "caller": decimal,
        "name": "Transaction Sequence No.",
        "color": getColorForField("Transaction Sequence No."),
        "bits": 16,
        "start": 376,
        "end": 391
      },
      {
        "type": "History 2",
        "caller": decimal,
        "name": "Transaction Amount",
        "color": getColorForField("Transaction Amount"),
        "bits": 16,
        "start": 392,
        "end": 407
      },
      {
        "type": "History 2",
        "caller": decimal,
        "name": "Card Balance",
        "color": getColorForField("Card Balance"),
        "bits": 20,
        "start": 408,
        "end": 427
      },
      {
        "type": "History 2",
        "caller": decimal,
        "name": "Transaction Status",
        "color": getColorForField("Transaction Status"),
        "bits": 4,
        "start": 428,
        "end": 431
      },
      {
        "type": "History 2",
        "caller": decimal,
        "name": "RFU",
        "color": getColorForField("RFU"),
        "bits": 8,
        "start": 432,
        "end": 439
      },
      // -------History 3
      {
        "type": "History 3",
        "caller": decimal,
        "name": "Acquirer ID",
        "color": getColorForField("Acquirer ID"),
        "bits": 8,
        "start": 440,
        "end": 447
      },
      {
        "type": "History 3",
        "caller": decimal,
        "name": "Operator ID",
        "color": getColorForField("Operator ID"),
        "bits": 16,
        "start": 448,
        "end": 463
      },
      {
        "type": "History 3",
        "caller": decimal,
        "name": "Station ID",
        "color": getColorForField("Station ID"),
        "bits": 12,
        "start": 464,
        "end": 475
      },
      {
        "type": "History 3",
        "caller": decimal,
        "name": "Device Category",
        "color": getColorForField("Device Category"),
        "bits": 6,
        "start": 476,
        "end": 481
      },
      {
        "type": "History 3",
        "caller": decimal,
        "name": "Device Number",
        "color": getColorForField("Device Number"),
        "bits": 6,
        "start": 482,
        "end": 487
      },
      {
        "type": "History 3",
        "caller": decimal,
        "name": "Transaction Date & Time",
        "color": getColorForField("Transaction Date & Time"),
        "bits": 24,
        "start": 488,
        "end": 511
      },
      {
        "type": "History 3",
        "caller": decimal,
        "name": "Transaction Sequence No.",
        "color": getColorForField("Transaction Sequence No."),
        "bits": 16,
        "start": 512,
        "end": 527
      },
      {
        "type": "History 3",
        "caller": decimal,
        "name": "Transaction Amount",
        "color": getColorForField("Transaction Amount"),
        "bits": 16,
        "start": 528,
        "end": 543
      },
      {
        "type": "History 3",
        "caller": decimal,
        "name": "Card Balance",
        "color": getColorForField("Card Balance"),
        "bits": 20,
        "start": 544,
        "end": 563
      },
      {
        "type": "History 3",
        "caller": decimal,
        "name": "Transaction Status",
        "color": getColorForField("Transaction Status"),
        "bits": 4,
        "start": 564,
        "end": 567
      },
      {
        "type": "History 3",
        "caller": decimal,
        "name": "RFU",
        "color": getColorForField("RFU"),
        "bits": 8,
        "start": 568,
        "end": 575
      },
      // -----History 4

      {
        "type": "History 4",
        "caller": decimal,
        "name": "Acquirer ID",
        "color": getColorForField("Acquirer ID"),
        "bits": 8,
        "start": 576,
        "end": 583
      },
      {
        "type": "History 4",
        "caller": decimal,
        "name": "Operator ID",
        "color": getColorForField("Operator ID"),
        "bits": 16,
        "start": 584,
        "end": 599
      },
      {
        "type": "History 4",
        "caller": decimal,
        "name": "Station ID",
        "color": getColorForField("Station ID"),
        "bits": 12,
        "start": 600,
        "end": 611
      },
      {
        "type": "History 4",
        "caller": decimal,
        "name": "Device Category",
        "color": getColorForField("Device Category"),
        "bits": 6,
        "start": 612,
        "end": 617
      },
      {
        "type": "History 4",
        "caller": decimal,
        "name": "Device Number",
        "color": getColorForField("Device Number"),
        "bits": 6,
        "start": 618,
        "end": 623
      },
      {
        "type": "History 4",
        "caller": decimal,
        "name": "Transaction Date & Time",
        "color": getColorForField("Transaction Date & Time"),
        "bits": 24,
        "start": 624,
        "end": 647
      },
      {
        "type": "History 4",
        "caller": decimal,
        "name": "Transaction Sequence No.",
        "color": getColorForField("Transaction Sequence No."),
        "bits": 16,
        "start": 648,
        "end": 663
      },
      {
        "type": "History 4",
        "caller": decimal,
        "name": "Transaction Amount",
        "color": getColorForField("Transaction Amount"),
        "bits": 16,
        "start": 664,
        "end": 679
      },
      {
        "type": "History 4",
        "caller": decimal,
        "name": "Card Balance",
        "color": getColorForField("Card Balance"),
        "bits": 20,
        "start": 680,
        "end": 699
      },
      {
        "type": "History 4",
        "caller": decimal,
        "name": "Transaction Status",
        "color": getColorForField("Transaction Status"),
        "bits": 4,
        "start": 700,
        "end": 703
      },
      {
        "type": "History 4",
        "caller": decimal,
        "name": "RFU",
        "color": getColorForField("RFU"),
        "bits": 8,
        "start": 704,
        "end": 711
      },
      // -----
      {
        "type": "Other",
        "caller": decimal,
        "name": "CRN",
        "color": getColorForField("CRN"),
        "bits": 48,
        "start": 712,
        "end": 759
      },
      {
        "type": "Other",
        "caller": decimal,
        "name": "RFU",
        "color": getColorForField("RFU"),
        "bits": 8,
        "start": 760,
        "end": 767
      },
    ];
  }
}
