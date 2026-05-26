class HexConverter extends Converter {
  @override
  String convert(data) {
    return data;
  }
}

class NibbleConverter extends Converter {
  @override
  String convert(dynamic data) {
    if (data is String) {
      // Ensure the binary string is a valid length
      if (data.length % 4 != 0) {
        // If the binary string length is not a multiple of 4, pad it with leading zeros
        data = data.padLeft(data.length + (4 - data.length % 4), '0');
      }

      // Initialize an empty string to hold the nibble result
      String result = '';

      // Loop through the binary string in chunks of 4 bits
      for (int i = 0; i < data.length; i += 4) {
        String nibble = data.substring(i, i + 4);
        result += _binaryToHex(nibble); // Convert the nibble to hex
      }

      return result; // Return the final nibble string
    } else {
      throw ArgumentError('Input must be a binary string.');
    }
  }

  // Helper function to convert a 4-bit binary string to a hex character
  String _binaryToHex(String binary) {
    int decimalValue = int.parse(binary, radix: 2); // Convert binary to decimal
    return decimalValue
        .toRadixString(16)
        .toUpperCase(); // Convert decimal to hex
  }
}

class BinaryConverter extends Converter {
  @override
  String convert(data) {
    String binary = '';
    for (int i = 0; i < data.length; i++) {
      int hexValue = int.parse(data[i], radix: 16);
      binary += hexValue.toRadixString(2).padLeft(4, '0'); // pad each to 4 bits
    }
    return binary;
  }
}

class DecimalConverter extends Converter {
  @override
  String convert(dynamic data) {
    if (data is String) {
      // Validate that the input is a binary string
      if (!RegExp(r'^[01]+$').hasMatch(data)) {
        throw ArgumentError('Input must be a binary string.');
      }

      // Convert binary string to decimal
      return int.parse(data, radix: 2).toString();
    } else {
      throw ArgumentError('Input must be a binary string.');
    }
  }
}

abstract class Converter {
  String convert(dynamic data);
}