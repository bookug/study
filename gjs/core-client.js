#! /usr/bin/env seed

GLib = imports.gi.GLib;
Gio = imports.gi.Gio;
GObject = imports.gi.GObject;

Main = new GType({
	parent:GObject.Object.type,
	name:"Main",
	init:function(self)
	{
		this.start = function()
		{
			var address = new Gio.InetAddress.from_string("123.57.165.67");
			var socket = new Gio.InetSocketAddress({address:address, 
			port:9000});
			var client = new Gio.SocketClient();
			var conn = client.connect(socket);
			Seed.printf("connected to server");
			var output = conn.get_output_stream();
			var output_stream = new Gio.DataOutputStream.c_new(output);
			var message = "Hello\n";
			output_stream.put_string(message);
			output.flush();
			var input = conn.get_input_stream();
			var input_stream = new Gio.DataInputStream.c_new(input);
			var data = input_stream.read_upto("\n", 1);
			Seed.printf("Data from server: " + data);
		}
	}
});

var main = new Main();
main.start();

