#! /usr/bin/env gjs

print("Hello World")
var boxes = []     //declare an array
for(var i = 0; i < 10; ++i)
{
	boxes[i] = i * 2;
}
boxes[1] = "sb"
for(i = 0; i < boxes.length; ++i)
{
	print("Box content #" + i + " is " + boxes[i])
}
