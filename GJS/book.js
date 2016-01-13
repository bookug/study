//#! /usr/bin/env gjs

var Book = function(isbn, title) {
    this.isbn = isbn;
    this.title = title;
}
Book.prototype = {
printTitle:
    function() {
        print("Title is " + this.title);
    },

printISBN:
    function() {
        print("ISBN is " + this.isbn);
    }
}

