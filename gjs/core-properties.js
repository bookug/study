#! /usr/bin/env seed

GLib = imports.gi.GLib;
GObject = imports.gi.GObject;

Main = new GType({
	parent:GObject.Object.type,
	name:"Main",
	properties:[
	{
		name:'counter',
		type:GObject.TYPE_INT,
		default_value:0,
		minimum_value:0,
		maximum_value:1024,
		flags:(GObject.ParamFlags.CONSTRUCT
				| GObject.ParamFlags.READABLE
				| GObject.ParamFlags.WRITABLE),

	}
	],
	init:function(self)
	{
		this.print_counter = function()
		{
			Seed.printf("%d", slef.counter++);
			return true;
		}
		this.monitor_counter = function(obj, gobject, data)
		{
			Seed.print("Counter value has changed to " + obj.counter);
		}
		GLib.timeout_add(0, 100, this.print_counter);
	}
});

var main = new Main();
var context = GLib.main_context_default();
var loop = new GLib.MainLoop.c_new(context);
loop.run();

