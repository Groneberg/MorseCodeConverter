import 'dart:io'; // Imports the dart:io library for file operations and standard input/output.
import 'data.dart'; // Imports a custom 'data.dart' file, containing 'morseCodeMap'.

// Morse Code Converter in Dart
// This program converts text to Morse code and vice versa.
// It uses a map to store the Morse code representations of letters, digits, and some special characters.
// The user can input text to convert to Morse code or Morse code to convert back to text.
// The program continues to run until the user types 'exit'.

Future<void> main() async {
  // Regular expression to validate user input for options
  // The user can enter 1, 2, 3, or 4 to select the conversion type
  // This regex matches single digits 1-9 or the number 10.
  // Although the current options are 1, 2, 3, 4, the regex allows up to 10.
  RegExp regExp = RegExp(r"^(?:[1-9]|10)$");
  String morseCode = ""; // Variable to store Morse code strings.
  String text = ""; // Variable to store plain text strings.
  bool isRunning = true; // Control flag for the main program loop.

  // Main loop for the Morse Code Converter program
  do {
    // Display menu options to the user.
    print("Enter 1 to convert text to Morse:");
    print("Enter 2 to convert Morse to text:");
    print("Enter 3 to convert text to Morse and save to file:");
    print("Enter 4 to read Morse code from file and convert it to text:");
    print("Enter 'exit' to quit):");

    // Read user input from the console.
    // Use '?? ""' to handle potential null input (e.g., if stdin is closed).
    String option = stdin.readLineSync() ?? "";
    option = option.trim().toLowerCase(); // Clean and normalize the input.

    // Validate user input using the regular expression or check for 'exit'.
    if (!regExp.hasMatch(option) && option != "exit") {
      print(
        "Invalid input. Please enter one of the given options (1, 2, 3, or 'exit').",
      );
      continue; // Skip to the next iteration of the loop if input is invalid.
    }

    // Process the user's selected option using a switch statement.
    switch (option) {
      case "exit":
        isRunning = false; // Set flag to false to exit the loop.
        print("Exiting the program.");
        break;
      case "1":
        morseCode = textToMorse(); // Call function to convert text to Morse.
        print("Morse Code: $morseCode"); // Print the result.
        break;
      case "2":
        // Call function to convert Morse to text.
        // Since morseToText can take an optional named parameter,
        // calling it without explicitly passing a value will trigger its internal stdin.readLineSync().
        text = morseToText();
        print("Converted to text: $text"); // Print the result.
        break;
      case "3":
        morseCode = textToMorse(); // Convert text to Morse.
        print("Morse Code: $morseCode"); // Print the Morse code.
        await saveToFile(morseCode); // Save the generated Morse code to a file.
        break;
      case "4":
        String morseFromFile = readFromFile(); // Read Morse code from a file.
        // If content was successfully read, convert it to text.
        if (morseFromFile.isNotEmpty) {
          text = morseToText(
            morseCode: morseFromFile,
          ); // Pass the file content as a named parameter.
          print("Converted to text: $text"); // Print the result.
        }
        break;
      default:
        {
          print(
            "Invalid option. Please try again.",
          ); // Fallback for unexpected options (though regex should catch most).
          continue; // Skip to the next loop iteration.
        }
    }
  } while (isRunning); // Continue looping as long as isRunning is true.
}

// Function to save content to a file.
// It's marked 'async' because 'file.writeAsString' is an asynchronous operation.
// Future<void> is used to indicate that this function will complete in the future.
// It is a “promise” that a value (or an error) will be returned at a later time.
Future<void> saveToFile(String content) async {
  print("Enter filename to save Morse code:");
  String filename = stdin.readLineSync() ?? ""; // Get filename from user.
  String filePath = './$filename.txt'; // Construct the file path.
  try {
    File file = File(filePath); // Create a File object.
    await file.writeAsString(content); // Write the content to the file, overwriting if it exists.
    print("Content saved to $filePath successfully.");
  } catch (e) {
    print(
      "Error saving to file: $e",
    ); // Catch and print any errors during file writing.
  }
}

// Function to read content from a file.
// It's not marked 'async' because it uses 'readAsStringSync()' for synchronous reading.
String readFromFile() {
  print("Enter filename to read Morse code from:");
  String filename = stdin.readLineSync() ?? ""; // Get filename from user.
  String filePath = './$filename.txt'; // Construct the file path.
  try {
    File file = File(filePath); // Create a File object.
    String content = file
        .readAsStringSync(); // Read the entire file content synchronously.
    return content; // Return the content.
  } catch (e) {
    print(
      "Error reading from file: $e",
    ); // Catch and print any errors during file reading.
    return ""; // Return an empty string if an error occurs.
  }
}

// Function to convert plain text to Morse code.
String textToMorse() {
  print("Enter text to convert to Morse code:");
  String text = stdin.readLineSync() ?? ""; // Get text input from user.
  String morseCode = ""; // Initialize empty string for Morse code output.

  // Iterate through each character in the input text.
  for (var i = 0; i < text.length; i++) {
    String char = text[i]; // Get character from the word
    // Check if the character is in the Morse code map.
    // 'morseCodeMap' is defined in 'data.dart'.
    if (char == " ") {
      morseCode += " / "; // Add a word separator for spaces.
    } else if (morseCodeMap.containsKey(char)) {
      morseCode +=
          morseCodeMap[char]!; // Append the Morse code for the character.
      morseCode += " "; // Add space between Morse letters.
    } else {
      // If the character is not found and it's not a space, add a space (or handle as unknown char).
      morseCode += " ";
    }
  }
  // Return the Morse code string, trimming any trailing space.
  return morseCode.trim();
}

// Function to convert Morse code to plain text.
// Takes an optional named parameter 'morseCode'. If not provided, it prompts the user.
String morseToText({String? morseCode}) {
  // If no Morse code is provided as a parameter, ask the user for input.
  if (morseCode == null) {
    print(
      "Enter Morse code to convert to text (use spaces between letters and ' / ' between words):",
    );
    morseCode = stdin.readLineSync() ?? ""; // Get Morse code input from user.
  }
  String text = ""; // Initialize empty string for text output.

  // Split the Morse code by words (using " / " as a separator)
  List<String> morseWords = morseCode.split(" / ");

  // Iterate through each Morse word
  for (var morseWord in morseWords) {
    // Split the Morse word into individual Morse letters
    // .trim() removes any leading/trailing whitespace from the word.
    List<String> morseLetters = morseWord.trim().split(" ");

    // Iterate through each Morse letter
    for (var morseLetter in morseLetters) {

      // Skip empty strings that might result from multiple spaces or trimming.
      if (morseLetter.isEmpty) continue;

      // Find the corresponding letter for the Morse code in the map.
      String letter = morseCodeMap.entries
          .firstWhere(
            // Check if the Morse code value matches the current morseLetter.
            (entry) => entry.value == morseLetter,
            // If not found, return a default MapEntry.
            // Its key will be used, resulting in an empty string if the Morse is unknown.
            orElse: () => MapEntry("", ""),
          )
          .key; // Get the letter (key) from the found entry.

      // Append the decoded letter to the text.
      text += letter;
    }
    text += " "; // Add space between words
  }
  return text.trim(); // Return the converted text, trimming any trailing space.
}
