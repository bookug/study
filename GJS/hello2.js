#! /usr/bin/env gjs

print("Hello World");
var number = 1;
print(number);
number = number + 0.5;
print(number);
print(number.length);
number = number + " is a number? no, it is now a string";
print(number);
print(number.length);
number = (number.length == 0)
print(number);
number = undefined;
print(number);
print(number.length);

