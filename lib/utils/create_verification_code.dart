import 'dart:math';

String createToken() {
  Random random = Random();
  int min = 10000000; // Minimum 8-digit number (10,000,000)
  int max = 99999999; // Maximum 8-digit number (99,999,999)
  int randomNumber = min + random.nextInt(max - min + 1);

  String code = randomNumber.toString().padLeft(8, '0');

  return code;
}
