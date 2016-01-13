using GLib;

public class Main : Object
{
    public Main ()
    {
        var book = new Book("1234", "A new book");
        book.printISBN ();

        var store = new BookStore(book, 4.2, 10);
		store.stockAlert.connect(() => {
				stdout.printf("oh, we are going to run out stock!\n");
				});
		store.priceAlert.connect((price) => {
				stdout.printf("oh, price %f is too low!\n", price);
				});
        stdout.printf ("Initial stock is %d\n", store.getStock());
        stdout.printf ("Initial price is $ %f\n", store.getPrice());
        store.removeStock(4);
        store.setPrice(5.0);
        stdout.printf ("Stock is %d\n", store.getStock());
        stdout.printf ("and price is now $ %f\n", store.getPrice());
		store.removeStock(4);
        var status = "still available";
        if (store.isAvailable() == false) {
            status = "not available";
        }
        stdout.printf ("And the book is %s\n", status);
		store.setPrice(0.2);
    }

    static int main (string[] args)
    {
        stdout.printf ("Hello, world\n");
        var main = new Main();
        return 0;
    }
}

