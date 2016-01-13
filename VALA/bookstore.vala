using GLib;

public class BookStore
{
	private Book book;
	private double price = 0.0;
	private int stock = 0;

	public BookStore(Book book, double price, int stock)
	{
		this.book = book;
		this.price = price;
		this.stock = stock;
	}
	public int getStock()
	{
		return stock;
	}
	public void removeStock(int amount)
	{
		stock -= amount;
		if(stock < 5)
		{
			stockAlert();
		}
	}
	public void addStock(int amount)
	{
		stock += amount;
	}
	public double getPrice()
	{
		return price;
	}
	public void setPrice(double price)
	{
		this.price = price;
		if(this.price < 1)
		{
			priceAlert(price);
		}
	}
	public bool isAvailable()
	{
		return stock > 0;
	}

	public signal void stockAlert();
	public signal void priceAlert(double price);
}

