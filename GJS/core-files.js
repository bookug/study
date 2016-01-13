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
			var file = null;
			var files = ["http://en.wikipedia.org/wiki/Text_file",
			"core-files.js"];
			for(var i = 0; i < files.length; ++i)
			{
				if(files[i].match(/^http:/))
				{
					file = Gio.file_new_for_uri(files[i]);
				}
				else
				{
					file = Gio.file_new_for_path(files[i]);
				}
				var stream = file.read();
				var data_stream = new Gio.DataInputStream.c_new(stream);
				var data = data_stream.read_until("", 0);
				Seed.print(data);
			}
		}
	}
});

var main = new Main();
main.start();

