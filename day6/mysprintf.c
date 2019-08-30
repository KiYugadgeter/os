#include <stdarg.h>

int mysprintf(char *s, char *fmt, ...);
int my_sqrt(int i, int n);
int hex2asc(char *s, int t);
int dec2asc(char *s, int t);

int hex2asc(char *s, int t) {
    int len = 0, len_buf;
    int buf[10];
    while (1) {
        buf[len++] = t % 16;
        if (t < 16) {
            break;
        }
        t /= 16;
    }
    for (int i = len - 1; i >= 0; i--) {
        if (buf[i] < 10) {
            *s = buf[i] - 0x30;
        }
        else {
            *s = 87 + buf[i];
        }
        s++;
    }
    return len;
}

int dec2asc(char *s, int t) {
    int len = 0, len_buf;
    int buf[10];
    while (1) {
        buf[len++] = t % 10;
        if (t < 10) {
            break;
        }
        t /= 10;
    }
    for (int i = len - 1; i >= 0; i--) {
        *s = buf[i] + 0x30;
        s++;
    }
    return len;
}

int my_sqrt(int i, int n) {
    for (int p = 0; p < n-1; p++) {
        i *= i;
    }
    return i;
}

int mysprintf(char *s, char *fmt, ...) {
    va_list args;
    int len = 0;
    int count = 0;
    char *padding_start;
    va_start(args, fmt);
    while (*fmt) {
        if (*fmt == '%') {
            fmt++;
            if (*fmt == 'd') {
                len = dec2asc(s, va_arg(args, int));
                count += len;
                fmt++;
                s += len;
            }
            else if (*fmt == 'x') {
                len = hex2asc(s, va_arg(args, int));
                count += len;
                fmt++;
                s += len;
            }
            else {
                char padding_char = *fmt;
                fmt++;
                char *padding_start = fmt;
                int padding_num_len = 0;
                while (*fmt >= 48 && *fmt <= 57) {
                    padding_num_len++;
                    fmt++;
                }
                if (padding_num_len >= 1) {
                    int padding_num = 0;
                    int q = padding_num_len - 1;
                    for (int i1 = padding_num_len - 1; i1 >= 0; --i1) {
                        padding_num +=  (padding_start[i1] - 0x30) * my_sqrt(10, q - i1);
                    }
                    for (int i = 0; i < padding_num; i++) {
                        *s = padding_char;
                        s++;
                    }
                }
            }
        }
        else {
            *s = *fmt;
            s++;
            fmt++;
            count++;
        }
    }
    *s = '\0';
    return count;
}
