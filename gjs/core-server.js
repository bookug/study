#! /usr/bin/env seed

GLib = imports.gi.GLib;
GObject = imports.gi.GObject;
Gio = imports.gi.Gio;

Main = new GType({
	parent:GObject.Object.type,
	name:"Main",
	init:function(self)
	{
		this.process = function(connection)
		{
			var input =	new Gio.DataInputStream.c_new(connection.get_input_stream());
			var data = input.read_upto("\n", 1);
			Seed.print("data from client: " + data);
			var output = new Gio.DataOutputStream.c_new(connection.get_output_stream());
			output.put_string(data.toUpperCase());
			output.put_string("\n");
			connection.get_output_stream().flush();
		}
		this.start = function()
		{
			var service = new Gio.SocketService();
			service.add_inet_port(9000, null);
			service.start();
			while(1)
			{
				var connection = service.accept(null);
				this.process(connection);
			}
		}
	}
});

var main = new Main();
main.start();

