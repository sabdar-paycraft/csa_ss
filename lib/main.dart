import 'package:csa/data/csa_details.dart';
import 'package:csa/data/constant.dart';
import 'package:csa/data/pass_type.dart';
import 'package:csa/data/station_list.dart';
import 'package:csa/utils/converter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HexToBinaryPage(),
    );
  }
}

class HexToBinaryPage extends StatefulWidget {
  const HexToBinaryPage({super.key});

  @override
  _HexToBinaryPageState createState() => _HexToBinaryPageState();
}

class _HexToBinaryPageState extends State<HexToBinaryPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late AnimationController _animationController;

  Map<String, List<Map<String, dynamic>>> groupedData = {};
  String _binaryOutput = '';
  Map<String, String> extractedData = {};
  var decimal = DecimalConverter();
  var nibble = NibbleConverter();
  var csaDetailsInstance = CSADetails();
  bool isPMRL = true;
  bool isAHM = false;
  bool isCMRL = false;
  bool isAGRA = false;

  List<Map<String, dynamic>> csaDetails = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animationController.repeat();
    setState(() {
      _controller.text = Constants.csaString;
      _dateController.text = "240901";
      csaDetails = csaDetailsInstance.csaDetails;
    });
    convertHexToBinary(_controller.text);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _controller.clear();
    _dateController.clear();
  }

  static Map<String, dynamic> processHexString(Map<String, dynamic> data) {
    String hex = data["hex"];
    List<Map<String, dynamic>> csaDetails = data["csaDetails"];

    // Convert hex to binary
    String binaryString = '';
    for (int i = 0; i < hex.length; i++) {
      int hexValue = int.parse(hex[i], radix: 16);
      binaryString += hexValue.toRadixString(2).padLeft(4, '0');
    }

    // Extract fields from binary string
    for (var detail in csaDetails) {
      int start = detail['start'];
      int end = detail['end'];

      if (start < binaryString.length && end < binaryString.length) {
        String extractedValue = binaryString.substring(start, end + 1);
        detail["extractedData"] = extractedValue;
      } else {
        detail["extractedData"] = 'Invalid range';
      }
    }

    return {
      "binaryString": binaryString,
      "csaDetails": csaDetails,
    };
  }

  static Map<String, List<Map<String, dynamic>>> groupDataByType(
      Map<String, dynamic> data) {
    List<Map<String, dynamic>> csaDetails = data["csaDetails"];
    List<Map<String, dynamic>> passList = data["passList"];
    List<Map<String, dynamic>> languageInfo = data["languageInfo"];
    List<Map<String, dynamic>> transactionType = data["transactionType"];
    List<Map<String, dynamic>> error = data["error"];
    List<Map<String, dynamic>> routeInfo = data["routeInfo"];
    List<Map<String, dynamic>> stationList = data["stationList"];
    bool isPMRL = data["isPMRL"];
    bool isAHM = data["isAHM"];
    bool isAGRA = data["isAGRA"];
    TextEditingController dateController = data['controller'];
    {
      Map<String, List<Map<String, dynamic>>> groupedData = {};

      String getActualAndDecimalValues(String actualValue, var decimalValue) {
        return '$actualValue ($decimalValue)';
      }

      void updateTransactionDateTime(
          Map<String, dynamic> item, String convertedData) {
        final eppochTime = dateController.text;
        print("epoch tiime:${dateController.text}");
        // Ensure that the input is a valid epoch time (string of digits)
        if (eppochTime.isNotEmpty && RegExp(r'^\d+$').hasMatch(eppochTime)) {
          final day = int.parse(eppochTime.substring(4, 6));
          final month = int.parse(eppochTime.substring(2, 4));
          final year = 2000 + int.parse(eppochTime.substring(0, 2));
          final eEpochformattedDate = DateTime(year, month, day);

          final actualTimeInmili = eEpochformattedDate.millisecondsSinceEpoch +
              (int.parse(convertedData) * 1000 * 60);
          final dateTime = DateTime.fromMillisecondsSinceEpoch(actualTimeInmili,
              isUtc: true);

          item["actual_data"] = getActualAndDecimalValues(
              DateFormat('dd:MM:yyyy HH:mm').format(dateTime), convertedData);
        } else {
          item["actual_data"] = 'Invalid Epoch Time';
        }
      }

      final passMap = {
        for (var product in passList) product["pass_id"]: product
      };
      final languageMap = {
        for (var langItem in languageInfo) langItem["language_id"]: langItem
      };
      final transactionMap = {
        for (var transactionItem in transactionType)
          transactionItem["id"]: transactionItem
      };
      final errorMap = {
        for (var errorItem in error) errorItem["id"]: errorItem
      };
      final routeMap = {
        for (var routeItem in routeInfo) routeItem["id"]: routeItem
      };
      final stationMap = isPMRL
          ? {
        for (var stationItem in stationList)
          stationItem["station_id"]: stationItem
      }
          : isAHM
          ? {
        for (var stationItem in stationList)
          stationItem["station_id"]: stationItem
      }
          : isAGRA
          ? {
        for (var stationItem in stationList)
          stationItem["station_id"]: stationItem
      }
          : {
        for (var stationItem in stationList)
          stationItem["station_id"]: stationItem
      };

      for (var item in csaDetails) {
        final extractedData = item["extractedData"];
        final converter = item["caller"];
        final convertedData = converter.convert(extractedData);

        switch (item["name"]) {
          case "Product Type":
            final product = passMap[int.parse(convertedData)];
            item["actual_data"] = product != null
                ? getActualAndDecimalValues(product["pass_name"], convertedData)
                : getActualAndDecimalValues('NA', convertedData);
            break;

          case "Language Info":
            final langItem = languageMap[int.parse(convertedData)];
            item["actual_data"] = langItem != null
                ? getActualAndDecimalValues(
                langItem["language_name"], convertedData)
                : getActualAndDecimalValues('NA', convertedData);
            break;

          case "Transaction Status":
            final transactionItem = transactionMap[int.parse(convertedData)];
            item["actual_data"] = transactionItem != null
                ? getActualAndDecimalValues(
                transactionItem["transaction_type"], convertedData)
                : getActualAndDecimalValues('NA', convertedData);
            break;

          case "Error Code":
            final errorItem = errorMap[int.parse(convertedData)];
            item["actual_data"] = errorItem != null
                ? getActualAndDecimalValues(errorItem["error"], convertedData)
                : getActualAndDecimalValues('NA', convertedData);
            break;

          case "Station ID":
            final stationItem = stationMap[int.parse(convertedData)];
            item["actual_data"] = stationItem != null
                ? getActualAndDecimalValues(
                stationItem["station_name"], convertedData)
                : getActualAndDecimalValues('NA', convertedData);
            break;

          case "Route No.":
            final routeItem = routeMap[int.parse(convertedData)];
            item["actual_data"] = routeItem != null
                ? getActualAndDecimalValues(
                routeItem["route_name"], convertedData)
                : getActualAndDecimalValues('NA', convertedData);
            break;

          case "Transaction Date & Time":
            updateTransactionDateTime(item, convertedData);
            break;

          default:
            item["actual_data"] = convertedData.toString();
        }

        final type = item['type'];
        groupedData.putIfAbsent(type, () => []).add(item);
      }

      return groupedData;
    }
  }

  void convertHexToBinary(String hex) async {
    try {
      // Run hex processing in an isolate
      final processedData = await compute(
        processHexString,
        {
          "hex": hex,
          "csaDetails": csaDetails,
        },
      );

      // Update state with the results
      setState(() {
        _binaryOutput = processedData["binaryString"];
        csaDetails = processedData["csaDetails"];
      });

      // Run groupDataByType in another isolate if hex is not empty
      if (hex.isNotEmpty) {
        final groupedData = await compute(
          groupDataByType, // Reuse the same function
          {
            "csaDetails": csaDetails,
            "passList": PassType.passList,
            "languageInfo": Constants.languageInfo,
            "transactionType": Constants.transactionType,
            "error": Constants.error,
            "routeInfo": Constants.routeInfo,
            "stationList": isPMRL
                ? StationList.pmrlStations
                : isAHM
                ? StationList.ahmStations
                : isAGRA
                ? StationList.agraStations
                : StationList.cmrlStations,
            "isPMRL": isPMRL,
            "isAHM": isAHM,
            "isAGRA": isAGRA,
            "controller": _dateController,
          },
        );

        setState(() {
          this.groupedData = groupedData;
        });
      }
    } catch (e) {
      print("Error in isolate: $e");
      setState(() {
        _binaryOutput = "Error processing hex string";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPMRL
              ? 'PMRL CSA'
              : isAHM
              ? 'AHM CSA'
              : isAGRA
              ? 'AGRA CSA'
              : 'CMRL CSA',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isPMRL
            ? Colors.blue
            : isAHM
            ? Colors.deepOrange
            : isAGRA
            ? Colors.red
            : Colors.purple,
        actions: [rotatingButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Card(
                color: isPMRL
                    ? const Color.fromARGB(255, 180, 217, 247)
                    : isAHM
                    ? const Color.fromARGB(255, 246, 175, 154)
                    : isAGRA
                    ? const Color.fromARGB(255, 255, 185, 185)
                    : const Color.fromARGB(255, 226, 150, 240),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Enter Hex String',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          convertHexToBinary(text);
                        },
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _dateController,
                        maxLength: 6,
                        decoration: InputDecoration(
                            labelText: 'Enter Epoch Time (6 digits)',
                            border: OutlineInputBorder(),
                            counterText: ""),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (text) {
                          if (text.length == 6) {
                            convertHexToBinary(_controller.text);
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Row(children: [
                            Text(
                              "PMRL",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            CupertinoSwitch(
                              activeTrackColor: Colors.blue,

                              inactiveTrackColor: Colors.grey,
                              value: isPMRL,
                              onChanged: (value) {
                                setState(() {
                                  if (!value) {
                                    isAHM = !value;
                                    isPMRL = value;
                                  } else {
                                    isAHM = !value;
                                    isCMRL = !value;
                                    isAGRA = !value;
                                    isPMRL = value;
                                  }
                                });
                                convertHexToBinary(_controller.text);
                              },
                              // onChanged: (value) => setState(() =>  = value),
                            ),
                          ]),
                          SizedBox(width: 16),
                          Row(children: [
                            Text(
                              "AHM",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            CupertinoSwitch(
                              activeTrackColor: Colors.deepOrange,

                              inactiveTrackColor: Colors.grey,
                              value: isAHM,
                              onChanged: (value) {
                                setState(() {
                                  if (!value) {
                                    isCMRL = !value;
                                    isAHM = value;
                                  } else {
                                    isAHM = value;
                                    isPMRL = !value;
                                    isCMRL = !value;
                                    isAGRA = !value;
                                  }
                                });
                                convertHexToBinary(_controller.text);
                              },
                              // onChanged: (value) => setState(() =>  = value),
                            ),
                          ]),
                          SizedBox(width: 16),
                          Row(children: [
                            Text(
                              "CMRL",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            CupertinoSwitch(
                              activeTrackColor: Colors.purple,

                              inactiveTrackColor: Colors.grey,
                              value: isCMRL,
                              onChanged: (value) {
                                setState(() {
                                  if (!value) {
                                    isCMRL = value;
                                    isPMRL = !value;
                                  } else {
                                    isAHM = !value;
                                    isPMRL = !value;
                                    isAGRA = !value;
                                    isCMRL = value;
                                  }
                                });
                                convertHexToBinary(_controller.text);
                              },
                              // onChanged: (value) => setState(() =>  = value),
                            ),
                          ]),
                          SizedBox(width: 16),
                          Row(children: [
                            Text(
                              "AGRA",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            CupertinoSwitch(
                              activeTrackColor: Colors.red,
                              inactiveTrackColor: Colors.grey,
                              value: isAGRA,
                              onChanged: (value) {
                                setState(() {
                                  if (!value) {
                                    isAGRA = value;
                                    isPMRL = !value;
                                  } else {
                                    isAHM = !value;
                                    isPMRL = !value;
                                    isCMRL = !value;
                                    isAGRA = value;
                                  }
                                });
                                convertHexToBinary(_controller.text);
                              },
                            ),
                          ]),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Binary Output:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(_binaryOutput.isNotEmpty
                  ? _binaryOutput
                  : 'Enter a valid hex string'),
              SizedBox(height: 16),
              _controller.text.isEmpty
                  ? Text("")
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var type in groupedData.keys)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            thickness: 2,
                            color: isPMRL
                                ? Colors.blue
                                : isAHM
                                ? Colors.deepOrange
                                : isAGRA
                                ? Colors.red
                                : Colors.purple,
                          ),
                          Text(
                            '$type:',
                            style: TextStyle(
                              // decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                            SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 240,
                              mainAxisExtent: 140,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: groupedData[type]?.length ?? 0,
                            itemBuilder: (context, index) {
                              var itemData = groupedData[type]?[index];
                              String key = itemData?["name"] ?? "";
                              String value =
                                  itemData?["extractedData"] ?? "";
                              Converter converter = nibble;
                              return SizedBox(
                                width: 250,
                                child: Card(
                                  color: itemData?["color"],
                                  margin:
                                  EdgeInsets.symmetric(horizontal: 8),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$key:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Text("Data:",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            SizedBox(width: 10),
                                            Flexible(
                                              child: SelectableText(
                                                converter.convert(value),
                                                style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text("Actual Data:",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            SizedBox(width: 10),
                                            Flexible(
                                              child: SelectableText(
                                                itemData?[
                                                "actual_data"] ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rotatingButton() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return MouseRegion(
          cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
          child: Transform.rotate(
            angle: _animationController.value * 2 * 3.14159,
            child: GestureDetector(
              onTap: () {
                showBottomSheet();
              },
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Mapping",
                    style: TextStyle(
                      color: isPMRL
                          ? Colors.blue
                          : isAHM
                          ? Colors.deepOrange
                          : isAGRA
                          ? Colors.red
                          : Colors.purple,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Mapping Tables",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      'Error Mapping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    buildMappingTable(context,
                        headers: ["ID", "Error"], data: Constants.error),
                    SizedBox(height: 10),
                    Text(
                      'Language Mapping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    buildMappingTable(context,
                        headers: ["language_id", "language_name"],
                        data: Constants.languageInfo),
                    SizedBox(height: 10),
                    Text(
                      'Transaction Type Mapping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    buildMappingTable(context,
                        headers: ["ID", "transaction_type"],
                        data: Constants.transactionType),
                    SizedBox(height: 10),
                    Text(
                      'Route No. Mapping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    buildMappingTable(context,
                        headers: ["ID", "route_name"],
                        data: Constants.routeInfo),
                    SizedBox(height: 10),
                    Text(
                      'Station Mapping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    buildMappingTable(context,
                        headers: ["station_id", "station_name"],
                        data: isPMRL
                            ? StationList.pmrlStations
                            : isAHM
                            ? StationList.ahmStations
                            : isAGRA
                            ? StationList.agraStations
                            : StationList.cmrlStations),
                    SizedBox(height: 10),
                    Text(
                      'Pass Type Mapping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    buildMappingTable(context,
                        headers: ["pass_id", "pass_name"],
                        data: PassType.passList),
                  ]),
            ),
          );
        });
  }

  Widget buildMappingTable(BuildContext context,
      {required List<String> headers,
        required List<Map<String, dynamic>> data}) {
    return Table(
      border: TableBorder.all(
        width: 1.2,
        color: isPMRL
            ? const Color.fromARGB(255, 14, 142, 247)
            : isAHM
            ? Colors.deepOrange
            : isAGRA
            ? Colors.red
            : Colors.purple,
      ),
      columnWidths: {
        for (int i = 0; i < headers.length; i++) i: FlexColumnWidth(),
      },
      children: [
        TableRow(
          children: headers
              .map((header) => TableCell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                header,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ))
              .toList(),
        ),
        // Data Rows
        for (var item in data)
          TableRow(
            children: headers.map((header) {
              var value = item[header.toLowerCase()];
              return TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(value?.toString() ?? ''),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}