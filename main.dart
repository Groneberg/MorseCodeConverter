import 'dart:io';

// Morse Code Converter in Dart
// This program converts text to Morse code and vice versa.
// It uses a map to store the Morse code representations of letters, digits, and some special characters.
// The user can input text to convert to Morse code or Morse code to convert back to text.
// The program continues to run until the user types 'exit'.
Map<String, String> morseCodeMap = {
  // letters
  "a": ".-",
  "b": "-...",
  "c": "-.-.",
  "d": "-..",
  "e": ".",
  "f": "..-.",
  "g": "--.",
  "h": "....",
  "i": "..",
  "j": ".---",
  "k": "-.-",
  "l": ".-..",
  "m": "--",
  "n": "-.",
  "o": "---",
  "p": ".--.",
  "q": "--.-",
  "r": ".-.",
  "s": "...",
  "t": "-",
  "u": "..-",
  "v": "...-",
  "w": ".--",
  "x": "-..-",
  "y": "-.--",
  "z": "--..",

  // numbers
  "0": "-----",
  "1": ".----",
  "2": "..---",
  "3": "...--",
  "4": "....-",
  "5": ".....",
  "6": "-....",
  "7": "--...",
  "8": "---..",
  "9": "----.",

  // special characters
  ".": ".-.-.-",
  ",": "--..--",
  "?": "..--..",
  "'": ".----.",
  "!": "-.-.--",
  "/": "-..-.",
  "(": "-.--.",
  ")": "-.--.-",
  "&": ".-...",
  ":": "---...",
  ";": "-.-.-.",
  "=": "-...-",
  "+": ".-.-.",
  "-": "-....-",
  "_": "..--.-",
  "\"": ".-..-.",
  "\$": "...-..-",
  "@": ".--.-.",
};

void main() {
  // Regular expression to validate user input for options
  // The user can enter 1 or 2 to select the conversion type
  RegExp regExp = RegExp(r"^(?:[1-9]|10)$");
  String morseCode = "";
  String text = "";
  bool isRunning = true;

  do {
    print("Enter 1 to convert text to Morse:");
    print("Enter 2 to convert Morse to text:");
    print("Enter 3 to convert text to Morse and save to file:");
    print("Enter 4 to read Morse code from file and convert it to text:");
    print("Enter 'exit' to quit):");
    String option = stdin.readLineSync() ?? "";
    option = option.trim().toLowerCase();
    if (!regExp.hasMatch(option) && option != "exit") {
      print("Invalid input. Please enter one of the given options (1, 2, 3, or 'exit').");
      continue;
    }
  
    switch (option) {
      case "exit":
        isRunning = false;
        print("Exiting the program.");
        break;
      case "1":
          morseCode = textToMorse();
          print("Morse Code: $morseCode");
        break;
      case "2":
          text = morseToText();
          print("Converted to text: $text");
        break;
      case "3":
        morseCode = textToMorse();
        print("Morse Code: $morseCode");
        saveToFile(morseCode);
        break;
      case "4":

        String morseFromFile = readFromFile();
        if (morseFromFile.isNotEmpty) {
          text = morseToText(morseCode: morseFromFile);
          print("Converted to text: $text");
        }
        break;
      default:
        {
          print("Invalid option. Please try again.");
          continue;
        }
    }
  } while (isRunning);
}

void saveToFile(String content) async {
  print("Enter filename to save Morse code:");
  String filename = stdin.readLineSync() ?? "";
  String filePath = './$filename.txt';
  try {
    File file = File(filePath);
    await file.writeAsString(content);
    print("Content saved to $filePath successfully.");
  } catch (e) {
    print("Error saving to file: $e");
  }
}

String readFromFile() {
  print("Enter filename to read Morse code from:");
  String filename = stdin.readLineSync() ?? "";
  String filePath = './$filename.txt';
  try {
    File file = File(filePath);
    String content = file.readAsStringSync();
    return content;
  } catch (e) {
    print("Error reading from file: $e");
    return "";
  }
}

String textToMorse() {
  print("Enter text to convert to Morse code:");
  String text = stdin.readLineSync() ?? "";
  String morseCode = "";
  // Iterate through each character in the input text
  for (var i = 0; i < text.length; i++) {
    // Check if the character is in the Morse code map
    morseCode += morseCodeMap[text[i]] ?? " ";
    // If the character is a space, add a separator for words
    if (text[i] == " ") {
      morseCode += " / "; // Add a separator for words
      // If the character is not found in the Morse code map, add a space
    } else {
      morseCode += " "; // Add space between letters
    }
  }
  // Return the Morse code string
  return morseCode.trim();
}

String morseToText({String? morseCode}) {
  if (morseCode == null) {
    print(
        "Enter Morse code to convert to text (use spaces between letters and ' / ' between words):",
    );
    morseCode = stdin.readLineSync() ?? "";
  }
  String text = "";
  // Split the Morse code by words (using " / " as a separator)
  List<String> morseWords = morseCode.split(" / ");
  // Iterate through each Morse word
  for (var morseWord in morseWords) {
    // Split the Morse word into individual Morse letters
    List<String> morseLetters = morseWord.trim().split(" ");
    // Iterate through each Morse letter
    for (var morseLetter in morseLetters) {
      // Find the corresponding letter for the Morse code
      String letter = morseCodeMap.entries
          .firstWhere(
            // Check if the Morse code matches
            (entry) => entry.value == morseLetter,
            // If not found, return a default value
            orElse: () => MapEntry("", ""),
          )
          .key;
      // Append the letter to the text
      text += letter;
    }
    text += " "; // Add space between words
  }
  return text.trim();
}
