class Constants {
  static String csaString =
      "310004060E178100B142034A0801900001000000100E178100B14C0347D40008005A004BA0000E178100714B034491001A005A005140000E178100B14C0342340008005A0056E0000E178100714C03395F0012005A005C800000000000000000";

  static List<Map<String, dynamic>> error = [
    {"id": 0, "error": "No Error"},
    {"id": 4, "error": "Entry Mismatch"},
    {"id": 3, "error": "Exit Mismatch"},
    {"id": 6, "error": "Overstay"},
    {"id": 101, "error": "Overtravel"},
    {"id": 102, "error": "Exit Mismatch + Overtravel"},
    {"id": 103, "error": "Overstay + Overtravel"}
  ];

  static List<Map<String, dynamic>> transactionType = [
    {"id": 0, "transaction_type": "Exit done"},
    {"id": 1, "transaction_type": "Entry done"},
    {"id": 2, "transaction_type": "Entry Mismatch"},
    {"id": 3, "transaction_type": "Exit Mismatch"},
    {"id": 4, "transaction_type": "Overstay same station"},
    {"id": 5, "transaction_type": "Overstay diff. station"},
    {"id": 6, "transaction_type": "Overtravel"},
    {"id": 7, "transaction_type": "Exit Mismatch + Overtravel"},
    {"id": 8, "transaction_type": "Overstay + Overtravel"},
  ];

  static List<Map<String, dynamic>> languageInfo = [
    {
      "id": 1,
      "language_id": 0,
      "language_name": "English",
    },
    {
      "id": 2,
      "language_id": 1,
      "language_name": "Hindi",
    },
    {
      "id": 3,
      "language_id": 3,
      "language_name": "Marathi",
    },
    {
      "id": 4,
      "language_id": 6,
      "language_name": "Gujarati",
    },
  ];

  static List<Map<String, dynamic>> routeInfo = [
    {
      "id": 1,
      "route_name": "Line 1",
    },
    {
      "id": 2,
      "route_name": "Line 2",
    },
  ];
}
