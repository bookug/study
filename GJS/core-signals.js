#!/usr/bin/env seed

GLib = imports.gi.GLib;
GObject = imports.gi.GObject;

Main = new GType({
  parent: GObject.Object.type,
  name: "Main",
  signals: [
    {
      name: "alert",
      parameters: [GObject.TYPE_INT]
    }
  ],
  init: function(self) {
    var counter = 0;

    this.printCounter = function() {
      Seed.printf("%d", counter++);
      if (counter > 9) {
        self.signal.alert.emit(counter);
      }
      return true;
    };

    GLib.timeout_add(0, 1000, this.printCounter);
  }
});

var main = new Main();

var context = GLib.main_context_default();
var loop = new GLib.MainLoop.c_new(context);

main.signal.connect('alert', function(object, counter) {
  Seed.printf("Counter is %d, let's stop here", counter);
  loop.quit();
});
loop.run();

