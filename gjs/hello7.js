#! /usr/bin/env gjs

print("hello")
var Book = function(isbn, title) {
	this.isbn = isbn;
	this.title = title;
}

var book = new Book("1234", "whids")
print(book)
print(book.isbn)
print(book.title)

Book.prototype = {
	printTitle: function(){
		print("Title is " + this.title)
	},
	printISBN: function(){
		print("ISBN is " + this.isbn)
	},
	getISBN: function(){
		return this.isbn;
	},
	getTitle: function(){
		return this.title;
	}
}
var book = new Book("7387", "qjdixqew")
book.printTitle()
book.printISBN()

