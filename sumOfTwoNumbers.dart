import 'dart:io';

void main(){

  String readInput(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync() ?? '';
  }

  String input1 = readInput('Enter the first number:');
  String input2 = readInput('Enter the second number:');

  int num1 = int.tryParse(input1) ?? 0;
  int num2 = int.tryParse(input2) ?? 0;

  int sum = num1 + num2;
  print('The sum of $num1 and $num2 is $sum');
}
