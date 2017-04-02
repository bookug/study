using GLib;

public class Main:Object
{
	public Main()
	{
		var book = new Book("1234", "a new book");
		book.printISBN();
	}
	static int main(string[] args)
	{
		stdout.printf("hello, world\n");
		var	main = new Main();
		return 0;
	}
}

