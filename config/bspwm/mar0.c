#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

#define BLK_BUF_SIZE 1024U
#define WS_NAME_BUF_SIZE 32U
#define CMD_BUF_SIZE 8192U
#define JSON_BUF_SIZE CMD_BUF_SIZE
#define STATUS_BUF_SIZE 1024U

static char *colfocus = "#B04080",
            *colunfocus = "#243236",
            *colurgent = "#632627";

#define BGXPAD "11"
#define BGRAD "3"
#define BGYPAD "2"
#define MARGIN "2"

FILE *rpopen (char *fmt, ...);
char *colondup (const char *s);
size_t coloncpy (char *dst, const char *src, size_t size);
void show_workspaces (const char *status, int print_to_stdout);
void switch_workspace (const char *status, int btn, int blk, const char *out);
void start_as_daemon (void);

int main (int argc, char **argv) {
    (void)argv;
    if (argc > 1)
        start_as_daemon ();

    char *blk_btn_s = getenv ("BLOCK_BUTTON");
    char *sub_blk_s = getenv ("SUBBLOCK");
    char *bar_out_s = getenv ("BAR_OUTPUT");
    
    int btn = -1, blk = -1;
    if (blk_btn_s) btn = atoi (blk_btn_s);
    if (sub_blk_s) blk = atoi (sub_blk_s);

    FILE *p;
    char status[STATUS_BUF_SIZE] = { 0 };
    p = popen ("bspc subscribe -c 1", "r");
    fgets (status, STATUS_BUF_SIZE, p);
    switch_workspace (status, btn, blk, bar_out_s);

    /* reopen process, as i am too lazy
     * to check if switch actually occured in switch_workspace
     */
    pclose (p);
    p = popen ("bspc subscribe -c 1", "r");
    fgets (status, STATUS_BUF_SIZE, p);
    show_workspaces (status, 1);
    pclose (p);
    return 0;
}

FILE *rpopen (char *fmt, ...) {
    char buf[CMD_BUF_SIZE + 1];
    va_list vl;
    va_start (vl, fmt);
    vsnprintf (buf, CMD_BUF_SIZE, fmt, vl);
    va_end (vl);
    return popen (buf, "r");
}

char *colondup (const char *s) {
    char *colon = strchr (s, ':');
    if (!colon) return strdup (s);
    char *rc = malloc (colon - s + 1);
    memcpy (rc, s, colon - s);
    rc[colon - s] = 0;
    return rc;
}

size_t coloncpy (char *dst, const char *src, size_t size) {
    if (!size) return 0U;
    size_t i;
    for (i = 0; i < size - 1 && src[i] && src[i] != ':'; ++i)
        dst[i] = src[i];
    
    dst[i] = 0;
    return i;
}

#define CHAR_IN(__c, __s) (strchr (__s, __c) != NULL)
void switch_workspace (const char *status, int btn, int blk, const char *bar_out) {
    const char *ws = status;
    int ws_num = 0, idx = 0;
    switch (btn) {
    case 1:
        while ((ws = strchr (ws, ':'))) {
            ws++;
            ws_num++;
            if (CHAR_IN (*ws, "FoOuU"))
                idx++;
            if (idx == blk + 1) {
                rpopen ("bspc desktop -f %s:^%d", bar_out, ws_num);
                break;
            }
        }
        break;
    case 4:
        rpopen ("bspc desktop -f '%s:focused#prev.occupied'", bar_out);
        break;
    case 5:
        rpopen ("bspc desktop -f '%s:focused#next.occupied'", bar_out);
        break;
    case -1:
    default:
        break;
    }
}
#undef CHAR_IN

void show_workspaces (const char *status, int print_to_stdout) {
    char *disp_name = colondup (status + 2);
    status = strchr (status, ':');
    if (!status) return;
    status++;

    char jsonbuf[JSON_BUF_SIZE] = { 0 };
    char blkbuf[BLK_BUF_SIZE]  = { 0 };
    int first = 1;
    while (status && status[0]) {
        char *col = colunfocus;
        char ws_name[WS_NAME_BUF_SIZE] = { 0 };

        switch (status[0]) {
            case 'o':
                col = colunfocus; break;
            case 'O':
            case 'F':
            case 'U':
                col = colfocus; break;
            case 'u':
                col = colurgent; break;
            case ':':
                break;
            default:
                goto cont;
                break;
        }

        coloncpy (ws_name, status + 1, WS_NAME_BUF_SIZE);

        static const char *fmt = 
                "%s{\"text\": \"%s\", "
                "\"background\": \"%s\","
                "\"bgxpad\": " BGXPAD ","
                "\"bgrad\": " BGRAD ","
                "\"bgypad\": " BGYPAD ","
                "\"margin\": " MARGIN
                "}";
 
        snprintf (blkbuf, BLK_BUF_SIZE, fmt, first ? "" : ",", ws_name, col);

        strcat (jsonbuf, blkbuf);
        first = 0;
cont:
        status = strchr (status, ':');
        if (status) status++;
    }

    if (print_to_stdout)
        printf ("{\"subblocks\": [%s]}", jsonbuf), fflush (stdout);
    else
        rpopen ("bbc property 1:%s execdata '{\"subblocks\": [%s]}'", disp_name, jsonbuf);

    free (disp_name);
}

void start_as_daemon () {
    FILE *subscribe = popen ("bspc subscribe", "r");
    char status[STATUS_BUF_SIZE] = { 0 };
    while (fgets (status, STATUS_BUF_SIZE, subscribe)) {
        show_workspaces (status, 0);
    }
}

