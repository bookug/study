using GLib;

public class Main : Object
{
    int counter = 0;

    bool printCounter() {
        stdout.printf("%d\n", counter++);
		if(counter < 10)
			return true;
		else
			return false;
    }
	//void printCounter()
	//{
	//	stdout.printf("%d\n", counter++);
	//	if(counter >= 10)
	//		loop.quit();
	//}

    public Main ()
    {
        Timeout.add(1000, printCounter);
		//var loop = new MainLoop();
		//loop.run();
    }

    static int main (string[] args)
    {
        Main main = new Main();
        var loop = new MainLoop();
        loop.run ();
        return 0;
    }
}

