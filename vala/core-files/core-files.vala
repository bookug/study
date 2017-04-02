using GLib;

public class Main:Object
{
	public Main()
	{
	}
	public void start()
	{
		File file = null;
		string[] files = {"http://en.wikipedia.org/wiki/Text_file",
		"core_files.vala"};
		for(var i = 0; i < files.length; ++i)
		{
			if(files.has_prefix("http:"))
			{
				file = File.new_for_uri(files[i]);
			}
			else
			{
				file = File.new_for_path(files[i]);
			}
			var stream = file.read();
			var data_stream = new DataInputStream(stream);
			size_t data_read;
			var data = data_stream.read_until("", out data_read);
			stdout.printf(data);
		}
	}

	static int main(string[] args)
	{
		var app = new Main();
		app.start();
		return 0;
	}
}

