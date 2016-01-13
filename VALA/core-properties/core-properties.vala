using GLib;

public class Main : Object
{
  public int counter {
    set construct;
    get;
    default = 0;
  }

  public bool print_counter() {
    stdout.printf("%d\n", counter ++);
    return true;
  }

  public void monitor_counter() {
    stdout.printf ("Counter value has changed to %d\n", counter);
  }

  public Main ()
  {
  }

  construct {
    Timeout.add(1000, print_counter);
    notify["counter"].connect ((obj)=> {
      monitor_counter ();
    });
  }

  static int main (string[] args)
  {
    Gtk.init (ref args);
    var app = new Main ();
    Gtk.main ();
    return 0;
  }
}

