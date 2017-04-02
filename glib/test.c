#include <glib.h>

gint int_compare (gconstpointer a, gconstpointer b) {
        if (*((gint *)a) > *((gint *)b))
                return 1;
        else if (*((gint *)a) == *((gint *)b))
                return 0;
        else
                return -1;
}

int main (void) {
        int d[] = {9, 3, 4, 8, 5, 7, 6};
        GArray *array = g_array_new (FALSE, FALSE, sizeof(int));
        for (guint i = 0; i < 7; i++) {
                g_array_append_val (array, d[i]);
        }

        g_array_sort (array, int_compare);

        for (guint i = 0; i < 7; i++) {
                g_print ("%d\n", g_array_index (array, int, i));
        }
}

