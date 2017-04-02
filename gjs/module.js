#! /usr/bin/env gjs

print("hello")
imports.searchPath.unshift('.');
var BookModule = imports.book
var book = new BookModule.Book("72187", "ious")
book.printTitle()
book.printISBN()

