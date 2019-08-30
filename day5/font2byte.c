#include <stdio.h>
#include <string.h>

int main() {
    char s[256];
    FILE *in_fp, *out_fp;
    if ((in_fp = fopen("hankaku.txt", "r")) == NULL) {
        printf("input file open error\n");
        return 0;
    }
    
    if ((out_fp = fopen("hankaku.c", "w")) == NULL) {
        printf("output file error\n");
        return 0;
    }
    
    char p[] = "char hankaku[4096] = {\n";
    fwrite(p, sizeof(p)-1, 1, out_fp);
    int counter = 0;
    while (fgets(s, 256, in_fp) != NULL) {
        if (*s != '.' && *s != '*') {
            continue;
        }
        int n = 0;
        for (int i = 0; i <= 7; i++) {
            if (s[i] == '.' ) {
                n = n << 1;
            }
            else if (s[i] == '*') {
                n = n << 1;
                n += 1;
            }
        }
        fprintf(out_fp, "0x%02x,", n);
        counter++;
        if (counter == 16) {
            fwrite("\n", 1, 1, out_fp);
            counter = 0;
        }
    }
    fwrite("};\n", 3, 1, out_fp);
    if(feof(in_fp) == 0) {
        puts("in_fp does not arrive on eof");
        return 0;
    }
    fclose(in_fp);
    fclose(out_fp);
}
