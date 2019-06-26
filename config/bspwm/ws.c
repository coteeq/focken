#define _DEFAULT_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <assert.h>

#define BLOCK_BUF_SIZE 1024U
#define VALUE_BUF_SIZE 32U
#define CMD_BUF_SIZE 8192U
#define OUTPUT_BUF_SIZE CMD_BUF_SIZE
#define STATUS_BUF_SIZE 1024U

static const char *COLFOCUS   = "#B04080";
static const char *COLUNFOCUS = "#243236";
static const char *COLURGENT  = "#632627";
static const char *COLLAYOUT  = "#008080";
static const char *COLSTATE   = "#008080";


#define BGXPAD "11"
#define BGRAD "3"
#define BGYPAD "2"
#define MARGIN "2"


int rpopen (char *fmt, ...);
char *colondup (const char *s);
size_t coloncpy (char *dst, const char *src, size_t size);
void show_workspaces (const char *status);
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
    pclose (p);
    /* daemon will redraw for us, if necessary */
    return 0;
}

int rpopen (char *fmt, ...) {
    char buf[CMD_BUF_SIZE + 1];
    va_list vl;
    va_start (vl, fmt);
    vsnprintf (buf, CMD_BUF_SIZE, fmt, vl);
    va_end (vl);
    pid_t exec_pid = fork ();
    int status = 0;
    switch (exec_pid) {
        case -1:
            abort ();
        case 0:
            execlp ("/bin/sh", "/bin/sh", "-c", buf, (char *)NULL);
            abort ();
        default:
            do {
                waitpid (exec_pid, &status, 0);
            } while (!WIFEXITED (status));
    }
    return 0;
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

void show_workspaces (const char *status) {
    const char *display_name = status + 2;
    status = strchr (status, ':');
    int display_name_len = status - display_name;

    char result[OUTPUT_BUF_SIZE] = { 0 };
    char layout_buf[BLOCK_BUF_SIZE] = { 0 };
    char block[BLOCK_BUF_SIZE] = { 0 };

    static const char *template =
            "%s{\"text\": \"%.*s\", "
            "\"background\": \"%s\","
            "\"bgxpad\": " BGXPAD ","
            "\"bgrad\": " BGRAD ","
            "\"bgypad\": " BGYPAD ","
            "\"margin\": " MARGIN "}";


    while (status) {
        const char *color = COLUNFOCUS;
        switch (*++status) {
            case 'o':
                color = COLUNFOCUS; break;
            case 'O':
            case 'F':
            case 'U':
                color = COLFOCUS; break;
            case 'u':
                color = COLURGENT; break;
            case 'L':
                color = COLLAYOUT; break;
            case ':':
                continue;
            case 'f':
            case 'T':
                status = strchr (status, ':');
                continue;
            default:
                status = NULL; /* Hack to exit loop */
                continue;
        }
    
        char *next_colon = strchr (status, ':');
        int value_len = next_colon ?
                (int)(next_colon - status) :
                (int)strlen (status);

        if (status[value_len - 1] == '\n')/* Reached end of report */
            value_len--;

        snprintf (block, BLOCK_BUF_SIZE, template,
                  ",",
                  value_len - 1,
                  status + 1,
                  color);

        if (*status == 'L')
            strcpy (layout_buf, block + 1); /* Dont include leading comma */
        else
            strcat (result, block);
        status = strchr (status, ':');
    }

    
    rpopen ("bbc property 1:%.*s execdata '{\"subblocks\": [%s%s]}'",
            display_name_len, display_name,
            layout_buf,
            result);
}

void start_as_daemon () {
    //assert (daemon (0, 0) == 0);
    FILE *subscribe = popen ("bspc subscribe", "r");
    char status[STATUS_BUF_SIZE] = { 0 };
    while (fgets (status, STATUS_BUF_SIZE, subscribe)) {
        show_workspaces (status);
    }
    pclose (subscribe);
    exit (EXIT_FAILURE);
}

