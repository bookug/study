#! /usr/bin/env gjs

print("Hello world")
var Book = function(isbn, title){
	this.isbn = isbn;
	this.title = title;
}
Book.prototype = {
	printTitle:function(){
		print("Title is " + this.title);
	},
	printISBN: function(){
		print("ISBN is " + this.isbn);
	}
}

var book = new Book("1234", "qjkxsa")
book.printTitle()
book.printISBN()
book.__proto__ = {
	author:"joe",
	printAuthor:function(){
		print("Author is " + this.author);
	}
}
book.printAuthor()
var anotherbook = new Book("4567", "more");
anotherbook.printTitle()
anotherbook.printISBN()
anotherbook.printAuthor()     //this is invalid

