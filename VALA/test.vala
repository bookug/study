delegate int CompareDataFunc (int *a, int *b);

void main() {
    int[] d = {9, 3, 4, 8, 5, 7, 6};
    GLib.Array<int> array = new GLib.Array<int>();
    for (int i = 0; i < d.length; i++) { array.append_val (d[i]); }
    
    CompareDataFunc compare = (a, b) => {
        if (*(int *)a > *(int *)b) { return 1; }
        else if (*(int *)a < *(int *)b) { return -1;}
        else return 0;
    };
    array.sort((GLib.CompareFunc<int>)compare);
    
    for (int i = 0; i < array.length; i++) {
        stdout.printf ("%d\n", array.index (i));
    }
}

